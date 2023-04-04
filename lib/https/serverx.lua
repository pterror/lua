-- TODO: refactor out to tls/server.lua
-- IMPL
local ffi = require("ffi")
local socket = require("lib.socket.server")
local tls = require("dep.tls")
local http_server = require("lib.http.serverx")
local epoll_ = require("dep.epoll")

local mod = {}

-- https://github.com/bob-beck/libtls/blob/master/TUTORIAL.md
--[[@return unknown conn, fun() tls_free]]
mod.new = function (certfile, keyfile)
	local config = tls.config_new()
	tls.config_set_ca_file(config, tls.default_ca_cert_file())
	tls.config_set_keypair_file(config, certfile, keyfile)
	local tls_ = tls.server()
	tls.configure(tls_, config)
	return tls_, function ()
		tls.free(tls_)
		tls.config_free(config)
	end
end

-- TODO: https.server
-- TODO: fix how epoll is passed

--[[@param handler http_like_callbacks]] --[[@param tls_ unknown]] --[[@param epoll epoll]]
mod.make_connection_handler = function (handler, tls_, epoll)
	--[[@param client luajitsocket]] --[[@param state { [0]: tls_c }?]]
	return function (client, state)
		if not state then
			local client_tls_ptr = tls.tls_c_ptr()
			tls.accept_socket(tls_, client_tls_ptr, client.fd)
			local client_tls = client_tls_ptr[0]
			-- TODO: consider changing default size
			local buf = ffi.new("unsigned char[65536]")
			local wrapped_client = setmetatable({
				send = function (data)
					tls.write(client_tls, data, #data)
				end,
				receive = function ()
					return tls.read(client_tls, buf, 65536)
				end,
			}, { __index = client })
			state = {
				inner = http_server.make_connection_handler(handler, epoll),
				client = wrapped_client
			}
		end
		-- FIXME: return state
		return state.inner(state.client)
		-- tls.write(state[0], s, #s)
	end
end

--[[@param handler http_callback|http_like_callbacks]]
--[[@param keyfile string]] --[[@param certfile string]] --[[@param port? integer]] --[[@param epoll? epoll]]
mod.server = function (handler, certfile, keyfile, port, epoll)
	epoll = epoll or epoll_:new()
	if type(handler) == "function" then handler = { http = handler } end
	--[[FIXME: use tls_free]]
	local tls_, tls_free = mod.new(certfile, keyfile)
	local client_ctx = ffi.new("FIXME")
	tls.accept_socket(tls_, client_ctx, socket)
	return socket.server(mod.make_connection_handler(handler, tls_, epoll), port or 443, epoll)
end

return mod

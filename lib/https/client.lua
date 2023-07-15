local ffi = require("ffi")
local socket = require("dep.ljsocket")
local tls = require("dep.tls")
local format = require("lib.http.format")

local mod = {}

--[[TODO: the heck does tls_config_insecure_noverifycert do]]
local client_tls = tls.client()
local tls_config = tls.config_new()
tls.config_insecure_noverifycert(tls_config)
tls.config_insecure_noverifyname(tls_config)
tls.configure(client_tls, tls_config)

--[[IMPL: https://github.com/CapsAdmin/luajitsocket/blob/master/examples/tcp_client_blocking_tls.lua]]

--[[@param req http_client_request]]
mod.request = function (req)
	req.body = req.body or ""
	-- are domains case sensitive?
	local client = assert(socket.create("inet", "stream", "tcp"))

	socket.on_connect = function (self, host, serivce)
		if tls.connect_socket(client_tls, self.fd, host) < 0 then return nil, ffi.string(tls.error(client_tls)) end
		if tls.handshake(client_tls) < 0 then return nil, ffi.string(tls.error(client_tls)) end
		return true
	end

	client.on_send = function (self, data, flags)
		local len = tls.write(client_tls, data, #data)
		if len < 0 then return nil, ffi.string(tls.error(client_tls)) end
		return len
	end

	socket.on_receive = function (self, buffer, max_size, flags)
		local len = tls.read(client_tls, buffer, max_size)
		if len < 0 then return nil, ffi.string(tls.error(client_tls)) end
		return ffi.string(buffer, len)
	end

	assert(client:connect(req.host, "https"))
	--[[this should be case insensitive]]
	req.headers["User-Agent"] = req.headers["User-Agent"] or "lua_https_client/0.0.1"
	assert(client:send(format.http_client_request_to_string(req)))
	--[[TODO: other default headers - language]]
	--[[if not headers[""] ]]
end

return mod

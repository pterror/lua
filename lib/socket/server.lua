local socket = require("dep.ljsocket")
local epoll_ = require("dep.epoll")

local mod = {}

--[[@generic t]]
--[[@return luajitsocket sock]]
--[[@param callback fun(client: luajitsocket, state: t): t]]
--[[@param port integer]]
--[[@param epoll? epoll]]
--[[@param host? ("*"|"unix"|string|{ addrinfo: unknown; })?]]
--[[@param on_client? fun(client: luajitsocket)]]
mod.server = function(callback, port, epoll, host, on_client)
	--[[@diagnostic disable-next-line: undefined-field]]
	epoll = epoll or _G.epoll
	local is_running = not epoll
	epoll = epoll or epoll_.new()

	--[[https://github.com/CapsAdmin/luajitsocket/blob/acb3bc3236cb4551a477a74f2bc9305860ca6492/examples/tcp_server_blocking.lua]]
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	local server = assert(socket.bind(host or "*", port))
	assert(server:listen())

	local _, remove = epoll:add(server.fd, function()
		local client = server:accept()
		if not client then return end --[[silently fail]]
		local state, remove
		local client_close = client.close
		--[[@diagnostic disable-next-line: duplicate-set-field]]
		client.close = function()
			client_close(client)
			--[[@diagnostic disable-next-line: need-check-nil]]
			remove()
		end
		_, remove = epoll:add(client.fd, function() state = callback(client, state) end, client.close)
		if on_client then on_client(client) end
	end, is_running and function() is_running = false end or nil)
	local server_close = server.close
	--[[@diagnostic disable-next-line: duplicate-set-field]]
	server.close = function(self)
		server_close(self)
		--[[@diagnostic disable-next-line: need-check-nil]]
		remove()
	end

	while is_running do epoll:wait() end

	return server
end

return mod

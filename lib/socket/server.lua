local socket = require("dep.ljsocket")
local epoll_ = require("dep.epoll")

local mod = {}

--[[TODO: consider multithreading]]

--[[@generic t]]
--[[@return luajitsocket sock]]
--[[@param callback fun(client: luajitsocket, state: t): t]] --[[@param port integer]] --[[@param epoll? epoll]]
mod.server = function (callback, port, epoll)
	--[[@diagnostic disable-next-line: undefined-field]]
	epoll = epoll or _G.epoll
	local is_running = not epoll
	epoll = epoll or epoll_.new()

	--[[https://github.com/CapsAdmin/luajitsocket/blob/acb3bc3236cb4551a477a74f2bc9305860ca6492/examples/tcp_server_blocking.lua]]
	local server = assert(socket.bind("*", port), "socket/server: socket:bind failed")
	assert(server:listen(), "socket/server: socket:listen failed")

	local _, remove = epoll:add(server.fd, function ()
		local client = server:accept()
		if not client then return end --[[silently fail]]
		local state, remove
		local client_close = client.close
		_, remove = epoll:add(
			client.fd,
			function () state = callback(client, state) end,
			--[[@diagnostic disable-next-line: need-check-nil]]
			function () client_close(client); remove() end
		)
		--[[@diagnostic disable-next-line: duplicate-set-field, need-check-nil]]
		client.close = function (self) client_close(self); remove() end
	end, is_running and function () is_running = false end or nil)
	local server_close = server.close
	--[[@diagnostic disable-next-line: duplicate-set-field, need-check-nil]]
	server.close = function (self) server_close(self); remove() end

	while is_running do epoll:wait() end

	return server
end

return mod

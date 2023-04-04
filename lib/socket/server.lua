local socket = require("dep.ljsocket")
local epoll_ = require("dep.epoll")

local mod = {}

--[[TODO: consider multithreading]]

--[[@generic t]]
--[[@param callback fun(client: luajitsocket, state: t): t]] --[[@param port integer]] --[[@param epoll? epoll]]
mod.server = function (callback, port, epoll)
	local is_running = not epoll
	epoll = epoll or epoll_.new()

	--[[https://github.com/CapsAdmin/luajitsocket/blob/acb3bc3236cb4551a477a74f2bc9305860ca6492/examples/tcp_server_blocking.lua]]
	local server = assert(socket.bind("*", port), "socket/server: socket:bind failed")
	assert(server:listen(), "socket/server: socket:listen failed")

	epoll:add(server.fd, function ()
		local client = server:accept()
		if not client then return end --[[silently fail]]
		local state
		local remove
		_, remove = epoll:add(
			client.fd,
			function ()  state = callback(client, state) end,
			--[[@diagnostic disable-next-line: need-check-nil]]
			function () client:close(); remove() end
		)
		local client_close = client.close
		--[[@diagnostic disable-next-line: duplicate-set-field, need-check-nil]]
		client.close = function (self) client_close(self); remove() end
	end, is_running and function () is_running = false end or nil)

	-- FIXME: a stop() callback for user
	while is_running do epoll:wait() end
end

return mod

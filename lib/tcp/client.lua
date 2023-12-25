local epoll_ = require("dep.epoll")
local socket = require("dep.ljsocket")

local mod = {}

--[[@return fun(s: string) write, fun() close]]
--[[@param host string]] --[[@param port integer]] --[[@param cb fun(s: string) callback]] --[[@param epoll epoll?]]
mod.client = function (host, port, cb, epoll)
	local is_running = not epoll
	epoll = epoll or epoll_.new()
	local client = assert(socket.create(host:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$") and "inet" or "inet6", "stream", "tcp"))
	assert(client:set_blocking(false))
	local success, err = client:connect(host, port)
	if not success then
		client = assert(socket.create("inet", "stream", "tcp"))
		assert(client:set_blocking(false))
		assert(client:connect(host, port))
	end
	while not client:is_connected() do client:poll_connect() end
	--[[TODO: receive all at once?]]
	local _, remove = epoll:add(client.fd, cb, function () client:close() end)
	assert(remove, "tcp_client: could not listen to socket")
	while is_running do epoll:wait() end
	--[[@param s string]]
	return function (s) client:send(s) end, function () remove(); client:close() end
end

return mod

local socket_ = require("lib.socket.server")

local mod = {}

--[[@param handler fun (write: fun(_: string), close: fun()): fun (_: string)]] --[[@param port integer]] --[[@param epoll? epoll]]
mod.server = function (handler, port, epoll)
	return socket_.server(function (client, state)
		state = state or { handler = handler(function (s) client:send(s) end, function () client:close() end) }
		local received = client:receive()
		if received then  state.handler(received) else client:close() end
		return state
	end, port, epoll)
end

return mod

local socket = require("dep.ljsocket")
local format = require("lib.http.format")

local mod = {}

--[[TODO: tls: https://github.com/CapsAdmin/luajitsocket/blob/master/examples/tcp_client_blocking_tls.lua]]

--[[@param req http_client_request]]
mod.send = function (req)
	if not req.host then error("http_client.send: missing host") end
	local client = assert(socket.create("inet", "stream", "tcp"))
	assert(client:connect(req.host, req.port or "http"))
	assert(client:send(format.http_client_request_to_string(req)))
	return client:receive()
end

return mod

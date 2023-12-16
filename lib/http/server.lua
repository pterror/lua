local socket = require("lib.socket.server")
local http = require("lib.http.format")

local mod = {}

--[[@alias http_callback fun(req: http_request, res: http_response, sock: luajitsocket): boolean?]]

local buf = require("ffi").new("char[65536]")
local err_res = http.http_response_to_string({ status = 400, headers = {} })

--[[@param handler http_callback]]
mod.make_connection_handler = function (handler)
	--[[@param client luajitsocket]]
	return function (client)
		local s = client:receive(buf)
		if not s then return end --[[silently fail]]
		--[[TODO: multi-packet bodies]]
		local req, i = http.string_to_http_request(s)
		if not req or not i then client:send(err_res); return end
		local res = { headers = {} } --[[@type http_response]]
		handler(req, res, client)
		client:send(http.http_response_to_string(res))
		client:close()
	end
end

--[[@return luajitsocket sock]]
--[[@param handler http_callback]] --[[@param port? integer]] --[[@param epoll? epoll]]
mod.server = function (handler, port, epoll)
	return socket.server(mod.make_connection_handler(handler), port or 80, epoll)
end

return mod

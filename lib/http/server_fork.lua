local socket = require("lib.socket.server")
local http = require("lib.http.format")
local ffi = require("ffi")

local mod = {}

ffi.cdef [[int /*pid_t*/ fork(void);]]

--[[@param handler http_callback]]
mod.make_connection_handler = function (handler)
	--[[@param client luajitsocket]]
	return function (client)
		local s = client:receive()
		if not s then return end --[[silently fail]]
		--[[TODO: multi-packet bodies]]
		local req, i = http.string_to_http_request(s)
		if not req or not i then client:send(http.http_response_to_string({ status = 400, headers = {} })); return end
		local res = { headers = {} } --[[@type http_response]]
		local pid = ffi.C.fork()
		if pid ~= 0 then client:close(); print("main ok") return end
		handler(req, res, client)
		client:send(http.http_response_to_string(res))
		client:close()
		os.exit(0)
	end
end

--[[@return luajitsocket sock]]
--[[@param handler http_callback]] --[[@param port? integer]] --[[@param epoll? epoll]]
mod.server = function (handler, port, epoll)
	return socket.server(mod.make_connection_handler(handler), port or 80, epoll)
end

return mod

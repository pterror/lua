-- TODO: let static plugin support last-modified
-- alternatively leave it until panek web:
-- get last modified -> set header -> read file ------------> serve
--                                       `-detect mimetype-----^

local socket = require("lib.socket.server")
local ws = require("lib.websocket")
local http = require("lib.http.format")
local epoll_ = require("dep.epoll")

local mod = {}

--[[TODO: sse]]
--[[@alias sse_callback fun(): (send: (fun(evt: sse_event)))]]
--[[@alias ws_callback fun(sock: luajitsocket, msg: websocket_message)]]
--[[@alias ws_open_callback fun(sock: luajitsocket, send: websocket_send, close: websocket_close)]]
--[[@alias ws_close_callback fun(sock: luajitsocket)]]

--[[@class sse_event]]

--[[@class http_like_callbacks]]
--[[@field http http_callback?]]
--[[@field sse sse_callback?]]
--[[@field ws ws_callback?]]
--[[@field ws_open ws_open_callback?]]
--[[@field ws_close ws_close_callback?]]

--[[TODO: figure out whether `make_connection_handler` can be removed after restructuring https server?]]

--[[@param handler http_like_callbacks]] --[[@param epoll epoll]]
mod.make_connection_handler = function (handler, epoll)
	--[[@param client luajitsocket]]
	return function (client)
		local s = client:receive()
		if not s then return end -- silently fail

		-- TODO: multi-packet bodies
		local req, i = http.string_to_http_request(s)
		if not req or not i then return end
		-- TODO: send response
		local res = { headers = {} } --[[@type http_response]]
		-- TODO: sse - since the request is the same as normal http
		-- it's a lot harder to just use if-else
		if (req.headers["upgrade"] or {})[1] == "websocket" then
			--[[FIXME: api. the handler needs a persistent handle to the connection]]
			local send, close = ws.websocket(client, req, handler.ws, handler.ws_close, epoll)
			if send and close and handler.ws_open then
				handler.ws_open(client, send, close)
			end
		else
			handler.http(req, res)
			client:send(http.http_response_to_string(res))
			client:close()
		end
	end
end

--[[@param handler http_callback|http_like_callbacks]] --[[@param port? integer]] --[[@param epoll? epoll]]
mod.server = function (handler, port, epoll)
	local is_running = not epoll
	epoll = epoll or epoll_:new()
	if type(handler) == "function" then handler = { http = handler } end
	socket.server(mod.make_connection_handler(handler, epoll), port or 80, epoll)
	if is_running then epoll:loop() end
end

return mod

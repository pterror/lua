-- TODO: let static plugin support last-modified
-- alternatively leave it until panek web:
-- get last modified -> set header -> read file ------------> serve
--                                       `-detect mimetype-----^

local socket = require("lib.socket.server")
local ws = require("lib.websocket")
local http = require("lib.http.format")
local epoll_ = require("dep.epoll")

local mod = {}

--[[TODO: sse and ws]]
--[[@alias sse_callback fun(): (send: fun(evt: sse_event))]]
--[[@alias ws_callback fun(req: http_request)]]

--[[@class sse_event]]

--[[@class http_like_callbacks]]
--[[@field http http_callback?]]
--[[@field sse sse_callback?]]
--[[@field ws ws_callback?]]

--[[TODO: figure out whether this can be removed after restructuring https server?]]

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
		--- @type http_response
		local res = { headers = {} }
		-- TODO: sse - since the request is the same as normal http
		-- it's a lot harder to just use if-else
		if req.headers["Upgrade"] == "websocket" then
			-- FIXME: api
			ws.websocket(epoll, client, req, handler.ws) -- TODO: should be in serverx, not server
		else
			handler.http(req, res)
			client:send(http.http_response_to_string(res))
			client:close()
		end
	end
end

--[[@param handler http_callback|http_like_callbacks]] --[[@param port? integer]] --[[@param epoll? epoll]]
mod.server = function (handler, port, epoll)
	epoll = epoll or epoll_:new()
	if type(handler) == "function" then handler = { http = handler } end
	return socket.server(mod.make_connection_handler(handler, epoll), port or 80, epoll)
end

return mod

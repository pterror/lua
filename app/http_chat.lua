#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local h = require("lib.htmlxx")
local set_interval = require("dep.timerfd").set_interval

local main_page = h.html {
	h.head {
		h.title "chat",
		h.style {
			["html"] = { ["height"] = "100%" },
			["body"] = {
				["margin"] = "0", ["height"] = "100%", ["display"] = "flex", ["flex-flow"] = "column nowrap",
				["font-family"] = "sans-serif", ["color"] = "#ffffff", ["background"] = "#222222",
			},
			["input, button"] = { ["color"] = "#ffffff", ["background"] = "#333333" },
			["#chat"] = { ["flex"] = "1 0 auto" },
			["#chat_input_bar"] = { ["display"] = "flex", ["flex-flow"] = "row nowrap" },
			["#chat_input"] = { ["flex"] = "1 0 auto" }
		},
	},
	h.body {
		h.div { id="chat" },
		h.div { id="chat_input_bar",
			h.input { type = "text", id = "chat_input" },
			h.button { id = "chat_input_submit", ">" },
		},
		h.script(function (x)
			--[[@generic t]]
			--[[@param y t|nil]]
			--[[@return t]]
			local assert = function (y) if not y then error("assertion failed") end; return y end

			local chatEl = assert(x.document:getElementById("chat"))
			local inputEl = assert(x.document:getElementById("chat_input"))
			local submitEl = assert(x.document:getElementById("chat_input_submit"))

			local ws = x.WebSocket.new(x.location.href:replace(x.RegExp("^http"), "ws"))
			local send = function () ws:send(inputEl.value) inputEl.value = "" end
			inputEl:addEventListener("change", send)
			submitEl:addEventListener("click", send)
			ws:addEventListener("message", function (event)
				local el = x.document:createElement("div")
				el.innerText = event.data
				chatEl:appendChild(el)
			end)
			--[[FIXME]]
			x.window:addEventListener("beforeunload", function ()
				ws:close()
			end)
			inputEl:focus()
		end),
	},
}

--[[@type table<string, http_callback>]]
local handlers = {
	["/"] = function (_, res) res.body = main_page end,
}
handlers["/index.html"] = handlers["/"]

package.loaded["lib.htmlxx"] = nil

local ws_clients = {} --[[@type table<luajitsocket, {send?:websocket_send;close?:websocket_close;}>]]

--[[for a more complex one: save `req.payload` to db somewhere]]
local epoll = require("dep.epoll").new()
require("lib.http.serverx").server({
	http = function (req, res)
		local handler = handlers[req.path]
		if handler then handler(req, res) else res.status = 404 end
	end,
	ws = function (_, msg)
		for _, fns in pairs(ws_clients) do
			local reply = { type = "text", payload = msg.payload } --[[@type websocket_message_text]]
			fns.send(reply)
		end
	end,
	ws_open = function (sock, send, close)
		ws_clients[sock] = { send = send, close = close }
	end,
	ws_close = function (sock) ws_clients[sock] = nil end,
	--[[@diagnostic disable-next-line: param-type-mismatch]]
}, tonumber(arg[1] or os.getenv("port") or os.getenv("PORT")), epoll)
--[[FIXME: something is not adding to count...]]
set_interval(epoll, 60000, function ()
	for _, fns in pairs(ws_clients) do
		local msg = { type = "ping", payload = "" } --[[@type websocket_message_ping]]
		fns.send(msg)
	end
end)

epoll:loop()

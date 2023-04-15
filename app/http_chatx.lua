#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[
wishlist:
- consider not sending blobs back to client
  - server still has to send the content type
- usernames, channels, count of online users
- lightbox + zoom
- other types of content (website embeds, games)
]]

local h = require("lib.htmlxx")
local set_interval = require("dep.timerfd").set_interval
local mimetype_by_contents = require("lib.mimetype.by_contents").mimetype

local typeof --[[@type fun(x: unknown): "string"|"number"|"boolean"|"bigint"|"symbol"|"undefined"|"object"|"function"]]
--[[@generic t]]
local async --[[@type fun(x: t): t]]
local await --[[@type fun(x: js_promise): unknown]]

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
			["a"] = { ["color"] = "#63d3d9" },
			["img, video"] = { ["max-width"] = "100%" },
			["a:visited"] = { ["color"] = "#b599f7" },
			[".system"] = { ["color"] = "#bbbbbb" },
			["#chat"] = { ["flex"] = "1 0 auto" },
			["#chat > *"] = { ["display"] = "block" },
			["#chat_input_bar"] = { ["display"] = "flex", ["flex-flow"] = "row nowrap" },
			["#chat_input"] = { ["flex"] = "1 0 auto" },
			["#file_drop_area"] = {
				["display"] = "none", ["position"] = "fixed", ["width"] = "100vw", ["height"] = "100vh", ["place-items"] = "center",
				["font-size"] = "2rem", ["background"] = "#333333",
			},
			["#file_drop_area *"] = { ["pointer-events"] = "none" },
		},
	},
	h.body {
		h.div { id="chat" },
		h.div { id="chat_input_bar",
			h.input { type = "text", id = "chat_input" },
			h.button { id = "chat_input_submit", ">" },
		},
		h.div { id = "file_drop_area", h.span { "Drop to send file(s)" } },
		h.script(function (x)
			--[[@generic t]]
			--[[@param y t|nil]]
			--[[@return t]]
			local assert = function (y) if not y then error("assertion failed") end; return y end

			local chatEl = assert(x.document:getElementById("chat"))
			local inputEl = assert(x.document:getElementById("chat_input"))
			local submitEl = assert(x.document:getElementById("chat_input_submit"))
			local dropEl = assert(x.document:getElementById("file_drop_area"))

			local ws
			local send = function () ws:send(inputEl.value) inputEl.value = "" end
			inputEl:addEventListener("change", send)
			submitEl:addEventListener("click", send)
			local system = function (message)
				local el = chatEl:appendChild(x.document:createElement("span"))
				el.classList:add("system")
				el.innerText = "system: " .. message
			end
			local onOpen = function () system("connected") end
			local onClose, onMessage, setupWs
			onClose = function ()
				system("closed, reconnecting...")
				setupWs()
			end
			x.setInterval(function ()
				if ws.readyState >= 2 then system("error, reconnecting..."); setupWs() end
			end, 60000)
			onMessage = async(function (event)
				local atBottom = x.Math.abs(x.document.body.scrollHeight - x.visualViewport.height - x.visualViewport.pageTop) < 1
				if typeof(event.data) == "string" then
					local el = chatEl:appendChild(x.document:createElement("div"))
					el.innerText = event.data
				else
					local blob = event.data --[[@type js_blob]]
					local type = await(blob:slice(0, 3):text())
					local buf = blob:slice(3)
					local url = x.URL.createObjectURL(buf)
					if type == "img" then
						local el = chatEl:appendChild(x.document:createElement("img"))
						el.src = url
					elseif type == "vid" then
						local el = chatEl:appendChild(x.document:createElement("video"))
						el.controls = true
						el.src = url
					elseif type == "snd" then
						local el = chatEl:appendChild(x.document:createElement("audio"))
						el.controls = true
						el.src = url
					else --[[type should be "bin"]]
						local el = chatEl:appendChild(x.document:createElement("a"))
						el.innerText = "file"
						el.href = url
						el.download = ""
					end
				end
				if atBottom then
					x.setTimeout(function () x.window:scrollTo(0, x.document.body.scrollHeight) end, 1)
				end
			end)
			setupWs = function ()
				ws = x.WebSocket.new(x.location.href:replace(x.RegExp("^http"), "ws"))
				ws:addEventListener("open", onOpen)
				ws:addEventListener("close", onClose)
				ws:addEventListener("message", onMessage)
			end
			setupWs()
			x.document.body:addEventListener("dragenter", function (event)
				if not event.dataTransfer.types:includes("Files") then return end
				dropEl.style.display = "grid"
			end)
			dropEl:addEventListener("dragleave", function ()
				dropEl.style.display = "none"
			end)
			dropEl:addEventListener("dragover", function (event)
				event:preventDefault()
			end)
			dropEl:addEventListener("drop", function (event) --[[@param event js_dom_drag_event]]
				dropEl.style.display = "none"
				event:preventDefault()
				for file in event.dataTransfer.files do ws:send(file) end
			end)
			--[[FIXME]]
			x.window:addEventListener("beforeunload", function () ws:close() end)
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

local mimetype_to_bintype = setmetatable({
	image = "img", video = "vid", audio = "snd"
}, { __index = function () return "bin" end })

--[[for a more complex one: save `req.payload` to db somewhere]]
local epoll = require("dep.epoll").new()
require("lib.http.serverx").server({
	http = function (req, res)
		local handler = handlers[req.path]
		if handler then handler(req, res) else res.status = 404 end
	end,
	ws = function (sock, msg)
		if msg.type == "text" then
			for _, fns in pairs(ws_clients) do
				fns.send(msg)
			end
		elseif msg.type == "binary" then
			msg.payload = select(2, mimetype_by_contents(msg.payload)):gsub("(.-)/.+", mimetype_to_bintype) .. msg.payload
			for _, fns in pairs(ws_clients) do
				fns.send(msg)
			end
		elseif msg.type == "close" then
			ws_clients[sock].close()
			ws_clients[sock] = nil
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
		fns.send({ type = "ping", payload = "" })
	end
end)

epoll:loop()

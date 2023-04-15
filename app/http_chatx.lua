#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

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

			local ws = x.WebSocket.new(x.location.href:replace(x.RegExp("^http"), "ws"))
			local send = function () ws:send(inputEl.value) inputEl.value = "" end
			inputEl:addEventListener("change", send)
			submitEl:addEventListener("click", send)
			ws:addEventListener("message", async(function (event)
				if typeof(event.data) == "string" then
					local el = chatEl:appendChild(x.document:createElement("div"))
					el.innerText = event.data
				else
					local blob = event.data --[[@type js_blob]]
					local type = await(blob:slice(0, 3):text())
					local buf = blob:slice(3)
					x.console:log(buf.size)
					local url = x.URL.createObjectURL(buf)
					if type == "img" then
						local el = chatEl:appendChild(x.document:createElement("img"))
						el.src = url
					elseif type == "vid" then
						local el = chatEl:appendChild(x.document:createElement("video"))
						el.src = url
					elseif type == "snd" then
						local el = chatEl:appendChild(x.document:createElement("audio"))
						el.src = url
					else --[[type should be "bin"]]
						local el = chatEl:appendChild(x.document:createElement("a"))
						el.innerText = "file"
						el.href = url
						el.download = ""
					end
				end
			end))
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
				for file in event.dataTransfer.files do x.console.log(file.size); ws:send(file) end
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

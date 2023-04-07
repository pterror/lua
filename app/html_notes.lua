#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local h = require("lib.htmlxx")

--[[TODO: handle save]]
--[[TODO: handle rename]]
--[[TODO: handle delete]]

local MAIN_PAGE = h.html {
	h.body {
		--[[consider being able to move it to the right side]]
		h.div { --[[FIXME: make it collapsible]]
			id = "sidebar",
		},
		h.div {
			h.input { type = "text", id = "title" },
			h.div {
				contenteditable = true,
				id = "content",
			},
		},
		h.script(function (x)
			--[[@generic t]]
			--[[@param y t|nil]]
			--[[@return t]]
			local assert = function (y) if not y then error("assertion failed") end; return y end
			local content = assert(x.document:getElementById("content"))
			local save = async(function ()
				--[[FIXME: how to specify where to save to]]
				return await(x.fetch("save", {
					method = "POST",
					headers = { { "Content-Type", "text/plain" } },
					--[[LINT: should be `js_string|nil` because not all union members have `innerText`]]
					body = content.innerText,
				}))
			end)
			local handle --[[@type js_timeout_id]]
			--[[FIXME: figure out why `event` is inferred as `js_dom_event|js_dom_keyboard_event` instead of just `keyboard_event` when `type:"keydown"`]]
			content:addEventListener("input", function (event)
				x.clearTimeout(handle)
				handle = x.setTimeout(save, 1000)
			end)
		end),
	},
}

--[[@type table<string, http_callback>]]
local handlers = {
	["/"] = function (req, res) res.body = MAIN_PAGE end,
	["/save"] = function (req, res)
		local body = req.body
		--[[IMPL]]
	end,
}
handlers["/index.html"] = handlers["/"]

--[[FIXME: arg[1] is directory]]
require("lib.http.server").server(function (req, res)
	local handler = handlers[req.path]
	if handler then handler(req, res) else res.status = 404 end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[2] or os.getenv("port") or os.getenv("PORT")))

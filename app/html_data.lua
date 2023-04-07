#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local h = require("lib.htmlxx")

--[[TODO: type selector]]
--[[TODO: generate form to insert data]]
--[[TODO: editable table view]]

local main_page = h.html {
	h.head {
		h.style {
			[".text-children:has(*)"] = {
				["border"] = "1px solid #000000",
				["padding"] = "0.5em",
			}
		}
	},
	h.body {
	},
	h.script(function (x)
		local types = { "text", "number", "integer", "boolean", "array", "map", "object", "any" }
		local type_types = {
			text = "string", number = "number", integer = "integer", boolean = "boolean", array = "array", map = "dictionary",
			object = "table", any = "any",
		}
		--[[@class html_data_type_input_props]]
		--[[@field onChange fun(type: type_)]]

		local TypeInput
		TypeInput = function (props) --[[@param props html_data_type_input_props]]
			local value = { type = "text" }
			local el = x.document:createElement("div")
			local selectEl = el:appendChild(x.document:createElement("select"))
			local childrenEl = el:appendChild(x.document:createElement("div"))
			selectEl:addEventListener("change", function (e)
				local newType = e.target.value --[[@type js_string_like]]
				value = { type = type_types[newType] }
				--[[FIXME: extra elements + default values + props for complex types like array, record etc]]
				local newChildrenEl = x.document:createElement("div")
				newChildrenEl.classList:add("text-children")
				el:replaceChild(newChildrenEl, childrenEl)
				childrenEl = newChildrenEl
				if newType == "array" then
					newChildrenEl:appendChild(x.document:createTextNode("item: "))
					newChildrenEl:appendChild(TypeInput({
						onChange = function (type)
							value.item = type
							props.onChange(value)
						end,
					}))
				elseif newType == "map" then
					newChildrenEl:appendChild(x.document:createTextNode("key: "))
					newChildrenEl:appendChild(TypeInput({
						onChange = function (type)
							value.key = type
							props.onChange(value)
						end,
					}))
					newChildrenEl:appendChild(x.document:createTextNode("value: "))
					newChildrenEl:appendChild(TypeInput({
						onChange = function (type)
							value.value = type
							props.onChange(value)
						end,
					}))
				end
				props.onChange(value)
			end)
			for i = 0, #types - 1 do
				local optionEl = selectEl:appendChild(x.document:createElement("option"))
				optionEl.innerText = types[i]
			end
			props.onChange(value)
			return el
		end

		local typeInput = TypeInput({
			onChange = function (type)
				--[[FIXME: why is there a type error]]
				x.console:log(x.JSON.stringify(type))
			end,
		})
		x.document.body:appendChild(typeInput)
	end),
}

--[[@type table<string, http_callback>]]
local handlers = {
	["/"] = function (req, res) res.body = main_page end,
}
handlers["/index.html"] = handlers["/"]

require("lib.http.server").server(function (req, res)
	local handler = handlers[req.path]
	if handler then handler(req, res) else res.status = 404 end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[2] or os.getenv("port") or os.getenv("PORT")))

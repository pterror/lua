local mod = {}

-- TODO: need separate escape for element content and attributes

--[[@param s string]]
local html_escape = function (s)
	return s:gsub("[&<>\"']", {
		["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt", ["\""] = "&quot", ["'"] = "&#039;",
	})
end

--[[@param tag string]]
mod.element = function (tag)
	--[[@param xs table<string|integer, string|number|boolean>]]
	return function (xs)
		if type(xs) == "string" then return string.format("<%s>%s</%s>", tag, (tag == "script" or tag == "style") and xs or html_escape(xs), tag) end
		local parts = {}
		parts[#parts+1] = "<" .. tag .. " "
		local has_attrs = false
		for k, v in pairs(xs) do
			has_attrs = true
			if type(k) == "string" then
				parts[#parts+1] = v == true and (k .. " ") or string.format("%s=\"%s\" ", k, html_escape(tostring(v)))
			end
		end
		if not has_attrs then parts[1] = "<" .. tag end
		parts[#parts+1] = ">"
		for i = 1, #xs do
			-- assume they are strings
			parts[#parts+1] = xs[i]
		end
		parts[#parts+1] = "</" .. tag .. ">"
		return table.concat(parts)
	end
end

--[[@type fun(tag: string): fun(xs: string|table<string|integer, string|number|boolean>): string]]
mod.string_element = mod.element

-- https://html.spec.whatwg.org/multipage/dom.html#flow-content
-- [...$0.querySelectorAll("li")].flatMap(e=>(c=e.querySelector("code")?.innerText)?["html_element_"+c]:[]).join(" | ")

local html = mod.element("html")
--[[@param xs table<string|integer, string>]]
mod.html = function (xs) return "<!DOCTYPE html>" .. html(xs) end
mod.head = mod.element("head")
mod.body = mod.element("body")
mod.div = mod.element("div")
mod.link = mod.element("link")
mod.title = mod.string_element("title")
mod.section = mod.element("section")
mod.header = mod.element("header")
mod.footer = mod.element("footer")
mod.a = mod.element("a")
mod.br = "<br />" -- TODO: allow classes i guess... e.g. to modify line height
mod.br_ = mod.element("br")

--[[@alias css_style_key "align-content"|"align-items"|"align-self"|"animation"|"animation-delay"|"animation-direction"|"animation-duration"|"animation-fill-mode"|"animation-iteration-count"|"animation-name"|"animation-play-state"|"animation-timing-function"|"backface-visibility"|"background"|"background-attachment"|"background-clip"|"background-color"|"background-image"|"background-origin"|"background-position"|"background-repeat"|"background-size"|"border"|"border-bottom"|"border-bottom-color"|"border-bottom-left-radius"|"border-bottom-right-radius"|"border-bottom-style"|"border-bottom-width"|"border-collapse"|"border-color"|"border-image"|"border-image-outset"|"border-image-repeat"|"border-image-slice"|"border-image-source"|"border-image-width"|"border-left"|"border-left-color"|"border-left-style"|"border-left-width"|"border-radius"|"border-right"|"border-right-color"|"border-right-style"|"border-right-width"|"border-spacing"|"border-style"|"border-top"|"border-top-color"|"border-top-left-radius"|"border-top-right-radius"|"border-top-style"|"border-top-width"|"border-width"|"bottom"|"box-shadow"|"box-sizing"|"caption-side"|"clear"|"clip"|"color"|"column-count"|"column-fill"|"column-gap"|"column-rule"|"column-rule-color"|"column-rule-style"|"column-rule-width"|"column-span"|"column-width"|"columns"|"content"|"counter-increment"|"counter-reset"|"cursor"|"direction"|"display"|"empty-cells"|"flex"|"flex-basis"|"flex-direction"|"flex-flow"|"flex-grow"|"flex-shrink"|"flex-wrap"|"float"|"font"|"font-family"|"font-size"|"font-size-adjust"|"font-stretch"|"font-style"|"font-variant"|"font-weight"|"height"|"justify-content"|"left"|"letter-spacing"|"line-height"|"list-style"|"list-style-image"|"list-style-position"|"list-style-type"|"margin"|"margin-bottom"|"margin-left"|"margin-right"|"margin-top"|"max-height"|"max-width"|"min-height"|"min-width"|"opacity"|"order"|"outline"|"outline-color"|"outline-offset"|"outline-style"|"outline-width"|"overflow"|"overflow-x"|"overflow-y"|"padding"|"padding-bottom"|"padding-left"|"padding-right"|"padding-top"|"page-break-after"|"page-break-before"|"page-break-inside"|"perspective"|"perspective-origin"|"position"|"quotes"|"resize"|"right"|"tab-size"|"table-layout"|"text-align"|"text-align-last"|"text-decoration"|"text-decoration-color"|"text-decoration-line"|"text-decoration-style"|"text-indent"|"text-justify"|"text-overflow"|"text-shadow"|"text-transform"|"top"|"transform"|"transform-origin"|"transform-style"|"transition"|"transition-delay"|"transition-duration"|"transition-property"|"transition-timing-function"|"vertical-align"|"visibility"|"white-space"|"width"|"word-break"|"word-spacing"|"word-wrap"|"z-index"]]

--[[@class css_selector: string]]
--[[@class css_style: {[css_style_key]: string}]]

--[[`table<selector>]]
--[[@param styles table<css_selector, css_style>]]
mod.style = function (styles)
	local parts = {} --[[@type string[] ]]
	parts[#parts+1] = "<style>"
	for selector, style in pairs(styles) do
		parts[#parts+1] = "\t" .. selector .. " {"
		for prop, v in pairs(style) do
			parts[#parts+1] = "\t\t" .. prop .. ": " .. v  .. ";"
		end
		parts[#parts+1] = "\t}"
	end
	parts[#parts+1] = "</style>"
	return table.concat(parts, "\n")
end

mod.script = function (fn) --[[@param fn fun(x: js_window)]]
	local info = debug.getinfo(fn)
	local filename = "[string]"
	local reader
	if info.source:byte(1) == 0x40 --[[@]] then
		filename = info.source:sub(2)
		reader = require("dep.ljltk.reader").file(filename)
	else
		reader = require("dep.ljltk.reader").string(info.source)
	end
	local ls = require("dep.ljltk.lexer")(reader, filename)
	local ast_builder = require("dep.ljltk.lua_ast").New()
	local ast_tree = require("dep.ljltk.parser")(ast_builder, ls)
	local func_node
	require("dep.ljltk.visitor")(ast_tree, function (node)
		if node.kind == "FunctionExpression" and node.firstline == info.linedefined and node.lastline == info.lastlinedefined then
			func_node = node
			return false
		end
	end)
	local code = require("dep.lua2js").lua2js(ast_builder:chunk(func_node.body), filename)
	--[[IMPL: magic (get function ast from file)]]
	--[[FIXME: prevent injection]]
	return "<script>\nconst x = window;\n" .. code .. "</script>"
end

mod.meta = mod.element("meta")

mod.table = mod.element("table")
mod.thead = mod.element("thead")
mod.tbody = mod.element("tbody")
mod.tfoot = mod.element("tfoot")
mod.tr = mod.string_element("tr")
mod.th = mod.string_element("th")
mod.td = mod.string_element("td")

mod.h1 = mod.string_element("h1")
mod.h2 = mod.string_element("h2")
mod.h3 = mod.string_element("h3")
mod.h4 = mod.string_element("h4")
mod.h5 = mod.string_element("h5")
mod.h6 = mod.string_element("h6")

mod.text = html_escape
mod.span = mod.element("span")
mod.p = mod.string_element("p")
mod.i = mod.string_element("i")
mod.b = mod.string_element("b")
mod.em = mod.string_element("em")
mod.strong = mod.string_element("strong")

mod.ol = mod.element("ol")
mod.ul = mod.element("ul")
mod.li = mod.element("li")

mod.form = mod.element("form")
mod.input = mod.element("input")
mod.label = mod.element("label")
mod.fieldset = mod.element("fieldset")
mod.select = mod.element("select")
mod.option = mod.element("option")

mod.img = mod.element("img")
mod.iframe = mod.element("iframe")
mod.video = mod.element("video")
mod.audio = mod.element("audio")
mod.source = mod.element("source")

mod.canvas = mod.element("canvas")
mod.svg = mod.element("svg")

-- local dl_div = mod.element("div")

return mod

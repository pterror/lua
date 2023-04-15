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

mod.style = mod.element("style")
mod.script = mod.string_element("script")
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
mod.button = mod.element("button")

mod.img = mod.element("img")
mod.iframe = mod.element("iframe")
mod.video = mod.element("video")
mod.audio = mod.element("audio")
mod.source = mod.element("source")

mod.canvas = mod.element("canvas")
mod.svg = mod.element("svg")

-- local dl_div = mod.element("div")

return mod

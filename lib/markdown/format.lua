local urlencode = require("lib.urlencode").string_to_urlencode

--[[FIXME:]]

local mod = {}

mod.readers = {} --[[@type table<string, (fun(s: string, i: integer): {type:string;}, integer)>]]

--[[@type fun(s: string, i: integer, prefix_i?: integer): {type:string;}, integer]]
mod.readers.normal = function (s, i, prefix_i)
	local j = i
	if prefix_i then i = prefix_i end

end

mod.readers.heading = function (s, i)
	local start = i
	local level = 0
	while s:byte(i) == 0x23 --[[#]] and level < 7 do
		level = level + 1
		i = i + 1
	end
	if level == 7 or s:byte(i) ~= 0x20 --[[ ]] then
		return mod.readers.normal(s, i, start)
	end
	i = i + 1
	local contents
	contents, i = mod.string_to_tree(s, i)
	--[[FIXME: read to end of line]]
	return { type = "heading", level = level, contents = contents }, i
end

mod.readers_by_character = {}
mod.readers_by_character[0x23 --[[#]]] = mod.readers.heading
mod.readers_by_character[0x2a --[[*]]] = mod.readers.bold_or_italics_or_bulleted_list
mod.readers_by_character[0x2d --[[-]]] = mod.readers.bulleted_list
mod.readers_by_character[0x30 --[[0]]] = mod.readers.numbered_list
mod.readers_by_character[0x31 --[[1]]] = mod.readers.numbered_list
mod.readers_by_character[0x32 --[[2]]] = mod.readers.numbered_list
mod.readers_by_character[0x33 --[[3]]] = mod.readers.numbered_list
mod.readers_by_character[0x34 --[[4]]] = mod.readers.numbered_list
mod.readers_by_character[0x35 --[[5]]] = mod.readers.numbered_list
mod.readers_by_character[0x36 --[[6]]] = mod.readers.numbered_list
mod.readers_by_character[0x37 --[[7]]] = mod.readers.numbered_list
mod.readers_by_character[0x38 --[[8]]] = mod.readers.numbered_list
mod.readers_by_character[0x39 --[[9]]] = mod.readers.numbered_list
mod.readers_by_character[0x3c --[[<]]] = mod.readers.html
mod.readers_by_character[0x5b --[[[]]] = mod.readers.link
mod.readers_by_character[0x5f --[[_]]] = mod.readers.bold_or_italics
mod.readers_by_character[0x60 --[[`]]] = mod.readers.code
mod.readers_by_character[0x7e --[[~]]] = mod.readers.strikethrough

--[[@param s string]]
mod.string_to_tree = function (s, i)
	i = i or 1
	local parts = {}
	while true do
		--[[TODO: consume whitespace]]
		local reader = mod.readers_by_character[s:byte(i)] or mod.readers.normal
		local part
		part, i = reader(s, i)
		parts[#parts+1] = part
	end
	return { type = "document", parts = parts }, i
end

mod.string_writers = {}

mod.string_writers.heading = function (x, rec)
	return ("%s %s"):format(("#"):rep(x.level), rec(x.contents))
end
mod.string_writers.italics = function (x, rec)
	return ("*%s*"):format(rec(x.contents))
end
mod.string_writers.bold = function (x, rec)
	return ("**%s**"):format(rec(x.contents))
end
mod.string_writers.link = function (x, rec)
	return ("[%s](%s)"):format(rec(x.contents), x.link)
end
mod.string_writers.code = function (x ,rec)
	local contents = rec(x.contents)
	if contents:match("`") then
		return ("``%s%s%s``"):format(
			contents:byte(1) == 0x60 --[[`]] and " " or "",
			contents,
			contents:byte(#contents) == 0x60 --[[`]] and " " or ""
		)
	else
		return ("`%s`"):format(contents)
	end
end
mod.string_writers.code_block = function (x ,rec)
	return ("```\n%s\n```"):format(rec(x.contents))
end

local tree_to_string
tree_to_string = function (x)
	return mod.string_writers[x.type](x, tree_to_string)
end
mod.tree_to_string = tree_to_string

mod.html_writers = {}

--[[@param s string]]
local html_escape = function (s)
	return s:gsub("[&<>]", {
		["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;",
	})
end

mod.html_writers.normal = html_escape
mod.html_writers.heading = function (x, rec)
	return ("<h%s>%s</h%s>"):format(x.level, rec(x.contents), x.level)
end
mod.html_writers.italics = function (x, rec)
	return ("<i>%s</i>"):format(rec(x.contents))
end
mod.html_writers.bold = function (x, rec)
	return ("<b>%s</b>"):format(rec(x.contents))
end
mod.html_writers.strikethrough = function (x, rec)
	return ("<s>%s</s>"):format(rec(x.contents))
end
mod.html_writers.link = function (x ,rec)
	return ("<a href=\"%s\">%s</a>"):format(urlencode(x.link), rec(x.contents))
end
mod.html_writers.code = function (x ,rec)
	return ("<code>%s</code>"):format(rec(x.contents))
end
mod.html_writers.code_block = function (x ,rec)
	return ("<pre><code>%s</code></pre>"):format(rec(x.contents))
end

local tree_to_html
tree_to_html = function (x)
	return mod.html_writers[x.type](x, tree_to_html)
end
mod.tree_to_html = tree_to_html

--[[IMPL]]

require("dep.pretty_print").pretty_print(mod.string_to_tree([[
# heading

]]))

return mod

local urlencode = require("lib.urlencode").string_to_urlencode

local mod = {}

mod.string_to_tree = function ()
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

mod.html_writers.heading = function (x, rec)
	return ("<h%s>%s</h%s>"):format(x.level, rec(x.contents), x.level)
end
mod.html_writers.italics = function (x, rec)
	return ("<i>%s</i>"):format(rec(x.contents))
end
mod.html_writers.bold = function (x, rec)
	return ("<b>%s</b>"):format(rec(x.contents))
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

return mod

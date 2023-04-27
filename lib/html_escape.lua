local mod = {}

mod.html_escape_lookup = {
	["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&#039;",
}

--[[@param string string]]
mod.html_escape = function (string)
	return string:gsub("[&<>\"']", mod.html_escape_lookup)
end

return mod

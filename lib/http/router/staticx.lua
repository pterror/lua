local path = require("lib.path")
local mimetype_by_name = require("lib.mimetype.by_name").mimetype
local urldecode = require("lib.urlencode").urlencode_to_string
local urlencode = require("lib.urlencode").string_to_urlencode
local dir_list = require("lib.fs.dir_list").dir_list
local mimetype_by_contents

local mod = {}

--[[@param size? integer]]
local human_readable_size = function (size)
	if not size then
		return ""
	elseif size < 1024 then
		return size .. " B"
	elseif size < 1048576 then
		return string.format("%.1f kiB", size / 1024)
	elseif size < 1073741824 then
		return string.format("%.1f MiB", size / 1048576)
	elseif size < 1099511627776 then
		return string.format("%.1f GiB", size / 1073741824)
	else
		return string.format("%.1f TiB", size / 1099511627776)
	end
end

-- TODO: refactor all functions to use name = function()
-- FIXME: refactor out
--[[@param string string]]
local html_escape = function (string)
	return string:gsub("[&<>\"']", {
		["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&#039;",
	})
end

--[[@param base? string]]
mod.static_router = function (base)
	if base ~= nil and type(base) ~= "string" then
		return nil, "static() expects string as base path, got " .. tostring(base)
	end
	base = (base or "."):gsub("/$", "")
	--[[@return nil]] --[[@param req http_request]] --[[@param res http_response]]
	return function (req, res)
		-- TODO: urldecode? urldecode(req.path)
		local full_path = path.resolve(base, urldecode(req.path))
		local file = io.open(full_path, "r")
		if file == nil then res.status = 404; return end
		res.status = 200
		res.body = file:read("*all")
		file:close()
		if res.body == nil then
			file = io.open(full_path:gsub("/$", "") .. "/index.html")
			if file then
				res.body = file:read("*all")
				file:close()
			end
		end
		if res.body == nil then
			-- probably a directory
			local iter, dir = dir_list(full_path)
			if dir then
				res.headers["Content-Type"] = "text/html"
				local parts = {}
				parts[#parts+1] = "<!DOCTYPE html><html><head><title>Index of " .. html_escape(full_path) .. "</title></head><body><table><thead><tr><th>Name</th><th>Size</th><th>Created</th><th>Last modified</th></tr></thead><tbody><h1>Index of " .. html_escape(full_path) .. "</h1><a href=\"..\">[up one level]</a>"
				for file_info in iter, dir do
					-- TODO: consider adding sorting (via js)
					local slash = (file_info.is_dir and "/" or "")
					parts[#parts+1] = "<tr><td><a href=\"" .. urlencode(file_info.name) .. slash .. "\">" .. html_escape(file_info.name) ..
						slash .. "</a></td><td data-value=\"" .. (file_info.is_dir and "" or file_info.size or "") .. "\">" .. (file_info.is_dir and "" or human_readable_size(file_info.size)) ..
						-- "</td><td data-value=\"" .. (file_info.created or "") .. "\">" .. (file_info.created and os.date("%x %X", file_info.created) or "") ..
						"</td><td data-value=\"" .. (file_info.modified or "") .. "\">" .. (file_info.modified and os.date("%x %X", file_info.modified) or "") .. "</td></tr>"
				end
				parts[#parts+1] = "</tbody></table></body>"
				res.body = table.concat(parts)
			else
				res.status = 404
			end
			return
		end
		-- TODO: consider refactoring this out - it's a one liner either way anyway
		res.headers["Content-Type"] = mimetype_by_name(req.path)
		if not res.headers["Content-Type"] then
			mimetype_by_contents = mimetype_by_contents or require("lib.mimetype.by_contents").mimetype
			res.headers["Content-Type"] = mimetype_by_contents(res.body)
		end
	end
end

return mod

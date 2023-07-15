local mod = {}

--[[@param base string]] --[[@param path string]]
mod.resolve = function (base, path)
	base = base:gsub("/$", "")
	--[[@type string]]
	if path:byte(1) == 0x2f --[["/"]] then path = path:sub(2) end
	local path_parts = {} --[[@type string[] ]]
	local i = 1
	while i < #base do
		local start, end_ = base:find("[^/]*", i)
		path_parts[#path_parts+1] = base:sub(start, end_)
		i = end_ + 2
	end
	local path_it = path:gmatch("([^/]+)")
	--[[TODO: check if this is safe]]
	while true do
		local part = path_it()
		if not part then break end
		if part == ".." then
			if #path_parts > 0 then path_parts[#path_parts] = nil end
		elseif part == "." then --[[ignored]]
		else
			path_parts[#path_parts+1] = part
		end
	end
	return table.concat(path_parts, "/")
end

return mod

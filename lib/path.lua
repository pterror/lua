local mod = {}

--- @param base string
--- @param path string
function mod.resolve(base, path)
	base = base:gsub("/$", "")
	--- @type string
	if path:byte(1) == 0x2f --[["/"]] then path = path:sub(2) end
	local path_parts = {base} --- @type string[]
	local path_it = path:gmatch("([^/]+)")
	-- TODO: check if this is safe
	while true do
		local part = path_it()
		if not part then break end
		if part == ".." then
			if #path_parts > 1 then path_parts[#path_parts] = nil end
		elseif part == "." then -- ignored
		else
			path_parts[#path_parts+1] = part
		end
	end
	return table.concat(path_parts, "/")
end

return mod

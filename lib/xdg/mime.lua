--[[
	~/.local/share/applications/mimeapps.list and */defaults.list are deprecated.
	symlink them to an expected location, or modify `mod.search_locations`,
	for this to work.
]]

--[[TODO: finish]]
--[[TODO: /usr/share/mime/]]

local mod = {}

mod.search_locations = {
	"~/.config/mimeapps.list",
	"/etc/xdg/mimeapps.list",
	"/usr/local/share/applications/mimeapps.list",
	"/usr/share/applications/mimeapps.list",
}

local is_valid_section = {
	["[Added Associations]"] = true,
	["[Removed Associations]"] = true,
	["[Default Applications]"] = true,
}

--[[@class xdg_mime]]
--[[@field added table<string,string[]> mimetype to desktop file]]
--[[@field removed table<string,string[]> mimetype to desktop file]]
--[[@field default table<string,string[]> mimetype to desktop file]]

--[[converts a `mimeapps.list` file to an `xdg_mime` object]]
--[[@param line_iter fun(): string an iterator of lines]] --[[@param mimetypes xdg_mime?]]
mod.mimeapps_list_to_mimetypes = function (line_iter, mimetypes)
	mimetypes = mimetypes or { added = {}, removed = {}, default = {} }
	local section --[[@type string]]
	local current_table --[[@type table<string, string[]>]]
	local skip_this_section = true
	while true do
		local line = line_iter()
		if not line then break end
		if line:byte(1) == 0x5b --[[ [ ]] then
			section = line
			skip_this_section = not is_valid_section[section]
			if skip_this_section then io.stderr:write("xdg.mime: warning: invalid section: ", section) end
			if section == "[Added Associations]" then current_table = mimetypes.added
			elseif section == "[Removed Associations]" then current_table = mimetypes.removed
			elseif section == "[Added Associations]" then current_table = mimetypes.default end
			break
		end
		if skip_this_section then break end
		--[[@type integer, integer, string]]
		local _, start, mimetype = line:find("(.-)=")
		if not mimetype then io.stderr:write("xdg.mime: warning: line has invalid format: ", line); break end
		local applications
		while true do
			--[[@type integer, integer, string]]
			local _, next_start, application = line:find("(.-);", start)
			if not application then break end
			applications[#applications+1] = application
			start = next_start
		end
		applications[#applications+1] = line:sub(start)
		current_table[mimetype] = applications
	end
	return mimetypes
end

return mod

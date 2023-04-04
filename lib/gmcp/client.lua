-- https://www.gammon.com.au/gmcp
local json_to_value = require("dep.lunajson").json_to_value

-- FIXME: finish

local mod = {}

--- @return fun(s: string) cb, fun (write: fun (s: string)): fun (s: string) init `init` must be called immediately with `write` returned by tcp
--- @param cb fun(s: string) callback
--- @param gmcp_cb fun(type: string, value: unknown) callback
mod.wrap = function (cb, gmcp_cb)
	local first = true
	local server_supports_gmcp = false
	--- @param s string
	return function (s)
		if first and s:find("\xff\xfb\xc9") then
			server_supports_gmcp = true
			s = s:gsub("\xff\xfb\xc9", "", 1)
		end
		first = false
		local i = 1
		if server_supports_gmcp then
			while i <= #s do
				-- "0xFF 0xFA 0xC9 package.message <data> 0xFF 0xF0"
				local start, end_, type, value_raw = s:find("\xff\xfa\xc9(.-) (.-)\xff\xf0", i)
				if not start then
					start, end_ = s:find("\xff\xfb\xc9", i)  -- interpret_as_command will gmcp
					if start then server_supports_gmcp = true end
				end
				if start then
					cb(s:sub(i, start - 1))
					gmcp_cb(type, json_to_value(value_raw)) -- TODO: is this correct??
					i = end_ + 1
				end
			end
		end
		if i <= #s then cb(s:sub(i)) end
	end, function (write) write("\xff\xfd\xc9"); return write end -- interpret_as_command do gmcp
end

-- 0xFF 0xFB 0xC9

return mod

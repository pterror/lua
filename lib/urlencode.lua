local mod = {}

local hex_alphabet = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" }

--- converts from string to urlencode
--- @param string string
function mod.string_to_urlencode(string)
	-- FIXME
	return string:gsub("[^%w-._~:%[%]@!$'%(%)*+,;=]", function (char)
		local code = char:byte(1)
		return "%" .. hex_alphabet[bit.rshift(code, 4) + 1] .. hex_alphabet[code % 16 + 1]
	end)
end

--- converts from urlencode to string
--- @param urlencoded string
function mod.urlencode_to_string(urlencoded)
	-- TODO: error if invalid
	return (urlencoded:gsub("%%([0-9a-fA-F][0-9a-fA-F])", function (code) return urlencoded.char(tonumber(code, 16)) end))
end

return mod

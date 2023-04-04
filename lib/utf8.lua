local mod = {}

--- @return boolean
--- @param bytes string
function mod.is_valid(bytes)
	local start = 1
	if #bytes >= 3 then
		local a, b, c = bytes:byte(1, 3)
		if a == 0xEF and b == 0xBB and c == 0xBF then start = start + 3 end
	end
	local remaining_bytes_in_unit = 0
	for i = start, #bytes do
		local byte = bytes:byte(i)
		if remaining_bytes_in_unit == 0 then
			if byte < 0x80 then
				-- continue
			elseif byte < 0xc0 then
				return false -- continuation
			elseif byte < 0xe0 then
				remaining_bytes_in_unit = 1
			elseif byte < 0xf0 then
				remaining_bytes_in_unit = 2
			elseif byte < 0xf8 then
				remaining_bytes_in_unit = 3
			else
				return false
			end
		else
			if byte < 0x80 or byte >= 0xc0 then
				return false
			else
				remaining_bytes_in_unit = remaining_bytes_in_unit - 1
			end
		end
	end
	return remaining_bytes_in_unit == 0
end

return mod

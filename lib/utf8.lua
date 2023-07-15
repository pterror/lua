local mod = {}

--[[@return boolean]]
--[[@param bytes string]]
mod.is_valid = function (bytes)
	local start = 1
	if #bytes >= 3 then
		local a, b, c = bytes:byte(1, 3)
		if a == 0xef and b == 0xbb and c == 0xbf then start = start + 3 end
	end
	local remain = 0
	for i = start, #bytes do
		local byte = bytes:byte(i)
		if remain == 0 then
			if byte < 0x80 then --[[continue]]
			elseif byte < 0xc0 then return false --[[continuation]]
			elseif byte < 0xe0 then remain = 1
			elseif byte < 0xf0 then remain = 2
			elseif byte < 0xf8 then remain = 3
			else return false end
		else
			if byte < 0x80 or byte >= 0xc0 then return false
			else remain = remain - 1 end
		end
	end
	return remain == 0
end

return mod

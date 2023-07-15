local mod = {}

local base_alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
local base_alphabet_rev = {}
for i = 1, #base_alphabet do
	base_alphabet_rev[base_alphabet:byte(i)] = i - 1
end

--[[@param n integer]] --[[@param base integer]]
mod.integer_to_base = function (n, base)
	local negative_sign = ""
	if n < 0 then negative_sign = "-"; n = -n end
	if n % 1 ~= 0 then return error("integer_to_base: cannot handle decimals") end
	local parts = {}
	if n == 0 then parts[#parts+1] = "0" end
	while n > 0 do
		local i = n % base + 1
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		parts[#parts+1] = base_alphabet:sub(i, i)
		n = math.floor(n / base)
	end
	return negative_sign .. table.concat(parts):reverse()
end

--[[@param s string]] --[[@param base integer]]
mod.base_to_integer = function (s, base)
	local start = 1
	local sign = 1
	local n = 0
	if s:byte(start) == 0x2d --[[-]] then sign = -1; start = start + 1
	elseif s:byte(start) == 0x2b --[[+]] then start = start + 1 end
	for i = start, #s do
		local digit = base_alphabet_rev[s:byte(i)]
		if not digit or digit >= base then return error("base_to_integer: invalid digit '" .. s:sub(i, i) .. "'") end
		n = n * base + digit
	end
	return n * sign
end

return mod

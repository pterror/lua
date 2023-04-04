local bor = bit.bor; local band = bit.band; local lshift = bit.lshift; local rshift = bit.rshift
local byte = string.byte; local char = string.char

local mod = {}

mod.charpattern = "[\0-\x7F\xC2-\xF4][\x80-\xBF]*"

--[[@param ... integer]] --[[@return string encoded]]
mod.char = function (...)
	local parts = {}
	local nums = { ... }
	for i = 1, #nums do
		local n = nums[i]
		if n <= 0x7f then parts[#parts+1] = char(n)
		elseif n <= 0x7ff then parts[#parts+1] = char(bor(0xc0, rshift(n, 6)), bor(0x80, band(n, 0x3f)))
		elseif n <= 0xffff then parts[#parts+1] = char(bor(0xe0, rshift(n, 12)), bor(0x80, band(rshift(n, 6), 0x3f)), bor(0x80, band(n, 0x3f)))
		else parts[#parts+1] = char(bor(0xf0, rshift(n, 18)), bor(0x80, band(rshift(n, 12), 0x3f)), bor(0x80, band(rshift(n, 6), 0x3f)), bor(0x80, band(n, 0x3f))) end
	end
	return table.concat(parts)
end

local high_nibble_to_length = {
	[0] = 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 2, 2, 3, 4
}
local length_to_signifier = { 0, 0xc0, 0xe0, 0xf0 }
local length_to_mask = { 0, 0x1f, 0xf, 0x7 }

--[[@param s string]] --[[@param i? integer]] --[[@param j? integer]]
mod.len = function (s, i, j)
	i = i or 1
	if i < 0 then i = #s + i + 1 end
	j = j or #s
	if j < 0 then j = #s + j + 1 end
	if i == #s + 1 then return 0 end
	-- not sure this is correct behavior
	if i > #s or band(byte(s, i), 0xc0) == 0x80 then return nil, i end
	local len = 0
	while i <= j do
		local b = byte(s, i)
		-- tight inner loop for ascii
		while i <= j and band(b, 0x80) == 0 do len = len + 1; i = i + 1; b = byte(s, i) end
		if i <= j then
			-- predicted length
			local plen = high_nibble_to_length[rshift(b, 4)]
			if plen == 0 or plen == 4 and band(b, 0x40) == 0x40 then return nil, i end
			for k = i + 1, i + plen - 1 do
				if band(byte(s, k), 0xc0) ~= 0x80 then return nil, i end
			end
			len = len + 1
			i = i + plen
		end
	end
	return len
end

--[[@param s string]] --[[@param i? integer]] --[[@param j? integer]]
mod.codepoint = function (s, i, j)
	i = i or 1
	if i < 0 then i = #s + i + 1 end
	j = j or i
	if j < 0 then j = #s + j + 1 end
	if band(byte(s, i), 0xc0) == 0x80 then return error("invalid byte sequence at " .. i) end
	local cs = {}
	while i <= j do
		local b = byte(s, i)
		-- tight inner loop for ascii
		while i <= j and band(b, 0x80) == 0 do cs[#cs+1] = b; i = i + 1; b = byte(s, i) end
		if i <= j then
			local plen = high_nibble_to_length[rshift(b, 4)]
			if plen == 0 or plen == 4 and band(b, 0x40) == 0x40 then error("invalid byte sequence at " .. i) end
			local c = bor(length_to_signifier[plen], band(length_to_mask[plen], b))
			for k = i + 1, i + plen - 1 do
				local b2 = byte(s, k)
				if band(b2, 0xc0) ~= 0x80 then return error("invalid byte sequence at " .. k) end
				c = bor(lshift(c, 6), band(b2, 0x3f))
			end
			cs[#cs+1] = c
		end
	end
	return unpack(cs)
end

--[[@param s string]] --[[@param p integer]]
local codes_iter = function (s, p)
	if p == nil then p = 1
	else p = p + high_nibble_to_length[rshift(byte(s, p), 4)] end
	if p > #s then return end
	local b = byte(s, p)
	if b <= 0xff then return p, b end
	local plen = high_nibble_to_length[rshift(b, 4)]
	if plen == 0 or plen == 4 and band(b, 0x40) == 0x40 then error("invalid byte sequence at " .. p) end
	local c = bor(length_to_signifier[plen], band(length_to_mask[plen], b))
	for k = p + 1, p + plen - 1 do
		local b2 = byte(s, k)
		if band(b2, 0xc0) ~= 0x80 then return error("invalid byte sequence at " .. k) end
		c = bor(lshift(c, 6), band(b2, 0x3f))
	end
	return p, c
end

--[[returns an iterator that returns `p` (the start index of the current character)]]
--[[and `c` (the codepoint of the current character)]]
--[[@param s string]]
mod.codes = function (s)
	return codes_iter, s
end

--[[finds the index of the start of the character `n` characters away from .  ]]
--[[`n` may be negative.  ]]
--[[`i` is 1 if `n>0`; `#s+1` if `n<0`.  ]]
--[[if `n==0` then it returns the index of the start of the character]]
--[[that contains `s[i]`]]
--[[@param s string]] --[[@param n integer]] --[[@param i? integer]]
mod.offset = function (s, n, i)
	if n == 0 then
		i = i or 1
		while i < #s and band(byte(s, i), 0xc0) == 0x80 do i = i - 1 end
		return i
	elseif n >= 0 then
		i = i or 1
		local len = #s
		while i <= len and band(byte(s, i), 0xc0) == 0x80 do i = i + 1 end
		if i > len then return i end
		for _ = 2, n do
			if i > len then return i end
			i = i + 1
			while i <= len and band(byte(s, i), 0xc0) == 0x80 do i = i + 1 end
		end
		return i
	else
		i = i or #s + 1
		for _ = 1, -n do
			i = i - 1
			while i >= 1 and band(byte(s, i), 0xc0) == 0x80 do i = i - 1 end
			if i < 1 then return i end
		end
		return i
	end
end

return mod

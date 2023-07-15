-- https://github.com/mpeterv/sha1/tree/9b462c7610e1817373a7a358d4291da25226b3ce
--[[
Copyright (c) 2013 Enrique García Cota, Eike Decker, Jeffrey Friedl
Copyright (c) 2018 Peter Melnichenko

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- changes:
-- - used luajit impl
-- - removed metatable
-- - removed module metadata

local mod = {}

local bxor = bit.bxor; local band = bit.band; local bor = bit.bor; local rol = bit.rol
local char = string.char; local byte = string.byte; local format = string.format; local rep = string.rep

local uint32_ternary = function (a, b, c)
	--[[c ~ (a & (b ~ c)) has fewer bitwise operations than (a & b) | (~a & c).]]
	return bxor(c, band(a, bxor(b, c)))
end

local uint32_majority = function (a, b, c)
	--[[(a & (b | c)) | (b & c) has fewer bitwise operations than (a & b) | (a & c) | (b & c).]]
	return bor(band(a, bor(b, c)), band(b, c))
end

local bytes_to_uint32 = function (a, b, c, d) return a * 0x1000000 + b * 0x10000 + c * 0x100 + d end

--[[Splits a uint32 number into four bytes.]]
--[[@return integer, integer, integer, integer]] --[[@param a integer]]
local uint32_to_bytes = function (a)
	local a4 = a % 256
	--[[@diagnostic disable-next-line: cast-local-type]]
	a = (a - a4) / 256
	local a3 = a % 256
	--[[@diagnostic disable-next-line: cast-local-type]]
	a = (a - a3) / 256
	local a2 = a % 256
	local a1 = (a - a2) / 256
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	return a1, a2, a3, a4
end

--[[@return string]] --[[@param hex string]]
local hex_to_binary = function (hex)
	return (hex:gsub("..", function(hexval)
		return char(tonumber(hexval, 16))
	end))
end

--[[Calculates SHA1 for a string, returns it encoded as 40 hexadecimal digits.]]
--[[@return string]] --[[@param str string]]
mod.sha1 = function (str)
	local first_append = char(0x80)
	local non_zero_message_bytes = #str + 1 + 8
	local second_append = rep(char(0), -non_zero_message_bytes % 64)
	local third_append = char(0, 0, 0, 0, uint32_to_bytes(#str * 8))
	str = str .. first_append .. second_append .. third_append
	assert(#str % 64 == 0)
	local h0 = 0x67452301
	local h1 = 0xefcdab89
	local h2 = 0x98badcfe
	local h3 = 0x10325476
	local h4 = 0xc3d2e1f0
	local w = {}
	for chunk_start = 1, #str, 64 do
		local uint32_start = chunk_start
		for i = 0, 15 do
			w[i] = bytes_to_uint32(byte(str, uint32_start, uint32_start + 3))
			uint32_start = uint32_start + 4
		end
		for i = 16, 79 do w[i] = rol(bxor(w[i - 3], w[i - 8], w[i - 14], w[i - 16]), 1) end
		local a = h0
		local b = h1
		local c = h2
		local d = h3
		local e = h4
		for i = 0, 79 do
			local f
			local k
			if i <= 19 then f = uint32_ternary(b, c, d); k = 0x5a827999
			elseif i <= 39 then f = bxor(b, c, d); k = 0x6ed9eba1
			elseif i <= 59 then f = uint32_majority(b, c, d); k = 0x8f1bbcdc
			else f = bxor(b, c, d); k = 0xca62c1d6 end
			local temp = (rol(a, 5) + f + e + k + w[i]) % 4294967296
			e = d
			d = c
			c = rol(b, 30)
			b = a
			a = temp
		end
		h0 = (h0 + a) % 4294967296
		h1 = (h1 + b) % 4294967296
		h2 = (h2 + c) % 4294967296
		h3 = (h3 + d) % 4294967296
		h4 = (h4 + e) % 4294967296
	end
	return format("%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4)
end

--[[Calculates SHA1 for a string, returns it as a binary string]]
--[[@return string]] --[[@param str string]]
mod.binary = function (str) return hex_to_binary(mod.sha1(str)) end

--[[Precalculate replacement tables.]]

local xor_with_0x5c = {}
local xor_with_0x36 = {}

for i = 0, 0xff do
	xor_with_0x5c[char(i)] = char(bxor(0x5c, i))
	xor_with_0x36[char(i)] = char(bxor(0x36, i))
end

--[[512 bits.]]
local BLOCK_SIZE = 64

--[[Calculates HMAC message digest for a string, returns it as a hexadecimal ]]
--[[@return string]] --[[@param key string]] --[[@param text string]]
mod.hmac = function (key, text)
	if #key > BLOCK_SIZE then
		key = mod.binary(key)
	end

	local key_xord_with_0x36 = key:gsub(".", xor_with_0x36) .. rep(char(0x36), BLOCK_SIZE - #key)
	local key_xord_with_0x5c = key:gsub(".", xor_with_0x5c) .. rep(char(0x5c), BLOCK_SIZE - #key)

	return mod.sha1(key_xord_with_0x5c .. mod.binary(key_xord_with_0x36 .. text))
end

--[[Calculates HMAC message digest for a string, returns it as a binary string]]
mod.hmac_binary = function (key, text)
	return hex_to_binary(mod.hmac(key, text))
end

return mod

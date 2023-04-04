-- https://github.com/iskolbin/lbase64/tree/c261320edbdf82c16409d893a96c28c704aa0ab8
--[[
------------------------------------------------------------------------------
This software is available under 2 licenses -- choose whichever you prefer.
------------------------------------------------------------------------------
ALTERNATIVE A - MIT License
Copyright (c) 2018 Ilya Kolbin
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
------------------------------------------------------------------------------
ALTERNATIVE B - Public Domain (www.unlicense.org)
This is free and unencumbered software released into the public domain.
Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.
In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
------------------------------------------------------------------------------
--]]
-- changes:
-- - whitespace padding changes
-- - tab -> 2 spaces
-- - removed custom encoder/decoder
-- - inline luajit values

local mod = {}

local function extract(v, from, width)
	return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
end

local encoder = {}
for b64code, char in pairs({
	[ 0]="A", "B", "C", "D", "E", "F", "G", "H",
	"I", "J", "K", "L", "M", "N", "O", "P",
	"Q", "R", "S", "T", "U", "V", "W", "X",
	"Y", "Z", "a", "b", "c", "d", "e", "f",
	"g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v",
	"w", "x", "y", "z", "0", "1", "2", "3",
	"4", "5", "6", "7", "8", "9", "+", "/",
	"="
}) do
	encoder[b64code] = char:byte()
end

local decoder = {}
for b64code, charcode in pairs(encoder) do
	decoder[charcode] = b64code
end

--- @param str string
--- @param usecaching? boolean
function mod.encode(str, usecaching)
	local t = {}
	local k = 1
	local n = #str
	local lastn = n % 3
	local cache = {}
	for i = 1, n-lastn, 3 do
		local a, b, c = str:byte(i, i + 2)
		local v = a * 0x10000 + b * 0x100 + c
		local s
		if usecaching then
			s = cache[v]
			if not s then
				s = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
				cache[v] = s
			end
		else
			s = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
		end
		t[k] = s
		k = k + 1
	end
	if lastn == 2 then
		local a, b = str:byte(n - 1, n)
		local v = a * 0x10000 + b * 0x100
		t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = str:byte(n) * 0x10000
		t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end
	return table.concat(t)
end

--- @return string
--- @param b64 string
--- @param usecaching? boolean
function mod.decode(b64, usecaching)
	local pattern = "[^%w%+%/%=]"
	b64 = b64:gsub(pattern, "")
	local cache = usecaching and {}
	local t = {}
	local k = 1
	local n = #b64
	local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0
	for i = 1, padding > 0 and n - 4 or n, 4 do
		local a, b, c, d = b64:byte(i, i + 3)
		local s
		if usecaching then
			local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
			--[[@diagnostic disable-next-line: need-check-nil]]
			s = cache[v0]
			if not s then
				local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
				s = string.char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
				cache[v0] = s
			end
		else
			local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
			s = string.char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
		end
		t[k] = s
		k = k + 1
	end
	if padding == 1 then
		local a, b, c = b64:byte(n - 3, n - 1)
		local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
		t[k] = string.char(extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = b64:byte(n - 3, n - 2)
		local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
		t[k] = string.char(extract(v,16,8))
	end
	return table.concat(t)
end

mod.string_to_base64 = mod.encode
mod.base64_to_string = mod.decode

return mod

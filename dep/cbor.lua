--[[
Copyright (c) 2014-2015 Kim Alvefur

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
-- Concise Binary Object Representation (CBOR)
-- RFC 7049

-- changes:
-- - local function x -> local x = function
-- - parens around dostring and error

local mod = {}

local softreq = function (pkg, field)
	local ok, module = pcall(require, pkg)
	if not ok then return end
	if field then return module[field] end
	return module
end

-- not sure why this is needed
local dostring = function (s)
	local ok, f = load(function()
		local ret = s
		s = nil
		return ret
	end)
	if ok and f then
		return f()
	end
end

--- @diagnostic disable-next-line: undefined-field
local maxint = math.maxinteger or 9007199254740992
--- @diagnostic disable-next-line: undefined-field
local minint = math.mininteger or -9007199254740992
local nan = 0/0
local ldexp = math.ldexp or function (x, exp) return x * 2.0 ^ exp end
local inf = math.huge
local m_type = math.type or function (n) return n % 1 == 0 and n <= maxint and n >= minint and "integer" or "float" end
--- @type nil|(fun(fmt: string, v1: string|number, v2: any, ...: string|number): string)
--- @diagnostic disable-next-line: deprecated
local pack = string.pack or softreq("struct", "pack")
--- @type nil|(fun(fmt: string, s: string, pos?: integer): ..., integer)
--- @diagnostic disable-next-line: deprecated
local unpack = string.unpack or softreq("struct", "unpack")
local rshift = softreq("bit32", "rshift") or softreq("bit", "rshift") or
	dostring("return function(a, b) return a >> b end") or
	function (a, b) return math.max(0, math.floor(a / (2 ^ b))) end

-- sanity check
if pack and pack(">I2", 0) ~= "\0\0" then
	pack = nil
end
if unpack and unpack(">I2", "\1\2\3\4") ~= 0x102 then
	unpack = nil
end

local _ENV = nil -- luacheck: ignore 211

local encoder = {}

local encode = function (obj, opts)
	return encoder[type(obj)](obj, opts)
end
mod.encode = encode
mod.value_to_cbor = encode

-- Major types 0, 1 and length encoding for others
--- @param num integer
local integer = function (num, m)
	if m == 0 and num < 0 then
		-- negative integer, major type 1
		num, m = - num - 1, 32
	end
	if num < 24 then
		return string.char(m + num)
	elseif num < 2 ^ 8 then
		return string.char(m + 24, num)
	elseif num < 2 ^ 16 then
		return string.char(m + 25, rshift(num, 8), num % 0x100)
	elseif num < 2 ^ 32 then
		return string.char(m + 26,
			rshift(num, 24) % 0x100,
			rshift(num, 16) % 0x100,
			rshift(num, 8) % 0x100,
			num % 0x100)
	elseif num < 2 ^ 64 then
		local high = math.floor(num / 2 ^ 32)
		--- @diagnostic disable-next-line: cast-local-type
		num = num % 2 ^ 32
		return string.char(m + 27,
			rshift(high, 24) % 0x100,
			rshift(high, 16) % 0x100,
			rshift(high, 8) % 0x100,
			high % 0x100,
			rshift(num, 24) % 0x100,
			rshift(num, 16) % 0x100,
			rshift(num, 8) % 0x100,
			num % 0x100)
	end
	error("int too large")
end

if pack then
	integer = function (num, m)
		local fmt
		m = m or 0
		if num < 24 then
			fmt, m = ">B", m + num
		elseif num < 256 then
			fmt, m = ">BB", m + 24
		elseif num < 65536 then
			fmt, m = ">BI2", m + 25
		elseif num < 4294967296 then
			fmt, m = ">BI4", m + 26
		else
			fmt, m = ">BI8", m + 27
		end
		return pack(fmt, m, num)
	end
end

local simple_mt = {}
simple_mt.__tostring = function (self) return self.name or ("simple(%d)"):format(self.value) end
simple_mt.__tocbor = function (self) return self.cbor or integer(self.value, 224) end

local simple = function (value, name, cbor)
	assert(value >= 0 and value <= 255, "bad argument #1 to 'simple' (integer in range 0..255 expected)")
	return setmetatable({ value = value, name = name, cbor = cbor }, simple_mt)
end
mod.simple = simple

local tagged_mt = {}
tagged_mt.__tostring = function (self) return ("%d(%s)"):format(self.tag, tostring(self.value)) end
tagged_mt.__tocbor = function (self) return integer(self.tag, 192) .. encode(self.value) end

local tagged = function (tag, value)
	assert(tag >= 0, "bad argument #1 to 'tagged' (positive integer expected)")
	return setmetatable({ tag = tag, value = value }, tagged_mt)
end
mod.tagged = tagged

local null = simple(22, "null") -- explicit null
mod.null = null
local undefined = simple(23, "undefined") -- undefined or nil
mod.undefined = undefined
local BREAK = simple(31, "break", "\255")

-- Number types dispatch
--- @param num number
encoder.number = function (num)
	return encoder[m_type(num)](num)
end

-- Major types 0, 1
--- @param num integer
encoder.integer = function (num)
	if num < 0 then
		return integer(-1 - num, 32)
	end
	return integer(num, 0)
end

if pack then
	--- @param num number
	encoder.float = function (num)
		return pack(">Bd", 251, num)
	end
else
	-- Major type 7
	--- @param num number
	encoder.float = function (num)
		if num ~= num then -- NaN shortcut
			return "\251\127\255\255\255\255\255\255\255"
		end
		local sign = (num > 0 or 1 / num > 0) and 0 or 1
		num = math.abs(num)
		if num == math.huge then
			return string.char(251, sign * 128 + 128 - 1) .. "\240\0\0\0\0\0\0"
		end
		local fraction, exponent = math.frexp(num)
		if fraction == 0 then
			return string.char(251, sign * 128) .. "\0\0\0\0\0\0\0"
		end
		fraction = fraction * 2
		exponent = exponent + 1024 - 2
		if exponent <= 0 then
			fraction = fraction * 2 ^ (exponent - 1)
			exponent = 0
		else
			fraction = fraction - 1
		end
		return string.char(251,
			--- @diagnostic disable-next-line: param-type-mismatch
			sign * 2 ^ 7 + math.floor(exponent / 2 ^ 4) % 2 ^ 7,
			exponent % 2 ^ 4 * 2 ^ 4 +
			math.floor(fraction * 2 ^ 4 % 0x100),
			math.floor(fraction * 2 ^ 12 % 0x100),
			math.floor(fraction * 2 ^ 20 % 0x100),
			math.floor(fraction * 2 ^ 28 % 0x100),
			math.floor(fraction * 2 ^ 36 % 0x100),
			math.floor(fraction * 2 ^ 44 % 0x100),
			math.floor(fraction * 2 ^ 52 % 0x100)
		)
	end
end


-- Major type 2 - byte strings
--- @param s string
encoder.bytestring = function (s)
	return integer(#s, 64) .. s
end

-- Major type 3 - UTF-8 strings
--- @param s string
encoder.utf8string = function (s)
	return integer(#s, 96) .. s
end

-- Lua strings are byte strings
encoder.string = encoder.bytestring

--- @param bool boolean
encoder.boolean = function (bool)
	return bool and "\245" or "\244"
end

--- @param _ nil
encoder["nil"] = function (_) return "\246" end

--- @param ud userdata
encoder.userdata = function (ud, opts)
	local mt = debug.getmetatable(ud)
	if mt then
		local encode_ud = opts and opts[mt] or mt.__tocbor
		if encode_ud then
			return encode_ud(ud, opts)
		end
	end
	error("can't encode userdata")
end

--- @param t {}
encoder.table = function (t, opts)
	local mt = getmetatable(t)
	if mt then
		local encode_t = opts and opts[mt] or mt.__tocbor
		if encode_t then
			return encode_t(t, opts)
		end
	end
	-- the table is encoded as an array iff when we iterate over it,
	-- we see successive integer keys starting from 1.  The lua
	-- language doesn't actually guarantee that this will be the case
	-- when we iterate over a table with successive integer keys, but
	-- due an implementation detail in PUC Rio Lua, this is what we
	-- usually observe.  See the Lua manual regarding the # (length)
	-- operator.  In the case that this does not happen, we will fall
	-- back to a map with integer keys, which becomes a bit larger.
	local array = { integer(#t, 128) }
	local map = { "\191" }
	local i = 1
	local p = 2
	local is_array = true
	for k, v in pairs(t) do
		is_array = is_array and i == k
		i = i + 1

		local encoded_v = encode(v, opts)
		array[i] = encoded_v

		map[p], p = encode(k, opts), p + 1
		map[p], p = encoded_v, p + 1
	end
	-- map[p] = "\255"
	map[1] = integer(i - 1, 160)
	return table.concat(is_array and array or map)
end

-- Array or dict-only encoders, which can be set as __tocbor metamethod
--- @param t unknown[]
encoder.array = function (t, opts)
	local array = { }
	for i, v in ipairs(t) do
		array[i] = encode(v, opts)
	end
	return integer(#array, 128) .. table.concat(array)
end

--- @param t {}
encoder.map = function (t, opts)
	local map = { "\191" }
	local p = 2
	local len = 0
	for k, v in pairs(t) do
		map[p], p = encode(k, opts), p + 1
		map[p], p = encode(v, opts), p + 1
		len = len + 1
	end
	-- map[p] = "\255"
	map[1] = integer(len, 160)
	return table.concat(map)
end
encoder.dict = encoder.map -- COMPAT

--- @param t {}
encoder.ordered_map = function (t, opts)
	local map = {}
	if not t[1] then -- no predefined order
		local i = 0
		for k in pairs(t) do
			i = i + 1
			map[i] = k
		end
		table.sort(map)
	end
	for i, k in ipairs(t[1] and t or map) do
		map[i] = encode(k, opts) .. encode(t[k], opts)
	end
	return integer(#map, 160) .. table.concat(map)
end

--- @param _ function
encoder["function"] = function (_)
	error("can't encode function")
end

mod.type_encoders = encoder

-- Decoder
-- Reads from a file-handle like object
local read_bytes = function (fh, len)
	return fh:read(len)
end

local read_byte = function (fh)
	return fh:read(1):byte()
end

local read_length = function (fh, mintyp)
	if mintyp < 24 then
		return mintyp
	elseif mintyp < 28 then
		local out = 0
		for _ = 1, 2 ^ (mintyp - 24) do
			out = out * 256 + read_byte(fh)
		end
		return out
	else
		error("invalid length")
	end
end

local decoder = {}

local read_type = function (fh)
	local byte = read_byte(fh)
	return rshift(byte, 5), byte % 32
end

local read_object = function (fh, opts)
	local typ, mintyp = read_type(fh)
	return decoder[typ](fh, mintyp, opts)
end
mod.decode_file = read_object

local read_integer = function (fh, mintyp)
	return read_length(fh, mintyp)
end

local read_negative_integer = function (fh, mintyp)
	return -1 - read_length(fh, mintyp)
end

local read_string = function (fh, mintyp)
	if mintyp ~= 31 then
		return read_bytes(fh, read_length(fh, mintyp))
	end
	local out = {}
	local i = 1
	local v = read_object(fh)
	while v ~= BREAK do
		out[i], i = v, i + 1
		v = read_object(fh)
	end
	return table.concat(out)
end

local read_unicode_string = function (fh, mintyp)
	return read_string(fh, mintyp)
	-- local str = read_string(fh, mintyp)
	-- if have_utf8 and not utf8.len(str) then
		-- TODO How to handle this?
	-- end
	-- return str
end

local read_array = function (fh, mintyp, opts)
	local out = {}
	if mintyp == 31 then
		local i = 1
		local v = read_object(fh, opts)
		while v ~= BREAK do
			out[i], i = v, i + 1
			v = read_object(fh, opts)
		end
	else
		local len = read_length(fh, mintyp)
		for i = 1, len do
			out[i] = read_object(fh, opts)
		end
	end
	return out
end

local read_map = function (fh, mintyp, opts)
	local out = {}
	local k
	if mintyp == 31 then
		local i = 1
		k = read_object(fh, opts)
		while k ~= BREAK do
			out[k], i = read_object(fh, opts), i + 1
			k = read_object(fh, opts)
		end
	else
		local len = read_length(fh, mintyp)
		for _ = 1, len do
			k = read_object(fh, opts)
			out[k] = read_object(fh, opts)
		end
	end
	return out
end

local tagged_decoders = {}
mod.tagged_decoders = tagged_decoders

local read_semantic = function (fh, mintyp, opts)
	local tag = read_length(fh, mintyp)
	local value = read_object(fh, opts)
	local postproc = opts and opts[tag] or tagged_decoders[tag]
	if postproc then
		return postproc(value)
	end
	return tagged(tag, value)
end

local read_half_float = function (fh)
	local exponent = read_byte(fh)
	local fraction = read_byte(fh)
	local sign = exponent < 128 and 1 or -1 -- sign is highest bit

	fraction = fraction + (exponent * 256) % 1024 -- copy two(?) bits from exponent to fraction
	exponent = rshift(exponent, 2) % 32 -- remove sign bit and two low bits from fraction

	if exponent == 0 then
		return sign * ldexp(fraction, -24)
	elseif exponent ~= 31 then
		return sign * ldexp(fraction + 1024, exponent - 25)
	elseif fraction == 0 then
		return sign * inf
	else
		return nan
	end
end

local read_float = function (fh)
	local exponent = read_byte(fh)
	local fraction = read_byte(fh)
	local sign = exponent < 128 and 1 or -1 -- sign is highest bit
	exponent = exponent * 2 % 256 + rshift(fraction, 7)
	fraction = fraction % 128
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)

	if exponent == 0 then
		return sign * ldexp(exponent, -149)
	elseif exponent ~= 0xff then
		return sign * ldexp(fraction + 2 ^ 23, exponent - 150)
	elseif fraction == 0 then
		return sign * inf
	else
		return nan
	end
end

local read_double = function (fh)
	local exponent = read_byte(fh)
	local fraction = read_byte(fh)
	local sign = exponent < 128 and 1 or -1 -- sign is highest bit

	exponent = exponent %  128 * 16 + rshift(fraction, 4)
	fraction = fraction % 16
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)
	fraction = fraction * 256 + read_byte(fh)

	if exponent == 0 then
		return sign * ldexp(exponent, -149)
	elseif exponent ~= 0xff then
		return sign * ldexp(fraction + 2 ^ 52, exponent - 1075)
	elseif fraction == 0 then
		return sign * inf
	else
		return nan
	end
end


if unpack then
	read_float = function (fh) return unpack(">f", read_bytes(fh, 4)) end
	read_double = function (fh) return unpack(">d", read_bytes(fh, 8)) end
end

local read_simple = function (fh, value, opts)
	if value == 24 then
		value = read_byte(fh)
	end
	if value == 20 then
		return false
	elseif value == 21 then
		return true
	elseif value == 22 then
		return null
	elseif value == 23 then
		return undefined
	elseif value == 25 then
		return read_half_float(fh)
	elseif value == 26 then
		return read_float(fh)
	elseif value == 27 then
		return read_double(fh)
	elseif value == 31 then
		return BREAK
	end
	if opts and opts.simple then
		return opts.simple(value)
	end
	return simple(value)
end

decoder[0] = read_integer
decoder[1] = read_negative_integer
decoder[2] = read_string
decoder[3] = read_unicode_string
decoder[4] = read_array
decoder[5] = read_map
decoder[6] = read_semantic
decoder[7] = read_simple
mod.type_decoders = decoder

-- opts.more(n) -> want more data
-- opts.simple -> decode simple value
-- opts[int] -> tagged decoder
mod.decode = function (s, opts)
	local fh = {}
	local pos = 1

	--- @type fun(_: integer?, _, _)
	local more
	if type(opts) == "function" then
		more = opts
	elseif type(opts) == "table" then
		more = opts.more
	elseif opts ~= nil then
		error(("bad argument #2 to 'decode' (function or table expected, got %s)"):format(type(opts)))
	end
	if type(more) ~= "function" then
		function more()
			error("input too short")
		end
	end

	--- @param bytes integer
	function fh:read(bytes)
		local ret = s:sub(pos, pos + bytes - 1)
		if #ret < bytes then
			ret = more(bytes - #ret, fh, opts)
			if ret then self:write(ret) end
			return self:read(bytes)
		end
		pos = pos + bytes
		return ret
	end

	function fh:write(bytes) -- luacheck: no self
		s = s .. bytes
		if pos > 256 then
			s = s:sub(pos + 1)
			pos = 1
		end
		return #bytes
	end

	return read_object(fh, opts)
end
mod.cbor_to_value = mod.decode

return mod

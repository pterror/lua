--[[changes made:]]
--[[- combine into single file]]
--[[- other stuff i forgot]]
--[[- local function x -> local x = function]]
--[[- inline _decode_error into decode_error]]

local mod = {}

local _, null_mod = pcall(require, "lib.null")
mod.null = null_mod and null_mod.null or {}

local f_string_esc_pat = "[^ -!#-[%]^-\255]"
local f_str_ctrl_pat = "[^\32-\255]"

local v, enc_nullv
local i, builder, visited

local match = string.match; local find = string.find; local format = string.format; local gsub = string.gsub
local byte = string.byte; local sub = string.sub; local char = string.char; local concat = table.concat
local floor = math.floor

local f_tostring = function (v2) builder[i] = tostring(v2); i = i + 1 end

local radixmark = match(tostring(0.5), "[^0-9]")
local delimmark = match(tostring(12345.12345), "[^0-9" .. radixmark .. "]")
if radixmark == "." then radixmark = nil end

local radixordelim
if radixmark or delimmark then
	radixordelim = true
	if radixmark and find(radixmark, "%W") then radixmark = "%" .. radixmark end
	if delimmark and find(delimmark, "%W") then delimmark = "%" .. delimmark end
end

local f_number = function(n)
	if -1e999 < n and n < 1e999 then
		local s = format("%.17g", n)
		if radixordelim then
			if delimmark then s = gsub(s, delimmark, "") end
			if radixmark then s = gsub(s, radixmark, ".") end
		end
		builder[i] = s
		i = i+1
		return
	end
	error("invalid number")
end

local doencode

local f_string_subst = setmetatable({
	["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t",
}, {
	__index = function(_, c) return format("\\u00%02X", byte(c)) end,
})

local f_string = function (s)
	builder[i] = "\""
	if find(s, f_string_esc_pat) then s = gsub(s, f_string_esc_pat, f_string_subst) end
	builder[i+1] = s
	builder[i+2] = "\""
	i = i + 3
end

local f_table = function (o)
	if visited[o] then error("loop detected") end
	visited[o] = true
	local tmp = o[0]
	if type(tmp) == "number" then -- arraylen available
		builder[i] = "["
		i = i + 1
		for j = 1, tmp do doencode(o[j]); builder[i] = ","; i = i + 1 end
		if tmp > 0 then i = i - 1 end
		builder[i] = "]"
	else
		tmp = o[1]
		if tmp ~= nil then -- detected as array
			builder[i] = "["
			i = i + 1
			local j = 2
			repeat
				doencode(tmp)
				tmp = o[j]
				if tmp == nil then break end
				j = j + 1
				builder[i] = ","
				i = i + 1
			until false
			builder[i] = "]"

		else -- detected as object
			builder[i] = "{"
			i = i + 1
			local tmp2 = i
			for k, v2 in pairs(o) do
				if type(k) ~= "string" then error("non-string key") end
				f_string(k)
				builder[i] = ":"
				i = i + 1
				doencode(v2)
				builder[i] = ","
				i = i + 1
			end
			if i > tmp2 then i = i - 1 end
			builder[i] = "}"
		end
	end
	i = i+1
	visited[o] = nil
end

local enc_dispatcher = setmetatable({
	boolean = f_tostring, number = f_number, string = f_string, table = f_table,
}, {
	__index = function (_, type) error("invalid type value: " .. type) end
})

doencode = function (v2)
	if v2 == enc_nullv then
		builder[i] = "null"
		i = i+1
		return
	end
	return enc_dispatcher[type(v2)](v2)
end

mod.encode = function (v_, nullv_)
	v, enc_nullv = v_, nullv_ or mod.null
	i, builder, visited = 1, {}, {}
	doencode(v)
	return concat(builder)
end
mod.value_to_json = mod.encode

local json, pos, dec_nullv, arraylen, rec_depth

--[[`f` is the temporary for dispatcher[c] and the dummy for the first return value of `find`]]
local dec_dispatcher, f

local decode_error = function (errmsg) return error("parse error at " .. pos .. ": " .. errmsg, 2) end

local f_err = function () decode_error("invalid value") end

local f_nul = function ()
	if sub(json, pos, pos+2) == "ull" then pos = pos + 3; return dec_nullv end
	decode_error("invalid value")
end

--[[false]]
local f_fls = function ()
	if sub(json, pos, pos+3) == "alse" then pos = pos + 4; return false end
	decode_error("invalid value")
end

--[[true]]
local f_tru = function ()
	if sub(json, pos, pos+2) == "rue" then pos = pos + 3; return true end
	decode_error("invalid value")
end

--[[deal with non-standard locales]]
local radixmark2 = match(tostring(0.5), "[^0-9]")
local fixedtonumber = tonumber
if radixmark2 ~= "." then
	if find(radixmark2, "%W") then radixmark2 = "%" .. radixmark2 end
	fixedtonumber = function (s) return tonumber(gsub(s, ".", radixmark2)) end
end

local number_error = function () return decode_error("invalid number") end

--[[`0(\.[0-9]*)?([eE][+-]?[0-9]*)?`]]
local f_zro = function (mns)
	local num, c = match(json, "^(%.?[0-9]*)([-+.A-Za-z]?)", pos)  --[[skipping 0]]
	if num == "" then
		if c == "" then if mns then return -0.0 end; return 0 end
		if c == "e" or c == "E" then
			num, c = match(json, "^([^eE]*[eE][-+]?[0-9]+)([-+.A-Za-z]?)", pos)
			if c == "" then
				pos = pos + #num
				if mns then return -0.0 end
				return 0.0
			end
		end
		number_error()
	end
	if byte(num) ~= 0x2E or byte(num, -1) == 0x2E then number_error() end
	if c ~= "" then
		if c == "e" or c == "E" then num, c = match(json, "^([^eE]*[eE][-+]?[0-9]+)([-+.A-Za-z]?)", pos) end
		if c ~= "" then number_error() end
	end
	pos = pos + #num
	c = fixedtonumber(num)
	if mns then c = -c end
	return c
end

--[[`[1-9][0-9]*(\.[0-9]*)?([eE][+-]?[0-9]*)?`]]
local f_num = function (mns)
	pos = pos - 1
	local num, c = match(json, "^([0-9]+%.?[0-9]*)([-+.A-Za-z]?)", pos)
	--[[error if ended with period]]
	if byte(num, -1) == 0x2E then number_error() end
	if c ~= "" then
		if c ~= "e" and c ~= "E" then number_error() end
		num, c = match(json, "^([^eE]*[eE][-+]?[0-9]+)([-+.A-Za-z]?)", pos)
		if not num or c ~= "" then number_error() end
	end
	pos = pos + #num
	c = fixedtonumber(num)
	if mns then return -c else return c end
end

-- skip minus sign
local f_mns = function ()
	local c = byte(json, pos)
	if c then
		pos = pos + 1
		if c > 0x30 then if c < 0x3A then return f_num(true) end
		else if c > 0x2F then return f_zro(true) end end
	end
	decode_error("invalid number")
end

local f_str_hextbl = setmetatable({
	0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7,
	0x8, 0x9, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999,
	1e999, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 1e999,
	1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999,
	1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999,
	1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999, 1e999,
	1e999, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF,
}, { __index = function()
	return 1e999
end })

local f_str_escapetbl = setmetatable({
	["\""] = "\"", ["\\"] = "\\", ["/"] = "/", ["b"] = "\b", ["f"] = "\f", ["n"] = "\n", ["r"] = "\r", ["t"] = "\t",
}, {
	__index = function () decode_error("invalid escape sequence") end,
})

local surrogate_first_error = function () return decode_error("first surrogate pair byte not continued by second") end

local f_str_surrogate_prev = 0
local f_str_subst = function (ch, ucode)
	if ch == "u" then
		local c1, c2, c3, c4, rest = byte(ucode, 1, 5)
		ucode = f_str_hextbl[c1 - 47] * 0x1000 + f_str_hextbl[c2 - 47] * 0x100 + f_str_hextbl[c3 - 47] * 0x10 + f_str_hextbl[c4 - 47]
		if ucode ~= 1e999 then
			if ucode < 0x80 then --[[1byte]]
				if rest then return char(ucode, rest) end
				return char(ucode)
			elseif ucode < 0x800 then --[[2bytes]]
				c1 = floor(ucode / 0x40)
				c2 = ucode - c1 * 0x40
				c1 = c1 + 0xC0
				c2 = c2 + 0x80
				if rest then return char(c1, c2, rest) end
				return char(c1, c2)
			elseif ucode < 0xD800 or 0xE000 <= ucode then --[[3bytes]]
				c1 = floor(ucode / 0x1000)
				ucode = ucode - c1 * 0x1000
				c2 = floor(ucode / 0x40)
				c3 = ucode - c2 * 0x40
				c1 = c1 + 0xE0
				c2 = c2 + 0x80
				c3 = c3 + 0x80
				if rest then return char(c1, c2, c3, rest) end
				return char(c1, c2, c3)
			elseif 0xD800 <= ucode and ucode < 0xDC00 then --[[surrogate pair 1st]]
				if f_str_surrogate_prev == 0 then
					f_str_surrogate_prev = ucode
					if not rest then return "" end
					surrogate_first_error()
				end
				f_str_surrogate_prev = 0
				surrogate_first_error()
			else --[[surrogate pair 2nd]]
				if f_str_surrogate_prev ~= 0 then
					ucode = 0x10000 + (f_str_surrogate_prev - 0xD800) * 0x400 + (ucode - 0xDC00)
					f_str_surrogate_prev = 0
					c1 = floor(ucode / 0x40000)
					ucode = ucode - c1 * 0x40000
					c2 = floor(ucode / 0x1000)
					ucode = ucode - c2 * 0x1000
					c3 = floor(ucode / 0x40)
					c4 = ucode - c3 * 0x40
					c1 = c1 + 0xF0
					c2 = c2 + 0x80
					c3 = c3 + 0x80
					c4 = c4 + 0x80
					if rest then return char(c1, c2, c3, c4, rest) end
					return char(c1, c2, c3, c4)
				end
				decode_error("2nd surrogate pair byte appeared without 1st")
			end
		end
		decode_error("invalid unicode codepoint literal")
	end
	if f_str_surrogate_prev ~= 0 then f_str_surrogate_prev = 0; surrogate_first_error() end
	return f_str_escapetbl[ch] .. ucode
end

-- caching interpreted keys for speed
local f_str_keycache = setmetatable({}, {__mode="v"})

local f_str = function (iskey)
	local newpos = pos
	local tmppos, c1, c2
	repeat
		newpos = find(json, "\"", newpos, true) --[[search "\""]]
		if not newpos then decode_error("unterminated string") end
		tmppos = newpos-1
		newpos = newpos+1
		c1, c2 = byte(json, tmppos-1, tmppos)
		if c2 == 0x5c and c1 == 0x5c then --[[skip preceding "\\"s]]
			repeat
				tmppos = tmppos-2
				c1, c2 = byte(json, tmppos-1, tmppos)
			until c2 ~= 0x5c or c1 ~= 0x5c
			tmppos = newpos-2
		end
	until c2 ~= 0x5c --[[leave if "\"" is not preceded by "\\""]]
	local str = sub(json, pos, tmppos)
	pos = newpos
	if iskey then --[[check key cache]]
		tmppos = f_str_keycache[str] --[[reuse tmppos for cache key/val]]
		if tmppos then return tmppos end
		tmppos = str
	end
	if find(str, f_str_ctrl_pat) then decode_error("unescaped control string") end
	if find(str, "\\", 1, true) then  --[[check whether a backslash exists]]
		--[[We need to grab 4 characters after the escape char, for encoding unicode codepoint to UTF-8.]]
		--[[As we need to ensure that every first surrogate pair byte is immediately followed by second one,]]
		--[[we grab upto 5 characters and check the last for this purpose.]]
		str = gsub(str, "\\(.)([^\\]?[^\\]?[^\\]?[^\\]?[^\\]?)", f_str_subst)
		if f_str_surrogate_prev ~= 0 then
			f_str_surrogate_prev = 0
			decode_error("1st surrogate pair byte not continued by 2nd")
		end
	end
	--[[commit key cache]]
	if iskey then f_str_keycache[tmppos] = str end
	return str
end

--[[array]]
local f_ary = function ()
	rec_depth = rec_depth + 1
	if rec_depth > 1000 then decode_error("too deeply nested json (> 1000)") end
	local ary = {}
	pos = match(json, "^[ \n\r\t]*()", pos)
	local i2 = 0
	--[[check closing bracket "]" which means the array empty]]
	if byte(json, pos) == 0x5D then pos = pos + 1 else
		local newpos = pos
		repeat
			i2 = i2 + 1
			f = dec_dispatcher[byte(json,newpos)]  -- parse value
			pos = newpos + 1
			ary[i2] = f()
			newpos = match(json, "^[ \n\r\t]*,[ \n\r\t]*()", pos)  -- check comma
		until not newpos
		newpos = match(json, "^[ \n\r\t]*%]()", pos)  -- check closing bracket
		if not newpos then decode_error("no closing bracket of an array") end
		pos = newpos
	end
	--[[commit the length of the array if `arraylen` is set]]
	if arraylen then ary[0] = i2 end
	rec_depth = rec_depth - 1
	return ary
end

-- objects
local f_obj = function ()
	rec_depth = rec_depth + 1
	if rec_depth > 1000 then decode_error("too deeply nested json (> 1000)") end
	local obj = {}
	pos = match(json, "^[ \n\r\t]*()", pos)
	--[[check closing bracket "}" which means the object empty]]
	if byte(json, pos) == 0x7D then pos = pos + 1
	else
		local newpos = pos
		repeat
			if byte(json, newpos) ~= 0x22 then --[[check "\""]]
				decode_error("not key")
			end
			pos = newpos + 1
			local key = f_str(true) --[[parse key]]
			--[[optimized for compact json]]
			--[[c1, c2 == ":", <the first char of the value> or]]
			--[[c1, c2, c3 == ":", " ", <the first char of the value>]]
			f = f_err
			local c1, c2, c3 = byte(json, pos, pos+3)
			if c1 == 0x3A then
				if c2 ~= 0x20 then f = dec_dispatcher[c2]; newpos = pos + 2
				else f = dec_dispatcher[c3]; newpos = pos + 3 end
			end
			if f == f_err then  --[[read a colon and arbitrary number of spaces]]
				newpos = match(json, "^[ \n\r\t]*:[ \n\r\t]*()", pos)
				if not newpos then decode_error("no colon after a key") end
				f = dec_dispatcher[byte(json, newpos)]
				newpos = newpos+1
			end
			pos = newpos
			obj[key] = f()  -- parse value
			newpos = match(json, "^[ \n\r\t]*,[ \n\r\t]*()", pos)
		until not newpos
		newpos = match(json, "^[ \n\r\t]*}()", pos)
		if not newpos then decode_error("no closing bracket of an object") end
		pos = newpos
	end
	rec_depth = rec_depth - 1
	return obj
end

dec_dispatcher = setmetatable({ [0] =
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_str, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_mns, f_err, f_err,
	f_zro, f_num, f_num, f_num, f_num, f_num, f_num, f_num,
	f_num, f_num, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_ary, f_err, f_err, f_err, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_fls, f_err,
	f_err, f_err, f_err, f_err, f_err, f_err, f_nul, f_err,
	f_err, f_err, f_err, f_err, f_tru, f_err, f_err, f_err,
	f_err, f_err, f_err, f_obj, f_err, f_err, f_err, f_err,
}, { __index = function()
		decode_error("unexpected termination")
	end
})

--[[@return unknown v2, integer? pos]]
--[[@param json_ string]] --[[@param pos_ integer?]] --[[@param nullv_ unknown?]] --[[@param arraylen_ integer?]]
mod.decode = function (json_, pos_, nullv_, arraylen_)
	json, pos, dec_nullv, arraylen = json_, pos_, nullv_ or mod.null, arraylen_
	rec_depth = 0
	pos = match(json, "^[ \n\r\t]*()", pos)
	f = dec_dispatcher[byte(json, pos)]
	pos = pos+1
	local v2 = f()
	if pos_ then return v2, pos
	else
		f, pos = find(json, "^[ \n\r\t]*", pos)
		if pos ~= #json then decode_error("json ended") end
		return v2
	end
end
mod.json_to_value = mod.decode

return mod

local ffi = require("ffi")

local band = bit.band
local sub = string.sub; local byte = string.byte; local char = string.char; local format = string.format
local match = string.match; local lower = string.lower

local ASCII_0 = 48; local ASCII_9 = 57
local ASCII_a = 97; local ASCII_f = 102; local ASCII_z = 122
local ASCII_A = 65; local ASCII_Z = 90

local END_OF_STREAM = -1

local ReservedKeyword = {
	["and"] = 1, ["break"] = 2, ["do"] = 3, ["else"] = 4, ["elseif"] = 5, ["end"] = 6, ["false"] = 7, ["for"] = 8,
	["function"] = 9, ["goto"] = 10, ["if"] = 11, ["in"] = 12, ["local"] = 13, ["nil"] = 14, ["not"] = 15, ["or"] = 16,
	["repeat"] = 17, ["return"] = 18, ["then"] = 19, ["true"] = 20, ["until"] = 21, ["while"] = 22
}

local uint64 = ffi.typeof("uint64_t")
local int64 = ffi.typeof("int64_t")
local complex = ffi.typeof("complex")

local TokenSymbol = { TK_ge = ">=", TK_le = "<=" , TK_concat = "..", TK_eq = "==", TK_ne = "~=", TK_eof = "<eof>" }

local token2str = function (tok)
	if match(tok, "^TK_") then return TokenSymbol[tok] or sub(tok, 4)
	else return tok end
end

local error_lex = function (chunkname, tok, line, em, ...)
	local emfmt = format(em, ...)
	local msg = format("%s:%d: %s", chunkname, line, emfmt)
	if tok then
		msg = format("%s near '%s'", msg, tok)
	end
	error("LLT-ERROR" .. msg, 0)
end

local lex_error = function (ls, token, em, ...)
	local tok
	if token == "TK_name" or token == "TK_string" or token == "TK_number" then
		tok = ls.save_buf
	elseif token then
		tok = token2str(token)
	end
	error_lex(ls.chunkname, tok, ls.linenumber, em, ...)
end

local char_isident = function (c)
	if type(c) == "string" then
		local b = byte(c)
		if b >= ASCII_0 and b <= ASCII_9 then
			return true
		elseif b >= ASCII_a and b <= ASCII_z then
			return true
		elseif b >= ASCII_A and b <= ASCII_Z then
			return true
		else
			return (c == "_")
		end
	end
	return false
end

local char_isdigit = function (c)
	if type(c) == "string" then
		local b = byte(c)
		return b >= ASCII_0 and b <= ASCII_9
	end
	return false
end

local char_isspace = function (c)
	local b = byte(c)
	return b >= 9 and b <= 13 or b == 32
end

local byte_ours = function (ls, n)
	local k = ls.p + n
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	return sub(ls.data, k, k)
end

local skip = function (ls, n)
	ls.n = ls.n - n
	ls.p = ls.p + n
end

local pop = function (ls)
	local k = ls.p
	local c = sub(ls.data, k, k)
	ls.p = k + 1
	ls.n = ls.n - 1
	return c
end

local fillbuf = function (ls)
	local data = ls:read_func()
	if not data then
		return END_OF_STREAM
	end
	ls.data, ls.n, ls.p = data, #data, 1
	return pop(ls)
end

local nextchar = function (ls)
	local c = ls.n > 0 and pop(ls) or fillbuf(ls)
	ls.current = c
	return c
end

local curr_is_newline = function (ls)
	local c = ls.current
	return (c == "\n" or c == "\r")
end

local resetbuf = function (ls)
	ls.save_buf = ""
end

local resetbuf_tospace = function (ls)
	ls.space_buf = ls.space_buf .. ls.save_buf
	ls.save_buf = ""
end

local spaceadd = function (ls, str) ls.space_buf = ls.space_buf .. str end
local save = function (ls, c) ls.save_buf = ls.save_buf .. c end
local savespace_and_next = function (ls) ls.space_buf = ls.space_buf .. ls.current; nextchar(ls) end
local save_and_next = function (ls) ls.save_buf = ls.save_buf .. ls.current; nextchar(ls) end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
local get_string = function (ls, init_skip, end_skip) return sub(ls.save_buf, init_skip + 1, - (end_skip + 1)) end
local get_space_string = function (ls) local s = ls.space_buf; ls.space_buf = ""; return s end

local inclinenumber = function (ls)
	local old = ls.current
	savespace_and_next(ls) --[[skip `\n` or `\r`]]
	--[[skip `\n\r` or `\r\n`]]
	if curr_is_newline(ls) and ls.current ~= old then savespace_and_next(ls) end
	ls.linenumber = ls.linenumber + 1
end

local skip_sep = function (ls)
	local count = 0
	local s = ls.current
	assert(s == "[" or s == "]")
	save_and_next(ls)
	while ls.current == "=" do save_and_next(ls); count = count + 1 end
	return ls.current == s and count or (-count - 1)
end

local build_64int = function (str)
	local u = str[#str - 2]
	local x = (u == 117 and uint64(0) or int64(0))
	local i = 1
	--[[@diagnostic disable-next-line: cast-local-type]]
	while str[i] >= ASCII_0 and str[i] <= ASCII_9 do x = 10 * x + (str[i] - ASCII_0); i = i + 1 end
	return x
end

--[[only lower case letters are accepted]]
local byte_to_hexdigit = function (b)
	if b >= ASCII_0 and b <= ASCII_9 then return b - ASCII_0
	elseif b >= ASCII_a and b <= ASCII_f then return 10 + (b - ASCII_a)
	else return -1 end
end

local build_64hex = function (str)
	local u = str[#str - 2]
	local x = (u == 117 and uint64(0) or int64(0))
	local i = 3
	while str[i] do
		local n = byte_to_hexdigit(str[i])
		if n < 0 then break end
		--[[@diagnostic disable-next-line: cast-local-type]]
		x = 16 * x + n
		i = i + 1
	end
	return x
end

local strnumdump = function (str)
	local t = {}
	for i = 1, #str do
		local c = sub(str, i, i)
		if char_isident(c) then t[i] = byte(c)
		else return nil end
	end
	return t
end

local lex_number = function (ls)
	local xp = "e"
	local c = ls.current
	if c == "0" then
		save_and_next(ls)
		local xc = ls.current
		if xc == "x" or xc == "X" then xp = "p" end
	end
	while char_isident(ls.current) or ls.current == "." or
		((ls.current == "-" or ls.current == "+") and lower(c) == xp) do
		c = lower(ls.current)
		save(ls, c)
		nextchar(ls)
	end
	local str = ls.save_buf
	local x
	if sub(str, -1, -1) == "i" then
		local img = tonumber(sub(str, 1, -2))
		if img then x = complex(0, img) end
	elseif sub(str, -2, -1) == "ll" then
		local t = strnumdump(str)
		if t then x = xp == "e" and build_64int(t) or build_64hex(t) end
	else
		x = tonumber(str)
	end
	if x then return x
	else lex_error(ls, "TK_number", "malformed number") end
end

local read_long_string = function (ls, sep, ret_value)
	save_and_next(ls) --[[skip 2nd `[`]]
	--[[if string starts with a newline then skip newline]]
	if curr_is_newline(ls) then inclinenumber(ls) end
	while true do
		local c = ls.current
		if c == END_OF_STREAM then
			lex_error(ls, "TK_eof", ret_value and "unfinished long string" or "unfinished long comment")
		elseif c == "]" then
			--[[skip 2nd `[`]]
			if skip_sep(ls) == sep then save_and_next(ls); break end
		elseif c == "\n" or c == "\r" then
			save(ls, "\n")
			inclinenumber(ls)
			--[[avoid wasting space]]
			if not ret_value then resetbuf(ls) end
		elseif ret_value then save_and_next(ls)
		else nextchar(ls) end
	end
	if ret_value then
		return get_string(ls, 2 + sep, 2 + sep)
	end
end

local Escapes = { a = "\a", b = "\b", f = "\f", n = "\n", r = "\r", t = "\t", v = "\v" }

local hex_char = function (c)
	if not match(c, "^%x") then return end
	local b = band(byte(c), 15)
	if not char_isdigit(c) then b = b + 9 end
	return b
end

local read_escape_char = function (ls)
	local c = nextchar(ls) --[[Skip the `\\`.]]
	local esc = Escapes[c]
	if esc then save(ls, esc); nextchar(ls)
	elseif c == "x" then --[[Hexadecimal escape `\xXX`.]]
		local ch1 = hex_char(nextchar(ls))
		local hc
		if ch1 then
			local ch2 = hex_char(nextchar(ls))
			if ch2 then hc = char(ch1 * 16 + ch2) end
		end
		if not hc then lex_error(ls, "TK_string", "invalid escape sequence") end
		save(ls, hc)
		nextchar(ls)
	elseif c == "z" then --[[Skip whitespace.]]
		nextchar(ls)
		while char_isspace(ls.current) do
			if curr_is_newline(ls) then inclinenumber(ls) else nextchar(ls) end
		end
	elseif c == "\n" or c == "\r" then
		save(ls, "\n")
		inclinenumber(ls)
	elseif c == "\\" or c == "\"" or c == "'" then
		save(ls, c)
		nextchar(ls)
	elseif c == END_OF_STREAM then
	else
		if not char_isdigit(c) then lex_error(ls, "TK_string", "invalid escape sequence") end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		local bc = band(byte(c), 15) --[[Decimal escape `\ddd`.]]
		if char_isdigit(nextchar(ls)) then
			bc = bc * 10 + band(byte(ls.current), 15)
			if char_isdigit(nextchar(ls)) then
				bc = bc * 10 + band(byte(ls.current), 15)
				if bc > 255 then lex_error(ls, "TK_string", "invalid escape sequence") end
				nextchar(ls)
			end
		end
		save(ls, char(bc))
	end
end

local read_string = function (ls, delim)
	save_and_next(ls)
	while ls.current ~= delim do
		local c = ls.current
		if c == END_OF_STREAM then lex_error(ls, "TK_eof", "unfinished string")
		elseif c == "\n" or c == "\r" then lex_error(ls, "TK_string", "unfinished string")
		elseif c == "\\" then read_escape_char(ls)
		else save_and_next(ls) end
	end
	save_and_next(ls) --[[skip delimiter]]
	return get_string(ls, 1, 1)
end

local skip_line = function (ls)
	while not curr_is_newline(ls) and ls.current ~= END_OF_STREAM do
		savespace_and_next(ls)
	end
end

local llex = function (ls)
	resetbuf(ls)
	while true do
		local current = ls.current
		if char_isident(current) then
			--[[numeric literal]]
			if char_isdigit(current) then return "TK_number", lex_number(ls) end
			repeat
				save_and_next(ls)
			until not char_isident(ls.current)
			local s = get_string(ls, 0, 0)
			local reserved = ReservedKeyword[s]
			if reserved then return "TK_" .. s
			else return "TK_name", s end
		end
		if current == "\n" or current == "\r" then inclinenumber(ls)
		elseif current == " " or current == "\t" or current == "\b" or current == "\f" then savespace_and_next(ls)
		elseif current == "-" then
			nextchar(ls)
			if ls.current ~= "-" then return "-" end
			--[[else is a comment]]
			nextchar(ls)
			spaceadd(ls, "--")
			if ls.current == "[" then
				local sep = skip_sep(ls)
				resetbuf_tospace(ls) --[[`skip_sep` may dirty the buffer]]
				if sep >= 0 then
					read_long_string(ls, sep, false) --[[long comment]]
					resetbuf_tospace(ls)
				else skip_line(ls) end
			else skip_line(ls) end
		elseif current == "[" then
			local sep = skip_sep(ls)
			if sep >= 0 then
				local str = read_long_string(ls, sep, true)
				return "TK_string", str
			elseif sep == -1 then return "["
			else lex_error(ls, "TK_string", "delimiter error") 			end
		elseif current == "=" then
			nextchar(ls)
			if ls.current ~= "=" then return "=" else nextchar(ls); return "TK_eq" end
		elseif current == "<" then
			nextchar(ls)
			if ls.current ~= "=" then return "<" else nextchar(ls); return "TK_le" end
		elseif current == ">" then
			nextchar(ls)
			if ls.current ~= "=" then return ">" else nextchar(ls); return "TK_ge" end
		elseif current == "~" then
			nextchar(ls)
			if ls.current ~= "=" then return "~" else nextchar(ls); return "TK_ne" end
		elseif current == ":" then
			nextchar(ls)
			if ls.current ~= ":" then return ":" else nextchar(ls); return "TK_label" end
		elseif current == "\"" or current == "'" then
			local str = read_string(ls, current)
			return "TK_string", str
		elseif current == "." then
			save_and_next(ls)
			if ls.current == "." then
				nextchar(ls)
				if ls.current == "." then nextchar(ls); return "TK_dots" end --[[...]]
				return "TK_concat" --[[..]]
			elseif not char_isdigit(ls.current) then return "."
			else return "TK_number", lex_number(ls) end
		elseif current == END_OF_STREAM then return "TK_eof"
		else nextchar(ls); return current end --[[single-char tokens (+ - / ...).]]
	end
end

local Lexer = {
	token2str = token2str,
	error = lex_error,
}

Lexer.next = function (ls)
	ls.lastline = ls.linenumber
	if ls.tklookahead == "TK_eof" then --[[no lookahead token?]]
		ls.token, ls.tokenval = llex(ls) --[[get nextchar token]]
		ls.space = get_space_string(ls)
	else
		ls.token, ls.tokenval = ls.tklookahead, ls.tklookaheadval
		ls.space = ls.spaceahead
		ls.tklookahead = "TK_eof"
	end
end

Lexer.lookahead = function (ls)
	assert(ls.tklookahead == "TK_eof")
	ls.tklookahead, ls.tklookaheadval = llex(ls)
	ls.spaceahead = get_space_string(ls)
	return ls.tklookahead
end

local LexerClass = { __index = Lexer }

--[[@param read_func fun(): string]] --[[@param chunkname string]]
local lex_setup = function (read_func, chunkname)
	local ls = {
		n = 0,
		tklookahead = "TK_eof", --[[No look-ahead token.]]
		linenumber = 1,
		lastline = 1,
		read_func = read_func,
		chunkname = chunkname,
		space_buf = ""
	}
	nextchar(ls)
	if ls.current == "\xef" and ls.n >= 2 and
		byte_ours(ls, 0) == "\xbb" and byte_ours(ls, 1) == "\xbf" then --[[Skip UTF-8 BOM (if buffered).]]
		ls.n = ls.n - 2
		ls.p = ls.p + 2
		nextchar(ls)
	end
	if ls.current == "#" then
		repeat
			nextchar(ls)
			if ls.current == END_OF_STREAM then return ls end
		until curr_is_newline(ls)
		inclinenumber(ls)
	end
	return setmetatable(ls, LexerClass)
end

return lex_setup

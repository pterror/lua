--[[https://datatracker.ietf.org/doc/rfc9051/]]
--[[https://www.mailenable.com/kb/content/article.asp?ID=ME020711]]
--[[Client and server implementations MUST implement the capabilities
"AUTH=PLAIN" (described in [PLAIN]), and MUST implement "STARTTLS"
and "LOGINDISABLED" on the cleartext port.]]


local maxint = 9007199254740991

local mod = {}

local ffi

--[[@param s string]]
--[[@param i? integer]]
mod.read_quoted = function(s, i)
	i = i or 1
	if s:byte(i) ~= 0x22 --[["]] then return nil, "imap: quoted string is missing starting quote" end
	local parts = {} --[[@type string[] ]]
	i = i + 1
	local c = s:byte(i)
	while c ~= 0x22 --[["]] do
		--[[does not validate that the character after \ is a quoted-special]]
		if c == 0x5c --[[\]] then
			i = i + 2
			parts[#parts + 1] = string.char(s:byte(i - 1))
		else
			--[[does not validate that the non-ascii sequences are utf8]]
			local match = s:match("[^\"\\\\]", i)
			parts[#parts + 1] = match
			i = i + #match
		end
		if i > #s then break end
		c = s:byte(i)
	end
	if c ~= 0x22 then return nil, "imap: quoted string is missing ending quote" end
	return table.concat(parts), i + 1
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_literal = function(s, i)
	i = i or 1
	local _, end_, length_raw = s:find("{(%d+)+?}", i)
	if not end_ then return nil, "imap: literal string is missing length" end
	i = end_ + 1
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	local length = tonumber(length_raw) --[[@type integer]]
	if length > maxint then
		if not ffi then
			ffi = require("ffi")
			ffi.cdef [[ long long atoll(const char *str); ]]
		end
		length = ffi.C.atoll(length_raw) --[[@type long_long_c]]
	end
	return s:sub(i, i + length - 1), i + length
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_string = function(s, i)
	i = i or 1
	local c = s:byte(i)
	if c == 0x22 --[["]] then
		return mod.read_quoted(s, i)
	elseif c == 0x7b --[[{]] then
		return mod.read_literal(s, i)
	else
		return nil, "imap: invalid start of string: " .. s:sub(i, i)
	end
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_astring = function(s, i)
	i = i or 1
	local ret = s:match("[^%z- \x7f(){%*\"\\\\]+", i)
	if ret then return ret, i + #ret end
	return mod.read_string(s, i)
end

--[[a placeholder representing imap's `nil`]]
--[[@class imap_nil]]
--[[@type imap_nil]]
mod.nil_ = {}

--[[@param s string]]
--[[@param i? integer]]
mod.read_string_or_nil = function(s, i)
	i = i or 1
	local c = s:byte(i)
	if c == 0x22 --[["]] then
		return mod.read_quoted(s, i)
	elseif c == 0x7b --[[{]] then
		return mod.read_literal(s, i)
	elseif s:find("[Nn][Ii][Ll]", i) then
		return mod.nil_, i + 3
	else
		return nil, "imap: invalid start of string: " .. s:sub(i, i)
	end
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_date_time = function(s, i)
	i = i or 1
	--[[@type integer?, integer?, string, string, string, string, string, string, string, string, string]]
	local _, end_, day, month, year, hour, minute, second, zone_sign, zone_hour, zone_minute = s:find(
		"\"([ %d]%d)-([a-z][a-z][a-z])-(%d%d%d%d) (%d%d):(%d%d):(%d%d) ([+-])(%d%d)(%d%d)\"")
	if not end_ then return nil, "imap: date_time: invalid" end
	local ret = { --[[@class imap_date_time]]
		day = day, month = month, hour = hour, minute = minute, second = second, zone = { sign = zone_sign, hour = zone_hour, minute = zone_minute }
	}
	return ret, end_ + 1
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_flag = function(s, i)
	i = i or 1
	--[[flags: \Answered | \Flagged | \Deleted | \Seen | \Draft]]
	--[[flag-keywords: $MDNSent | $Forwarded | $Junk | $NotJunk | $Phishing]]
	local match = s:match("[\\$]?[^%z- \x7f(){%*\"\\\\]+", i) --[[@type imap_flag?]]
	if not match then return nil, "imap: invalid start of flag: " .. s:sub(i, i) end
	return match, i + #match
end

--[[@param s string]]
--[[@param i? integer]]
mod.read_capability = function(s, i)
	i = i or 1
	local match = s:match("[Aa][Uu][Tt][Hh]=[^%z- \x7f(){%*\"\\\\]+", i) --[[@type imap_capability?]]
	if not match then match = s:match("[^%z- \x7f(){%*\"\\\\]+", i) --[[@type imap_capability?]] end
	if not match then return nil, "imap: expected capability, found \"" .. s:sub(i, i) .. "\"" end
	return match, i + #match
end

local noop_command_reader = function() return {} end

--[[@param s string]]
--[[@param i integer]]
local mailbox_command_reader = function(s, i)
	local mailbox
	--[[@diagnostic disable-next-line: cast-local-type]]
	mailbox, i = mod.read_astring(s, i)
	if not mailbox then return nil, "imap: error reading mailbox:\n" .. i end
	return { mailbox = mailbox }, i
end

--[[@type table<imap_command_type, fun(s: string, i: integer): table?, integer|string>]]
mod.command_readers = {}
mod.command_readers.capability = noop_command_reader
mod.command_readers.logout = noop_command_reader
mod.command_readers.noop = noop_command_reader
mod.command_readers.append = function(s, i)
	local mailbox
	--[[@diagnostic disable: param-type-mismatch]]
	mailbox, i = mod.read_astring(s, i)
	if not mailbox then return nil, "imap: append: error reading mailbox:\n" .. i end
	if s:byte(i) ~= 0x20 --[[ ]] then return nil, "imap: append: missing space after mailbox" end
	i = i + 1
	local flags = {} --[[@type imap_flag[] ]]
	if s:byte(i) == 0x28 --[[(]] then
		while true do
			local flag
			flag, i = mod.read_flag(s, i)
			if not flag then break end
			if s:byte(i) ~= 0x20 then break end
			i = i + 1
			flags[#flags + 1] = flag
		end
		if s:byte(i) ~= 0x29 --[[)]] then return nil, "imap: append: missing `)` after flags" end
	end
	local date_time, i2 = mod.read_date_time(s, i)
	if date_time then i = i2 end
	--[[try time = mod.read_date_time]]
	local message
	message, i = mod.read_literal(s, i)
	--[[@diagnostic enable: param-type-mismatch]]
	return { mailbox = mailbox, flags = flags, date_time = date_time, message = message }, i
end
--[[use of "inbox" should give a NO error]]
mod.command_readers.create = mailbox_command_reader
--[[use of "inbox" should give a NO error]]
mod.command_readers.delete = mailbox_command_reader
mod.command_readers.enable = function(s, i)
	local capabilities = {} --[[@type imap_capability[] ]]
	while s:byte(i) == 0x20 do
		i = i + 1
		local capability
		--[[@type imap_capability, integer]]
		capability, i = mod.read_capability(s, i)
		if not capability then break end
		capabilities[#capabilities + 1] = capability
	end
	--[[@diagnostic enable: param-type-mismatch]]
	return { capabilities = capabilities }, i
end
mod.command_readers.starttls = noop_command_reader
mod.command_readers.close = noop_command_reader
mod.command_readers.unselect = noop_command_reader
mod.command_readers.expunge = noop_command_reader

--[[@param s string]]
--[[@param i? integer]]
mod.read_command = function(s, i)
	i = i or 1
	--[[@type integer?, integer?, string, string]]
	local _, end_, tag, type = s:find("([^%z- \x7f(){%*\"\\\\+]+) (%S+) ?")
	if not end_ then return nil, "imap: command missing tag or command name" end
	type = type:lower()
	local reader = mod.command_readers[type]
	if not reader then return nil, "imap: unknown command type " .. type end
	local ret
	--[[@diagnostic disable-next-line: cast-local-type]]
	ret, i = reader(s, i) --[[@type imap_any_command?]]
	ret.tag = tag
	ret.type = type
	if not ret then return nil, "imap: command: " .. i end
	return ret, i + 1
end

mod.string_to_imap_command = mod.read_command

return mod

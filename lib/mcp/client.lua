-- https://www.moo.mud.org/mcp/mcp2.html
local mod = {}

-- TODO: need to create a mcp instance
-- TODO: sending messages, configuring which fields must be multiline regardless of newline presence,
-- support for mcp 1.0 (both understanding and sending)
-- FIXME: can't work since 
-- TODO: it should wrap write...
--- @return fun(s: string) cb, fun (write: fun (s: string)): fun (s: string) init
--- @param cb fun(s: string) callback
--- @param mcp_cb fun(type: string, value: {}) callback for mcp messages
mod.wrap = function (cb, mcp_cb)
	local authentication_key = nil
	--- @type table<string, table<string, unknown>>
	local multiline_messages = {}
	--- @param s string
	return function (s)
		-- TODO: consider switching to find() for speeeed
		for line in s:gmatch("[\n]+") do
			if line:sub(1, 3) == "#$\"" then
				cb(line:sub(4) .. "\n")
			elseif line:sub(1, 3) == "#$#" then
				-- TODO
				if line:sub(4, 4) == "*" then
					local tag, key, line_ = line:match("#$#* +(.-) +(.-): (.+)")
					if tag then
						local lines = (multiline_messages[tag] or {})[key]
						if lines then lines[#lines+1] = line_ end
					end
				elseif line:sub(4, 4) == ":" then
					local key = line:match("#$#: (.+)")
					if key then
						local msg = multiline_messages[key]
						mcp_cb(msg.type, msg.value)
						multiline_messages[key] = nil
					end
				else
					local type, auth_key, key_vals = line:match("#$#(.-) [a-zA-Z0-9-~`!@#$%^&()=+{}%[%]|';?/><.,]+")
				end
			else
				cb(line .. "\n")
			end
		end
	end, function (write)
		-- FIXME: this function is not accessible since this wraps the callback not the server...
		return function(s) if s:sub(1, 3) == "#$#" then write("#$\"" .. s) else write(s) end end
	end --- FIXME: also return function write_message() end
end

-- 0xFF 0xFB 0xC9

return mod

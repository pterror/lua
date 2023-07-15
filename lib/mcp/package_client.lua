local base = require("lib.mcp.client")

local mod = {}

--[[@class mcp]]
--[[@field packages table<string, mcp_package>]]
--[[@field message_handlers table<string, mcp_message_handler>]]
--[[@alias mcp_message_handler fun (self_: mcp, message: {})]]
--[[@class mcp_package]]
--[[@field name string? defaults to `""`]]
--[[@field version integer[]? defaults to `{ 1, 0 }`]]
--[[@field min_version integer[]? defaults to `version`]]
--[[@field max_version integer[]? defaults to `version`]]
--[[@field message_handlers table<string, mcp_message_handler>? defaults to `{}`]]
--[[@field init fun (self_: mcp)? defaults to `nil`]]

-- TODO: need to create a mcp instance
-- TODO: sending messages, configuring which fields must be multiline regardless of newline presence,
-- support for mcp 1.0 (both understanding and sending)
-- FIXME: can't work since 
-- TODO: it should wrap write...
--[[@return fun(s: string) cb, fun (write: fun (s: string)): fun (s: string) init]]
--[[@param cb fun(s: string) callback]]
--[[@param packages mcp_package[]?]]
mod.wrap = function (cb, packages)
	packages = packages or {}
	--[[@type mcp]]
	local self = {
		packages = packages,
		message_handlers = {},
	}
	for i = 1, #packages do
		for k, h in pairs(packages[i].message_handlers or {}) do
			self.message_handlers[k] = h
		end
	end
	-- must be in a separate loop because `self` must be filled in before `init` is called
	for i = 1, #packages do
		local init = packages[i].init
		if init then init(self) end
	end
	return base.wrap(cb, function (type, value)
		local fn = self.message_handlers[type]
		if fn then fn(self, value) end
	end)
end

-- 0xFF 0xFB 0xC9

return mod

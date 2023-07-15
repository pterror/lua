--[[@type mcp_package]]
local mod = {}

mod.name = "dns-mud-moo-org-simpleedit"
mod.version = { 1, 0 }
mod.min_version = { 1, 0 }
mod.max_version = { 1, 0 }

mod.message_handlers = {}

-- server -> client
-- note that content *must* be multiline
mod.message_handlers["dns-org-mud-moo-simpleedit-content"] = function (self)
	-- FIXME
	local msg = { foo = "TODO" }
	self:send_message("dns-org-mud-moo-simpleedit-set", msg)
end

return mod

--[[@type mcp_package]]
local mod = {}

mod.name = "mcp-negotiate"
mod.version = { 2, 0 }
mod.min_version = { 1, 0 }
mod.max_version = { 2, 0 }

mod.messages = {}

mod.messages["mcp-negotiate-can"] = function (self_)
end

mod.messages["mcp-negotiate-end"] = function (self_)
end

mod.init = function (self_)
	for k, v in pairs(self_.packages) do end
end

return mod

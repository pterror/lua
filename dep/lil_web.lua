-- TODO: api parity with linux and windows. probably extract the window stuff out to another module

local mod = {}

-- TODO: rename, refactor out
--[[@class lil_element]]

--[[@class lil_web_interface]]
local app = {}
mod.App = app
app.__index = app

function app:new()
	setmetatable({ --[[@class lil_web_interface]]
		--
	}, self)
end

--[[@generic t]]
--[[@class Trait<t>: { impls: table<{}, t> }]]

--[[@class Trait]]
local Trait = {}

--[[@generic t]]
function Trait:new()
	return setmetatable({ --[[@class Trait<t>]]
		impls = {}
	})
end

-- FIXME: class cannot be passed as it may not yet exist
-- or rather, it should be a no-op if either class or trait exist
--[[@generic t]]
--[[@param self Trait<t>]]
--[[@param impl t]]
function Trait:impl(class, impl)
	-- NOTE: when impl is (incorrectly) replaced with 1, there is no error
	self.impls[class] = impl
end

-- NOTE: when it's just Trait(), there is no error
local ToHtml = Trait:new()

-- TODO: mode = "k" table for trait impls instead of this.
-- so u dont get bloat for native
-- you will need to figure out a way to reference something that may not exist tho
--[[@param el lil_element]]
local to_html = function (el)
	if el.to_html then
		return el:to_html()
	else
		local parts = {}
		-- FIXME: children should not be exposed...
		for i, child in ipairs(el.children) do
			parts[i] = to_html(child)
		end
		return table.concat(parts)
	end
end
-- TODO: events. how.


--[[@param old lil_element]]
--[[@param new lil_element]]
function app:replace(old, new)
	-- TODO: tree diffing
end

return mod

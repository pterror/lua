local mod = {}

local write = io.write

--- @class cursor
local cursor = {}
mod.cursor = cursor
cursor.__index = cursor

cursor.new = function (self) return setmetatable({}, self) end

cursor.move = function (_, x, y) write("\x17[", y, ";", x, "H") end

--- @class element
local element = {}
mod.element = element
element.__index = element

element.new = function (self)
	return setmetatable({ --- @class element
		x = 0, y = 0, width = 0, height = 0,
		-- TODO: more sizing, these are just the final output variables
	}, self)
end

--- @param cursor cursor
element.render = function (self, cursor) error("element:render: not implemented") end

return mod

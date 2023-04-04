-- TODO: sandboxing
local cbor = require("dep.cbor")
--- @class text_world_object

--- @class world
--- @field objects text_world_object[]
--- @field object_to_index table<text_world_object, integer>
local world = {}
world.__index = world

-- TODO: new_object()

-- TODO: allow objects to be input - e.g. for world:load()
world.new = function (self)
	local value = {
		-- TODO: state, player, items etc
		objects = {},
		object_to_index = setmetatable({}, {
			__mode = "k"
		}),
	}
	for i = 1, #value.objects do
		value.object_to_index[value.objects[i]] = i
	end
	return setmetatable(value, self)
end

world.save = function (self)
	local object_to_index = {}
	for i, obj in ipairs(self.objects) do
		object_to_index[obj] = i
	end
	local buf = cbor.encode({
		-- TODO: everything else
		objects = self.objects,
	})
end

world.load = function (self, encoded)
	local obj = cbor.decode(encoded)
	-- TODO: rehydrate items
	return self:new()
end

--- @param command string
world.handle_command = function (self, command)
	-- TODO: this should probably be handled by some code that is changeable, but:
	-- - how would you figure out what code handles it initially
	-- - how would you swap out the code that handles it (per player, too)
end

-- TODO: permissions? not sure if that must be integrated into the game

return world

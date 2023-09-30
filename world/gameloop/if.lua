-- interactive fiction template
local mod = {}

--[[@type table<string, fun(...: string): string?, string?>]]
mod.commands = {}

--[[@type unknown[] ]]
mod.items = {}

--[[
	FIXME: this is wrong, the player should only be able to interact with items they can see -
	things in the current room, things in their inventory, stuff like that
]]
local items_by_name = setmetatable({}, { __mode = "v" })

--[[@param name_or_id string]]
local find = function (name_or_id)
	local item = items_by_name[name_or_id] or mod.items[tonumber(id)]
	if not item then print("umm whats a " .. name_or_id); end
	return item
end

mod.commands.look = function (obj_name_or_id)
	if obj_name_or_id == "" then
		--[[TODO: return the current room]]
	end
	--[[also handle other special keywords like "me" and "self"]]
	--[[it may be possible to avoid specialcasing depending on how the list of visible items is made]]
	local obj = find(obj_name_or_id)
	if not obj then return nil, "could not find object: " .. obj_name_or_id end
	if type(obj.describe) ~= "function" then return nil, "could not find object: " .. obj_name_or_id end
	return obj:describe()
end

local object = {
	type = "object",
	--[[@param obj table?]]
	new = function (self, obj)
		obj = obj or {}
		obj.__index = obj
		obj.parent = self
		mod.items[#mod.items+1] = obj
		setmetatable(obj, self)
		if obj.name then items_by_name[obj.name] = obj end
		return obj
	end,
	description = "an unknown object",
	describe = function (self) return self.description end,
}
object.__index = object
mod.items[#mod.items+1] = object

local room = object:new({ type = "room" })
local entity = object:new({ type = "entity" })
local player = entity:new({ type = "player" })
local player_1 = player:new()
local starting_room = room:new({
	name = "starting room!",
	description = "the starting room"
})

return mod

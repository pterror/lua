--[[IMPL]]
--[[TODO: consider custom types for email etc so that we can use functions from dep.mock]]

local mod = {}

--[[consider making exact checkers (disallowing extra properties)]]
--[[you wouldn't be able to do intersection types though]]

mod.mockers = {}

--[[@generic t]]
--[[@return t]]
--[[@param schema t]]
mod.mock = function (schema)
	--[[@diagnostic disable-next-line: undefined-field]]
	return mod.mockers[schema.type](schema)
end

mod.mockers.integer = function (_) return math.random(99) end
mod.mockers.number = function (_) return math.random() * 10000 end
mod.mockers.string = function (_) --[[TODO: this is yucky]]
	local chars = {}
	for i = 1, math.random(3, 16) do chars[i] = math.random(32, 127) end
	return string.char(unpack(chars))
end
mod.mockers.boolean = function (_) return math.random(0, 1) == 1 end
mod.mockers.tuple = function (s)
	local ret = {}
	for i, s2 in ipairs(s.shape) do ret[i] = mod.mock(s2) end
	return ret
end
mod.mockers.struct = function (s)
	local ret = {}
	for k, s2 in pairs(s.shape) do ret[k] = mod.mock(s2) end
	return ret
end
mod.mockers.array = function (s)
	local ret = {}
	local s_item = s.item
	for i = 1, math.random(0, 16) do ret[i] = mod.mock(s_item) end
	return ret
end
mod.mockers.dictionary = function (s)
	local ret = {}
	local s_key = s.key
	local s_value = s.value
	for _ = 1, math.random(0, 16) do ret[mod.mock(s_key)] = mod.mock(s_value) end
	return ret
end
mod.mockers.optional = function (s) if math.random(0, 1) == 1 then return nil else return mod.mock(s.inner) end end

return mod

local mod = {}

--[[consider making exact checkers (disallowing extra properties)]]
--[[you wouldn't be able to do intersection types though]]

mod.checkers = {}

--[[@return boolean]]
mod.check = function (schema, x)
	return mod.checkers[schema.type](schema, x)
end

--[[@return boolean]]
mod.checkers.integer = function (_, x) return type(x) == "number" and x % 0 == 0 end
--[[@return boolean]]
mod.checkers.number = function (_, x) return type(x) == "number" end
--[[@return boolean]]
mod.checkers.string = function (_, x) return type(x) == "string" end
--[[@return boolean]]
mod.checkers.boolean = function (_, x) return type(x) == "boolean" end
--[[@return boolean]]
mod.checkers["nil"] = function (_, x) return type(x) == "nil" end
--[[@return boolean]]
mod.checkers.literal = function (s, x)
	if type(s) ~= "table" or type(x) ~= "table" then return s == x end
	if s == x then return true end
	if #s ~= #x then return false end
	for k, v in pairs(s) do if not mod.checkers.literal(v, x[k]) then return false end end
	for k in pairs(x) do if s[k] == nil then return false end end
	return true
end
--[[@return boolean]]
mod.checkers.tuple = function (s, x)
	--[[checking if `x` is shorter is unsafe, since schemas may be optional]]
	if type(x) ~= "table" then return false end
	for i, s2 in ipairs(s.shape) do
		if not mod.check(s2, x[i]) then return false end
	end
	return true
end
--[[@return boolean]]
mod.checkers.struct = function (s, x)
	if type(x) ~= "table" then return false end
	for k, s2 in pairs(s.shape) do
		if not mod.check(s2, x[k]) then return false end
	end
	return true
end
--[[@return boolean]]
mod.checkers.struct_exact = function (s, x)
	if type(x) ~= "table" then return false end
	for k in pairs(x) do if not s.shape[x] then return false end end
	for k, s2 in pairs(s.shape) do
		if not mod.check(s2, x[k]) then return false end
	end
	return true
end
--[[@return boolean]]
mod.checkers.array = function (s, x)
	if type(x) ~= "table" then return false end
	local s_item = s.item
	for _, item in ipairs(x) do if not mod.check(s_item, item) then return false end end
	return true
end
--[[@return boolean]]
mod.checkers.dictionary = function (s, x)
	if type(x) ~= "table" then return false end
	local s_key = s.key
	local s_value = s.value
	for k, v in ipairs(x) do
		if not mod.check(s_key, k) or not mod.check(s_value, v) then return false end
	end
	return true
end
--[[@return boolean]]
mod.checkers.optional = function (s, x) return x == nil or mod.check(s.inner, x) end
--[[@return boolean]]
mod.checkers.any_of = function (s, x)
	for i = 1, #s.types do if mod.check(s[i], x) == true then return true end end
	return false
end
--[[@return boolean]]
mod.checkers.all_of = function (s, x)
	for i = 1, #s.types do if mod.check(s[i], x) == false then return false end end
	return true
end

return mod

--[[##
local tmod = {}
setmetatable(tmod, {
	__call = function (shape)
		-- TODO
	end,
})

-- TODO: type level unpack
local tmod = {}

local opaque
local opaque_is_parent = function (self, other)
	return other == self or other.kind == opaque and other.parent == self
end
-- TODO: opaque shouldnt be able to have parents
-- maybe consider co: type[] and contra: type[]
-- not for opaque of course
-- e.g.: array(t) <: array(u) == t <: u
-- function_string(f) <: function_string(g) == f <: g
-- 
opaque = function (parent)
	return { kind = opaque, parent = parent, is_parent = opaque_is_parent }
end
tmod.opaque = opaque
-- TODO: in most cases nil cannot be detected however it may be useful for optionals
local string, number, integer, nil_ = opaque(), opaque(), opaque(), opaque()
tmod.string, tmod.number, tmod.integer, tmod.nil_ = string, number, integer, nil_
-- TODO: should boolean be opaque or anyof(true_, false_)
-- TODO: object, array, anyof
local object
local object_is_parent = function (self, other)
	if other.kind ~= object then return false end
	for k, v in pairs(self.shape) do
		if not other.shape[k] then return end
	end
	for k, v in pairs(self.shape) do
		if not v:is_parent(other.shape[k]) then return end
	end
end
tmod.object = object
local fun
local fun_is_parent = function (self, other)
	if other.kind ~= fun or #self.inputs < #other.inputs or #self.outputs < #other.outputs then return false end
	for i = 1, #other.inputs do
		-- the child must accept all of self's params
		if not other.inputs[i]:is_parent(self.inputs[i]) then return false end
	end
	for i = 1, #other.outputs do
		if not self.outputs[i]:is_parent(other.outputs[i]) then return false end
	end
	return true
end
fun = function (inputs, outputs)
	return { kind = fun, inputs = inputs, outputs = outputs, is_parent = fun_is_parent }
end
tmod.fun = fun
local allof
local allof_is_parent = function (self, other)
	if other.kind == allof then
		for i = 1, #self.members do
			local found = false
			for j = 1, #other.members do
				if self.members[i]:is_parent(other.members[i]) then found = true; break end
			end
			if not found then return false end
		end
		return true
	end
	for i = 1, #self.members do
		if not self.members[i]:is_parent(other) then return false end
	end
	return true
end
allof = function (members)
	return { kind = allof, members = members, is_parent = allof_is_parent }
end
tmod.allof = allof
local overloads = allof
tmod.overloads = overloads

local function_string = function (fun)
	return type.opaque(string) -- TODO: somehow add the function typecheck in there:
	-- function_string(any) <: string
	-- function_string(f) <: function_string(g) == f <: g
end
tmod.function_string = function_string
local stripped_function_string = function (fun)
	return type.opaque(string) -- TODO: same as above
end
tmod.stripped_function_string = stripped_function_string

-- TODO: optimizations i guess...
print(fun({}, {}):is_parent(fun({ integer }, {}))) -- false
print(fun({ integer, integer }, { integer }):is_parent(fun({ integer }, {}))) -- true
print(fun({ string }, { }):is_parent(fun({ integer }, {}))) -- false
print(overloads(
	fun({ string }, { }),
	fun({ integer }, { })
):is_parent(fun({ integer }, {}))) -- true

return tmod
-- all exports in this module should be defined as prelude
]]
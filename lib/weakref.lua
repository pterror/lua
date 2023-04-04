local mod

--- @class weakref<t>: { value: t }

--- @generic t
--- @return weakref<t>
--- @param value t
function mod.weakref(value)
	return setmetatable({ value = value }, { __mode = "v" })
end

return mod

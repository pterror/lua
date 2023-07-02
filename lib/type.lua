local mod = {}

--[[@alias type_ {type:"integer"|"number"|"string"|"boolean"|"nil"}]]
--[[@alias type_type "integer"|"number"|"string"|"boolean"|"tuple"|"struct"|"struct_exact"|"array"|"dictionary"|"optional"]]

--[[@type integer]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.integer = { type = "integer" }
--[[@type number]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.number = { type = "number" }
--[[@type string]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.string = { type = "string" }
--[[@type boolean]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.boolean = { type = "boolean" }
--[[@type nil]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod["nil"] = { type = "nil" }
--[[@generic t]]
--[[@return t]]
--[[@param value t]]
mod.literal = function (value) return { type = "literal", value = value } end
--[[@generic t: unknown[] ]]
--[[@return t]]
--[[@param shape t]]
mod.tuple = function (shape) return { type = "tuple", shape = shape } end
--[[@generic t: {}]]
--[[@return t]]
--[[@param shape t]]
mod.struct = function (shape) return { type = "struct", shape = shape } end
--[[@generic t: {}]]
--[[@return t]]
--[[@param shape t]]
mod.struct_exact = function (shape) return { type = "struct_exact", shape = shape } end
--[[@generic t]]
--[[@return t[] ]]
--[[@param item t]]
mod.array = function (item) return { type = "array", item = item } end
--[[@generic k, v]]
--[[@return table<k, v>]]
--[[@param key k]]
--[[@param value v]]
mod.dictionary = function (key, value) return { type = "dictionary", key = key, value = value } end
--[[@generic t]]
--[[@return t?]]
--[[@param t t]]
mod.optional = function (t) return { type = "optional", inner = t } end
--[[@generic t, u, v, w, x, y, z, a, b]]
--[[@return t | u | v | w | x | y | z | a | b]]
--[[@param t t]]
--[[@param u? u]]
--[[@param v? v]]
--[[@param w? w]]
--[[@param x? x]]
--[[@param y? y]]
--[[@param z? z]]
--[[@param a? a]]
--[[@param ... b]]
mod.any_of = function (t, u, v, w, x, y, z, a, ...) return { type = "any_of", types = { t, u, v, w, x, y, z, a, ...} } end
--[[@generic t]]
--[[@return t]]
--[[@param t t]]
--[[@param ... unknown]]
--[[NOTE: this is not correct, however intersections are not supported]]
mod.all_of = function (t, ...) return { type = "all_of", types = { t, ... } } end

--[[@generic t]]
--[[@return t]]
--[[@param t t]]
--[[@diagnostic disable-next-line: undefined-field]]
local unwrap = function (t) return t.shape end
mod._unwrap_struct = unwrap
mod._unwrap_tuple = unwrap
mod._unwrap_struct_exact = unwrap

return mod

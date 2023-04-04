-- opaque should maybe be renamed?
-- plans:
-- - make it fast as hecc boi
-- - serializing inferred types may be a good idea
-- - dont sacrifice flexibility
--[[##
local string, number, integer = opaque(), opaque(), opaque()
meta(string_literal, string)
meta(number_literal, number)
-- NOTE: lua 5.1 doesn't have integers
-- but they are a useful distinction. and you can always do 1.0 for floats
meta(integer_literal, integer)
-- TODO: operators - binary, unary, call etc
-- TODO: aliasing - types are currently planned to be in a separate namespace
-- mostly because of the type string clashing with the value string
-- but it doesn't hurt to implement this
-- type u, n = anyof, allof
-- consider type-level functions
-- TODO: generics need to introduce new type vars...
-- ... this doesnt really make sense in any language

-- TODO: this should probably be memoized
-- notes:
-- - no clue how it should be memoized
--   - impl sounds ok but you probably lose out on inference
local function_string = function (params, returns) return opaque(string) end
local stripped_function_string = function (params, returns) return opaque(string) end

-- TODO: consider allowing restricting range of integers.
local stringlib = object({
	-- TODO: how to naming params and returns lol
	-- TODO: oh no oh frick cannot add docs
	byte = overloads(
		fun({ string }, anyof({}, { integer })),
		fun({ string, integer }, { unpack(array(integer)) }),
		fun({ string, integer, integer }, { unpack(array(integer)) }),
	),
	char = fun { unpack(array(integer)) } { string },
	-- TODO: constrain params to be ...T[] and returns to be ...U[]
	dump = function (params, returns) return overloads(
		fun({ fun(params, returns) }, { function_string(params, returns) }),
		fun({ fun(params, returns), true }, { function_string(params, returns) }),
		fun({ fun(params, returns), false }, { stripped_function_string(params, returns) }),
	) end,
	find = overloads(
		-- where the second integer >= first
		-- in this case it'd probably be a good idea to optional({ integer, boolean })
		fun({ string, string }, anyof({ nil_ }, { integer, integer })),
		fun({ string, string, integer }, anyof({ nil_ }, { integer, integer })),
		fun({ string, string, integer, boolean }, anyof({ nil_ }, { integer, integer })),
	),
	-- format = function (s)
	--   -- you could 
	--   return fun({ s }, { string })
	-- end,
	-- TODO: unknown, any, never
	-- TODO: parse format string
	format = fun({ string, unpacK(array(unknown)) }, { string }),
})
]]
--[[#stringlib]] string = string
string.find
local whiskr = require("world.whiskr")

local mod = {}

--[[@param root string]]
mod.api = function (root)
	local db = assert(whiskr.open(root))
	local routes = {
		list = function ()
			local facts = {} --[[@type unknown[] ]]
			for fact in db:list_facts() do facts[#facts+1] = fact end
			return facts
		end,
		--[[@param input {subject:string;predicate:string;object:string}]]
		add = function (input)
			if
				type(input) ~= "table" or type(input.subject) ~= "string" or
				type(input.predicate) ~= "string" or type(input.object) ~= "string"
			then
				return nil, "expected `{ subject: string; predicate: string; object: string; }`"
			end
			local success, err = db:add_fact(input)
			if not success then return nil, err end
			return true
		end,
		--[[@param input {subject:string;predicate:string;object:string}]]
		delete = function (input)
			if type(input) ~= "table" or type(input.subject) ~= "string" or type(input.predicate) ~= "string" or type(input.object) ~= "string" then
				return nil, "expected `{ subject: string; predicate: string; object: string; }`"
			end
			local rows_deleted, err = db:remove_fact(input)
			if not rows_deleted then return nil, err
			elseif rows_deleted == 0 then return nil, "fact not found" end
			return true
		end,
	}
	return routes
end

return mod

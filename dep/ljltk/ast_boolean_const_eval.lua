local BoolConstRule = { }

--[[A function that return a numeric constant if an AST node evaluate to an]]
--[[arithmetic constant or "nil" otherwise.]]
--[[The implementation of the function is given below.]]
local const_eval

local dirop_compute = function (o, a, b)
	if o == "and" then return a and b
	elseif o == "or" then return a or b end
end

BoolConstRule.Literal = function (node) if type(node.value) == "boolean" then return node.value end end

BoolConstRule.BinaryExpression = function (node)
	local o = node.operator
	local a = const_eval(node.left)
	if a ~= nil then
		local b = const_eval(node.right)
		if b ~= nil then return dirop_compute(o, a, b) end
	end
end

BoolConstRule.UnaryExpression = function (node)
	local o = node.operator
	if o == "not" then
		local v = const_eval(node.argument)
		if v ~= nil then return not v end
	end
end

const_eval = function (node)
	local rule = BoolConstRule[node.kind]
	if rule then return rule(node) end
end

return const_eval

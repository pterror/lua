local ConstRule = { }

--[[A function that return a numeric constant if an AST node evaluate to an]]
--[[arithmetic constant or "nil" otherwise.]]
--[[The implementation of the function is given below.]]
local const_eval

local dirop_compute = function (o, a, b)
	if o == "+" then return a + b
	elseif o == "-" then return a - b
	elseif o == "*" then return a * b
	elseif o == "/" then return (a ~= 0 or b ~= 0) and (a / b) or nil
	elseif o == "%" then return a % b
	elseif o == "^" then return a ^ b
	end
end

ConstRule.Literal = function (node)
	local v = node.value
	if type(v) == "number" then return v end
end

ConstRule.BinaryExpression = function (node)
	local o = node.operator
	local a = const_eval(node.left)
	if a then
		local b = const_eval(node.right)
		if b then return dirop_compute(o, a, b) end
	end
end

ConstRule.UnaryExpression = function (node)
	local o = node.operator
	if o == "-" then
		local v = const_eval(node.argument)
		if v then return -v end
	end
end

const_eval = function (node)
	local rule = ConstRule[node.kind]
	if rule then return rule(node) end
end

return const_eval

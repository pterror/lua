local operator = require("dep.ljltk.operator")

local concat = table.concat
local format = string.format

local try = function (ret)
	if ret == nil then return true else return ret end
end

local StatementRule = {}
local ExpressionRule = {}

local as_parameter = function (node) return node.kind == "Vararg" and "..." or node.name end

ExpressionRule.Identifier = function (self, node) return true end
ExpressionRule.Literal = function (self, node) return true end
ExpressionRule.MemberExpression = function (self, node)
	return try(self:visit_expr(node.object)) and (node.computed and try(self:visit_expr(node.property)) or true)
end
ExpressionRule.Vararg = function (self) return true end
ExpressionRule.ExpressionValue = function (self, node) return try(self:visit_expr(node.value)) end
ExpressionRule.BinaryExpression = function (self, node)
	return try(self:visit_expr(node.left)) and try(self:visit_expr(node.right))
end
ExpressionRule.UnaryExpression = function (self, node) return try(self:visit_expr(node.argument)) end
ExpressionRule.LogicalExpression = ExpressionRule.BinaryExpression
ExpressionRule.ConcatenateExpression = function (self, node)
	for _, term in ipairs(node.terms) do
		local ret = self:visit_expr(term)
		if ret == false then return false end
	end
end
ExpressionRule.Table = function (self, node)
	for _, kv in ipairs(node.keyvals) do
		local ret = try(self:visit_expr(kv[1])) and try(kv[2] and self:visit_expr(kv[2]))
		if ret == false then return false end
	end
end
ExpressionRule.CallExpression = function (self, node)
	return try(self:visit_expr(node.callee)) and try(self:visit_each_expr(node.arguments))
end
ExpressionRule.SendExpression = function (self, node)
	return try(self:visit_expr(node.receiver)) and try(self:visit_expr(node.method)) and try(self:visit_each_expr(node.arguments))
end
StatementRule.StatementsGroup = function (self, node) return try(self:visit_each_expr(node.arguments)) end
StatementRule.FunctionDeclaration = function (self, node)
	return try(self:visit_expr(node.id)) and try(self:visit_each(node.body))
end
ExpressionRule.FunctionExpression = function (self, node) return try(self:visit_each(node.body)) end
StatementRule.CallExpression = function (self, node) return try(self:visit_expr(node)) end
StatementRule.ForStatement = function (self, node)
	return try(self:visit_expr(node.init.value)) and try(self:visit_expr(node.last)) and try(self:visit_expr(node.step)) and try(self:visit_each(node.body))
end
StatementRule.ForInStatement = function (self, node)
	return try(self:visit_each_expr(node.explist)) and try(self:visit_each(node.body))
end
StatementRule.DoStatement = function (self, node) return try(self:visit_each(node.body)) end
StatementRule.WhileStatement = function (self, node)
	return try(self:visit_expr(node.test)) and try(self:visit_each(node.body))
end
StatementRule.RepeatStatement = function (self, node)
	return try(self:visit_each(node.body)) and try(self:visit_expr(node.test))
end
StatementRule.BreakStatement = function (self) return true end
StatementRule.IfStatement = function (self, node)
	for i = 1, #node.tests do
		local ret = try(self:visit_expr(node.tests[i])) and try(self:visit_each(node.cons[i]))
		if ret == false then return false end
	end
	return try(node.alternate and self:visit_each(node.alternate))
end
StatementRule.LocalDeclaration = function (self, node) return try(self:visit_each_expr(node.expressions)) end
StatementRule.AssignmentExpression = function (self, node)
	return try(self:visit_each_expr(node.left)) and try(self:visit_each_expr(node.right))
end
StatementRule.Chunk = function (self, node) return try(self:visit_each(node.body)) end
StatementRule.ExpressionStatement = function (self, node) return try(self:visit_expr(node.expression)) end
StatementRule.ReturnStatement = function (self, node) return try(self:visit_each_expr(node.arguments)) end
StatementRule.LabelStatement = function (self, node) return true end
StatementRule.GotoStatement = function (self, node) return true end

local visit = function (tree, visitor)
	local this = {}

	this.visit_expr = function (self, node)
		local rule = ExpressionRule[node.kind]
		if not rule then error("cannot find an expression rule for " .. node.kind) end
		if visitor(node) == false then return false end
		return rule(self, node)
	end

	this.visit = function (self, node)
		local rule = StatementRule[node.kind]
		if not rule then error("cannot find a statement rule for " .. node.kind) end
		if visitor(node) == false then return false end
		return rule(self, node)
	end

	this.visit_each_expr = function (self, expr_list)
		for _, expr in ipairs(expr_list) do
			local ret = self:visit_expr(expr)
			if ret == false then return false end
		end
	end

	this.visit_each = function (self, node_list)
		for _, node in ipairs(node_list) do
			local ret = self:visit(node)
			if ret == false then return false end
		end
	end

	this:visit(tree)
end

return visit

-- based off dep/ljltk/luacode_generator.lua  
-- notes:
-- - this *does not* convert a[i] into a[i - 1]. and so this *cannot* be used to write programs portable between js and lua
-- - similar things apply to `type()` vs `typeof` etc
-- changes:
-- - vararg turns into `...args` instead of `...`
-- - `x:method` turns into `x.method`
-- - braces are added as appropriate
-- - `::label::` turns into `label:`, `goto label` turns into `continue label`
--   - note that this isn't always valid, we can only hope
-- - until statement must be rewritten
-- - for multiple returns we use destructuring if `count > 1`.
--   - this will fail if the user wants just one variable and ignores the rest
--   - to avoid this, add `, _` as a dummy variable to destruct into
-- - `x.new` turns into `new x`
--   - this will fail if new is used for anything other than the constructor
-- - tables with any keys at all are turned into objects; else they are turned into arrays
-- - `async()`, `await()` -> `async`, `await`
-- - `error(msg)` -> `throw new Error(msg)`
-- - rewrite `#foo` to `foo.length`
-- todo:
-- - transpile `bit.band` to `&` etc. alternatively (easier) declare js-exclusive functions
-- - actually implementing the destructuring
-- - polyfills for e.g. `assert`
local mod = {}

local operator = require("dep.ljltk.operator")

--- @param op string
local js_operator = function (op)
	return ({
		["=="] = "===", ["~="] = "!==", ["^"] = "**", ["and"] = "&&", ["or"] = "||", ["not"] = "!",
	})[op] or op
end

local LuaReservedKeyword = {
	["and"] = 1, ["break"] = 2, ["do"] = 3, ["else"] = 4, ["elseif"] = 5, ["end"] = 6,
	["false"] = 7, ["for"] = 8, ["function"] = 9, ["goto"] = 10, ["if"] = 11, ["in"] = 12, ["local"] = 13, ["nil"] = 14,
	["not"] = 15, ["or"] = 16, ["repeat"] = 17, ["return"] = 18, ["then"] = 19, ["true"] = 20, ["until"] = 21,
	["while"] = 22
}

local ASCII_0 = 48; local ASCII_9 = 57
local ASCII_a = 97; local ASCII_z = 122
local ASCII_A = 65; local ASCII_Z = 90

local char_isletter = function (c)
	local b = string.byte(c)
	return (b >= ASCII_a and b <= ASCII_z) or (b >= ASCII_A and b <= ASCII_Z) or c == 95 --[[_]]
end

local char_isdigit = function (c)
	local b = string.byte(c)
	return b >= ASCII_0 and b <= ASCII_9
end

local replace_cc = function (c)
	local esc = {
		["\a"] = [[\a]], ["\b"] = [[\b]], ["\f"] = [[\f]], ["\n"] = [[\n]], ["\r"] = [[\r]], ["\t"] = [[\t]], ["\v"] = [[\v]]
	}
	return esc[c] or ("\\" .. string.format("%d", string.byte(c)))
end

local escape = function (s)
	return string.gsub(string.gsub(s, "[\"\\]", "\\%1"), "%c", replace_cc)
end

local StatementRule = {}
local ExpressionRule = {}

local is_string = function (node) return node.kind == "Literal" and type(node.value) == "string" end
local is_const = function (node, val) return node.kind == "Literal" and node.value == val end
local is_literal = function (node) return node.kind == "Literal" or node.kind == "Table" end

local string_is_ident = function (str)
	local c = string.sub(str, 1, 1)
	if c == "" or not char_isletter(c) then
		return false
	end
	for k = 2, #str do
		c = string.sub(str, k, k)
		if not char_isletter(c) and not char_isdigit(c) then
			return false
		end
	end
	return not LuaReservedKeyword[str]
end

--- @param destructure_if_multiple boolean?
local comma_sep_list = function (ls, f, destructure_if_multiple)
	local strls
	if f then
		strls = {}
		for k = 1, #ls do strls[k] = f(ls[k]) end
	else
		strls = ls
	end
	local res = table.concat(strls, ", ")
	return destructure_if_multiple and #ls > 1 and "[" .. res .. "]" or res
end

local as_parameter = function (node)
	return node.kind == "Vararg" and "...args" or node.name
end

ExpressionRule.Identifier = function (self, node)
	return node.name, operator.ident_priority
end

ExpressionRule.Literal = function (self, node)
	local val = node.value
	local str = type(val) == "string" and string.format("\"%s\"", escape(val)) or val == nil and "undefined" or tostring(val)
	return str, operator.ident_priority
end

ExpressionRule.MemberExpression = function (self, node)
	local object, prio = self:expr_emit(node.object)
	if prio < operator.ident_priority or is_literal(node.object) then
		object = "(" .. object .. ")"
	end
	local exp
	if node.computed then
		local prop = self:expr_emit(node.property)
		exp = string.format("%s[%s]", object, prop)
	else
		if node.property.name == "new" then
			exp = string.format("new %s", object)
		else
			exp = string.format("%s.%s", object, node.property.name)
		end
	end
	return exp, operator.ident_priority
end

ExpressionRule.Vararg = function ()
	return "...args", operator.ident_priority
end

ExpressionRule.ExpressionValue = function (self, node)
	-- TODO: check if this emits too much parens
	-- note that (see below) binops and unops properly check whether parens are needed
	return "(" .. self:expr_emit(node.value) .. ")"
end

ExpressionRule.BinaryExpression = function (self, node)
	local oper = node.operator
	local lprio = operator.left_priority(oper)
	local rprio = operator.right_priority(oper)
	local a, alprio, arprio = self:expr_emit(node.left)
	local b, blprio, brprio = self:expr_emit(node.right)
	if not arprio then arprio = alprio end
	if not brprio then brprio = blprio end
	local ap = arprio < lprio and string.format("(%s)", a) or a
	local bp = blprio <= rprio and string.format("(%s)", b) or b
	return string.format("%s %s %s", ap, js_operator(oper), bp), lprio, rprio
end

ExpressionRule.UnaryExpression = function (self, node)
	if node.operator == "#" then
		return self:expr_emit({ kind = "MemberExpression", object = node.argument, property = { name = "length" } })
	end
	local arg, arg_prio = self:expr_emit(node.argument)
	local op_prio = operator.unary_priority
	if arg_prio < op_prio then arg = string.format("(%s)", arg) end
	return string.format("%s%s", js_operator(node.operator), arg), operator.unary_priority
end

ExpressionRule.LogicalExpression = ExpressionRule.BinaryExpression

ExpressionRule.ConcatenateExpression = function (self, node)
	local ls = {}
	local cat_prio = operator.left_priority("..")
	for k = 1, #node.terms do
		local kprio
		ls[k], kprio = self:expr_emit(node.terms[k])
		if kprio < cat_prio then ls[k] = string.format("(%s)", ls[k]) end
	end
	return table.concat(ls, " + "), cat_prio
end

ExpressionRule.Table = function (self, node)
	local hash = {}
	local last = #node.keyvals
	local is_array = true
	for i = 1, last do
		if node.keyvals[i][2] then is_array = false; break end
	end
	if not is_array then
		local table_i = 0
		for i = 1, last do
			local kv = node.keyvals[i]
			local val = self:expr_emit(kv[1])
			local key = kv[2]
			if not key then
				hash[i] = string.format("%s: %s", table_i, val)
				table_i = table_i + 1
			elseif is_string(key) and string_is_ident(key.value) then
				hash[i] = string.format("%s: %s", key.value, val)
			else
				hash[i] = string.format("[%s]: %s", self:expr_emit(key), val)
			end
		end
	else
		for i = 1, last do
			local kv = node.keyvals[i]
			local val = self:expr_emit(kv[1])
			if i == last and kv[1].bracketed then -- TODO: not applicable to js
				hash[i] = string.format("(%s)", val)
			else
				hash[i] = string.format("%s", val)
			end
		end
	end
	local content = ""
	if #hash > 0 then
		content = comma_sep_list(hash)
	end
	return (is_array and "[" .. content .. "]" or "{" .. content .. "}"), operator.ident_priority
end

local is_js_keyword = { async = true, await = true, typeof = true }
mod.is_js_keyword = is_js_keyword

ExpressionRule.CallExpression = function (self, node)
	local callee, prio = self:expr_emit(node.callee)
	if prio < operator.ident_priority then
		callee = "(" .. callee .. ")"
	end
	if mod.is_js_keyword[callee] then
		local exp = string.format("%s %s", callee, self:expr_list(node.arguments))
		return exp, operator.ident_priority --[[FIXME: correct priority]]
	elseif callee == "unpack" then
		local exp = string.format("...%s", node.arguments[1])
		return exp, operator.ident_priority
	elseif callee == "instanceof" then
		local exp = string.format("%s instanceof %s", node.arguments[1], node.arguments[2])
		return exp, operator.ident_priority
	end
	if callee == "error" then callee = "throw new Error" end
	local exp = string.format("%s(%s)", callee, self:expr_list(node.arguments))
	return exp, operator.ident_priority
end

ExpressionRule.SendExpression = function (self, node)
	local rec, prio = self:expr_emit(node.receiver)
	if prio < operator.ident_priority or is_literal(node.receiver) then
		rec = "(" .. rec .. ")"
	end
	local method = node.method.name
	local exp = string.format("%s.%s(%s)", rec, method, self:expr_list(node.arguments))
	return exp, operator.ident_priority
end

StatementRule.StatementsGroup = function (self, node)
	for i = 1, #node.statements do
		self:emit(node.statements[i])
	end
end

StatementRule.FunctionDeclaration = function (self, node)
	self:proto_enter(0)
	local name = self:expr_emit(node.id)
	local header = string.format("function %s(%s) {", name, comma_sep_list(node.params, as_parameter))
	if node.locald then
		header = "local " .. header
	end
	self:add_section(header, node.body)
	local child_proto = self:proto_leave()
	self.proto:merge(child_proto)
end

ExpressionRule.FunctionExpression = function (self, node)
	self:proto_enter()
	local header = string.format("function (%s) {", comma_sep_list(node.params, as_parameter))
	self:add_section(header, node.body)
	local child_proto = self:proto_leave()
	return child_proto:inline(), 0
end

StatementRule.CallExpression = function (self, node)
	local line = self:expr_emit(node)
	self:add_line(line)
end

-- -TODO
StatementRule.ForStatement = function (self, node)
	local init = node.init
	local istart = self:expr_emit(init.value)
	local iend = self:expr_emit(node.last)
	local header
	if node.step and not is_const(node.step, 1) then
		header = string.format("for (let %s = %s; %s <= %s; %s += %s) {", init.id.name, istart, init.id.name, iend, init.id.name, self:expr_emit(node.step))
	else
		header = string.format("for (let %s = %s; %s <= %s; ++%s) {", init.id.name, istart, init.id.name, iend, init.id.name)
	end
	self:add_section(header, node.body)
end

StatementRule.ForInStatement = function (self, node)
	local vars = comma_sep_list(node.namelist.names, as_parameter, true)
	local explist = self:expr_list(node.explist)
	local header = string.format("for (let %s of %s) {", vars, explist)
	self:add_section(header, node.body)
end

StatementRule.DoStatement = function (self, node)
	self:add_section("{", node.body)
end

StatementRule.WhileStatement = function (self, node)
	local test = self:expr_emit(node.test)
	local header = string.format("while (%s) {", test)
	self:add_section(header, node.body)
end

StatementRule.RepeatStatement = function (self, node)
	self:add_section("do {", node.body, true)
	local test = self:expr_emit(node.test)
	local until_line = string.format("} while (!(%s));", test)
	self:add_line(until_line)
end

StatementRule.BreakStatement = function (self)
	self:add_line("break;")
end

StatementRule.IfStatement = function (self, node)
	local ncons = #node.tests
	for i = 1, ncons do
		local header_tag = i == 1 and "if" or "} else if"
		local test = self:expr_emit(node.tests[i])
		local header = string.format("%s (%s) {", header_tag, test)
		self:add_section(header, node.cons[i], true)
	end
	if node.alternate then
		self:add_section("} else {", node.alternate, true)
	end
	self:add_line("}")
end

StatementRule.LocalDeclaration = function (self, node)
	local line
	local names = comma_sep_list(node.names, as_parameter)
	if #node.expressions > 0 then
		if #node.names > 1 then
			if #node.expressions > 1 then io.stderr:write("FIXME: multiple initializers not supported yet"); os.exit(1) end
			line = string.format("let [%s] = %s;", names, self:expr_list(node.expressions))
		else
			line = string.format("let %s = %s;", names, self:expr_list(node.expressions))
		end
	else
		line = string.format("let %s;", names)
	end
	self:add_line(line)
end

StatementRule.AssignmentExpression = function (self, node) self:add_line(self:expr_list(node.left) .. " = " .. self:expr_list(node.right)) end
StatementRule.Chunk = function (self, node) self:list_emit(node.body) end
StatementRule.ExpressionStatement = function (self, node) self:add_line(self:expr_emit(node.expression) .. ";") end
StatementRule.ReturnStatement = function (self, node) self:add_line("return " .. self:expr_list(node.arguments) .. ";") end
StatementRule.LabelStatement = function (self, node) self:add_line(node.label .. ":") end
StatementRule.GotoStatement = function (self, node) self:add_line("continue " .. node.label .. ";") end

local proto_inline = function (proto)
	-- remove leading whitespaces from first line
	if #proto.code > 0 then
		proto.code[1] = string.gsub(proto.code[1], "^%s*", "")
	end
	return table.concat(proto.code, "\n")
end

local proto_merge = function (proto, child)
	for k = 1, #child.code do
		proto.code[#proto.code + 1] = string.rep("  ", proto.indent) .. child.code[k]
	end
end

local proto_new = function (parent, indent)
	local ind = 0
	if indent then
		ind = indent
	elseif parent then
		ind = parent.indent
	end
	local proto = { code = {}, indent = ind, parent = parent }
	proto.inline = proto_inline
	proto.merge = proto_merge
	return proto
end

mod.lua2js = function (tree, _)
	local self_ = { line = 0 }
	self_.proto = proto_new()
	self_.chunkname = tree.chunkname

	self_.proto_enter = function (self, indent)
		self.proto = proto_new(self.proto, indent)
	end

	self_.proto_leave = function (self)
		local proto = self.proto
		self.proto = proto.parent
		return proto
	end

	local to_expr = function (node) return self_:expr_emit(node) end
	self_.compile_code = function (self) return table.concat(self.code, "\n") end
	self_.indent_more = function (self) self.proto.indent = self.proto.indent + 1 end
	self_.indent_less = function (self) self.proto.indent = self.proto.indent - 1 end
	self_.line = function (self, line) --[[FIXME: ignored for the moment]] end

	self_.add_line = function (self, line)
		local proto = self.proto
		local indent = string.rep("  ", proto.indent)
		proto.code[#proto.code + 1] = indent .. line
	end

	self_.add_section = function (self, header, body, omit_end)
		self:add_line(header)
		self:indent_more()
		self:list_emit(body)
		self:indent_less()
		if not omit_end then
			self:add_line("}")
		end
	end

	self_.expr_emit = function (self, node)
		local rule = ExpressionRule[node.kind]
		if not rule then error("cannot find an expression rule for " .. node.kind) end
		return rule(self, node)
	end

	self_.expr_list = function (self, exps)
		return comma_sep_list(exps, to_expr)
	end

	self_.emit = function (self, node)
		local rule = StatementRule[node.kind]
		if not rule then error("cannot find a statement rule for " .. node.kind) end
		rule(self, node)
		if node.line then self:line(node.line) end
	end

	self_.list_emit = function (self, node_list)
		for i = 1, #node_list do self:emit(node_list[i]) end
	end

	self_:emit(tree)

	return self_:proto_leave():inline()
end

return mod

local id_generator = require("dep.ljltk.id_generator")

local build = function (kind, node)
	node.kind = kind
	return node
end

local ident = function (name, line)
	return build("Identifier", { name = name, line = line })
end

local literal = function (value, line)
	return build("Literal", { value = value, line = line })
end

local field = function (obj, name, line)
	return build("MemberExpression", { object = obj, property = ident(name), computed = false, line = line })
end

local logical_binop = function (op, left, right, line)
	return build("LogicalExpression", { operator = op, left = left, right = right, line = line })
end

local binop = function (op, left, right, line)
	return build("BinaryExpression", { operator = op, left = left, right = right, line = line })
end

local empty_table = function (line)
	return build("Table", { keyvals = { }, line = line })
end

local does_multi_return = function (expr)
	local k = expr.kind
	return k == "CallExpression" or k == "SendExpression" or k == "Vararg"
end

local AST = { }

local func_decl = function (id, body, params, vararg, locald, firstline, lastline)
	return build("FunctionDeclaration", {
		id         = id,
		body       = body,
		params     = params,
		vararg     = vararg,
		locald     = locald,
		firstline  = firstline,
		lastline   = lastline,
		line       = firstline,
	})
end

local func_expr = function (body, params, vararg, firstline, lastline)
	return build("FunctionExpression", { body = body, params = params, vararg = vararg, firstline = firstline, lastline = lastline })
end

AST.expr_function = function (ast, args, body, proto)
	return func_expr(body, args, proto.varargs, proto.firstline, proto.lastline)
end

AST.local_function_decl = function (ast, name, args, body, proto)
	local id = ast:var_declare(name)
	return func_decl(id, body, args, proto.varargs, true, proto.firstline, proto.lastline)
end

AST.function_decl = function (ast, path, args, body, proto)
	return func_decl(path, body, args, proto.varargs, false, proto.firstline, proto.lastline)
end

AST.func_parameters_decl = function (ast, args, vararg)
	local params = {}
	for i = 1, #args do
		params[i] = ast:var_declare(args[i])
	end
	if vararg then
		params[#params + 1] = ast:expr_vararg()
	end
	return params
end

AST.chunk = function (ast, body, chunkname, firstline, lastline)
	return build("Chunk", { body = body, chunkname = chunkname, firstline = firstline, lastline = lastline })
end

AST.local_decl = function (ast, vlist, exps, line)
	local ids = {}
	for k = 1, #vlist do
		ids[k] = ast:var_declare(vlist[k])
	end
	return build("LocalDeclaration", { names = ids, expressions = exps, line = line })
end

AST.assignment_expr = function (ast, vars, exps, line)
	return build("AssignmentExpression", { left = vars, right = exps, line = line })
end

AST.expr_index = function (ast, v, index, line)
	return build("MemberExpression", { object = v, property = index, computed = true, line = line })
end

AST.expr_property = function (ast, v, prop, line)
	local index = ident(prop, line)
	return build("MemberExpression", { object = v, property = index, computed = false, line = line })
end

AST.literal = function (ast, val)
	return build("Literal", { value = val })
end

AST.expr_vararg = function (ast)
	return build("Vararg", { })
end

AST.expr_brackets = function (ast, expr)
	expr.bracketed = true
	return expr
end

AST.set_expr_last = function (ast, expr)
	if expr.bracketed and does_multi_return(expr) then
		expr.bracketed = nil
		return build("ExpressionValue", { value = expr })
	else
		return expr
	end
end

AST.expr_table = function (ast, keyvals, line)
	return build("Table", { keyvals = keyvals, line = line })
end

AST.expr_unop = function (ast, op, v, line)
	return build("UnaryExpression", { operator = op, argument = v, line = line })
end

local concat_append = function (ts, node)
	local n = #ts
	if node.kind == "ConcatenateExpression" then
		for k = 1, #node.terms do ts[n + k] = node.terms[k] end
	else
		ts[n + 1] = node
	end
end

AST.expr_binop = function (ast, op, expa, expb, line)
	local binop_body = (op ~= ".." and { operator = op, left = expa, right = expb, line = line })
	if binop_body then
		if op == "and" or op == "or" then
			return build("LogicalExpression", binop_body)
		else
			return build("BinaryExpression", binop_body)
		end
	else
		local terms = { }
		concat_append(terms, expa)
		concat_append(terms, expb)
		return build("ConcatenateExpression", { terms = terms, line = expa.line })
	end
end

AST.identifier = function (ast, name)
	return ident(name)
end

AST.expr_method_call = function (ast, v, key, args, line)
	local m = ident(key)
	return build("SendExpression", { receiver = v, method = m, arguments = args, line = line })
end

AST.expr_function_call = function (ast, v, args, line)
	return build("CallExpression", { callee = v, arguments = args, line = line })
end

AST.return_stmt = function (ast, exps, line)
	return build("ReturnStatement", { arguments = exps, line = line })
end

AST.break_stmt = function (ast, line)
	return build("BreakStatement", { line = line })
end

AST.label_stmt = function (ast, name, line)
	return build("LabelStatement", { label = name, line = line })
end

AST.new_statement_expr = function (ast, expr, line)
	return build("ExpressionStatement", { expression = expr, line = line })
end

AST.if_stmt = function (ast, tests, cons, else_branch, line)
	return build("IfStatement", { tests = tests, cons = cons, alternate = else_branch, line = line })
end

AST.do_stmt = function (ast, body, line, lastline)
	return build("DoStatement", { body = body, line = line, lastline = lastline})
end

AST.while_stmt = function (ast, test, body, line, lastline)
	return build("WhileStatement", { test = test, body = body, line = line, lastline = lastline })
end

AST.repeat_stmt = function (ast, test, body, line, lastline)
	return build("RepeatStatement", { test = test, body = body, line = line, lastline = lastline })
end

AST.for_stmt = function (ast, var, init, last, step, body, line, lastline)
	local for_init = build("ForInit", { id = var, value = init, line = line })
	return build("ForStatement", { init = for_init, last = last, step = step, body = body, line = line, lastline = lastline })
end

AST.for_iter_stmt = function (ast, vars, exps, body, line, lastline)
	local names = build("ForNames", { names = vars, line = line })
	return build("ForInStatement", { namelist = names, explist = exps, body = body, line = line, lastline = lastline })
end

AST.goto_stmt = function (ast, name, line)
	return build("GotoStatement", { label = name, line = line })
end

AST.var_declare = function (ast, name)
	local id = ident(name)
	ast.variables:declare(name)
	return id
end

AST.genid = function (ast, name)
	return id_generator.genid(ast.variables, name)
end

AST.fscope_begin = function (ast)
	ast.variables:scope_enter()
end

AST.fscope_end = function (ast)
	-- It is important to call id_generator.close_gen_variables before
	-- leaving the "variables" scope.
	id_generator.close_gen_variables(ast.variables)
	ast.variables:scope_exit()
end

local ASTClass = { __index = AST }

local new_scope = function (parent_scope)
	return {
		vars = { },
		parent = parent_scope,
	}
end

local new_variables_registry = function (create, match)
	local declare = function(self, name)
		local vars = self.current.vars
		local entry = create(name)
		vars[#vars+1] = entry
		return entry
	end

	local scope_enter = function(self)
		self.current = new_scope(self.current)
	end

	local scope_exit = function(self)
		self.current = self.current.parent
	end

	local lookup = function(self, name)
		local scope = self.current
		while scope do
			for i = 1, #scope.vars do
				if match(scope.vars[i], name) then
					return scope
				end
			end
			scope = scope.parent
		end
	end

	return { declare = declare, scope_enter = scope_enter, scope_exit = scope_exit, lookup = lookup }
end

local new_ast = function ()
	local match_id_name = function(id, name) return id.name == name end
	local vars = new_variables_registry(ident, match_id_name)
	return setmetatable({ variables = vars }, ASTClass)
end

return { New = new_ast }

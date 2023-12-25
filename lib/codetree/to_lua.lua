local mod = {}

--[[@type table<codetree_node_type, fun(node: codetree_node, write: fun(code: string))>]]
local writers = {}
mod.writers = writers

--[[@param node codetree_node]] --[[@param write fun(code: string)]]
local write_node = function (node, write)
	local writer = writers[node.type]
	if writer then writer(node, write); return true
	else return nil, "error: unknown codetree node type " .. tostring(node.type) end
end

--[[@param node codetree_boolean_node]]
writers.boolean = function (node, write) write(tostring(node.value)) end
--[[@param node codetree_integer_node]]
writers.integer = function (node, write) write(tostring(node.value)) end
--[[@param node codetree_number_node]]
writers.number = function (node, write) write(tostring(node.value)) end
--[[@param node codetree_string_node]]
writers.string = function (node, write) write(node.value) end
--[[@param node codetree_array_node]]
writers.array = function (node, write)
	write("{ ")
	for _, value in ipairs(node.values) do write_node(value, write); write(", ") end
	write(" }")
end
--[[@param node codetree_struct_node]]
writers.struct = function (node, write)
	write("{ ")
	for _, entry in ipairs(node.entries) do
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		if entry.key.type == "string" and entry.key.value:find("^[%w_]+$") then
			write(entry.key.value .. " = ")
			write_node(entry.value, write)
			write(", ")
		else
			write_node(entry.key, write)
			write(" = ")
			write_node(entry.value, write)
			write(", ")
		end
	end
	write(" }")
end
--[[@param node codetree_block_node]]
writers.block = function (node, write)
	write("do\n")
	for _, statement in ipairs(node.statements) do
		write("\t")
		write_node(statement, write)
		write(";\n")
	end
	write("end")
end
--[[FIXME: consider validating object keys, although any table should be a valid key in lua]]
--[[@param node codetree_function_node]]
writers["function"] = function (node, write)
	write("function (")
	for i, argument in ipairs(node.parameters) do
		if i > 1 then write(", ") end
		write_node(argument, write)
	end
	--[[TODO: consider using a block node instead - e.g. to allow top level scripts]]
	--[[and things like classes]]
	if node.body.type == "block" then
		write(")\n")
		for _, statement in ipairs(node.body.statements) do
			write("\t")
			write_node(statement, write)
			write(";\n")
		end
		write("end")
	else write(") "); write_node(node.body, write); write(" end") end
end
--[[@param node codetree_call_node]]
writers.call = function (node, write)
	--[[FIXME: `foo + bar` cannot be called directly due to syntax issues]]
	write("(")
	write_node(node["function"], write)
	write(")(")
	for i, argument in ipairs(node.arguments) do
		if i > 1 then write(", ") end
		write_node(argument, write)
	end
	write(")")
end
--[[@param node codetree_declaration_node]]
writers.declaration = function (node, write)
	write("local " .. node.name .. " = ")
	write_node(node.value, write)
	--[[semicolon omitted as the function adds those.]]
end

--[[@param node codetree_node]]
mod.codetree_to_lua = function (node)
	--[[@type string[] ]]
	local parts = {}
	--[[@param chunk string]]
	local write = function (chunk) parts[#parts+1] = chunk end
	write_node(node, write)
	return table.concat(parts)
end

return mod

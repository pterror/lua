--[[language agnostic semantics tree]]

local mod = {}

--[[@alias codetree_node_type "boolean"|"integer"|"number"|"string"|"array"|"struct"|"block"|"function"|"declaration"|"call"]]
--[[@alias codetree_node codetree_boolean_node|codetree_integer_node|codetree_number_node|codetree_string_node|codetree_array_node|codetree_struct_entry|codetree_block_node|codetree_function_node|codetree_call_node|codetree_declaration_node]]

--[[@class codetree_base_node]]
--[[@field type string]]

--[[@class codetree_boolean_node: codetree_base_node]]
--[[@field type "boolean"]]
--[[@field value boolean]]

--[[@class codetree_integer_node: codetree_base_node]]
--[[@field type "integer"]]
--[[@field value integer]]

--[[@class codetree_number_node: codetree_base_node]]
--[[@field type "number"]]
--[[@field value number]]

--[[@class codetree_string_node: codetree_base_node]]
--[[@field type "string"]]
--[[@field value string]]

--[[@class codetree_array_node: codetree_base_node]]
--[[@field type "array"]]
--[[@field values codetree_node[] ]]

--[[@class codetree_struct_node: codetree_base_node]]
--[[@field type "struct"]]
--[[@field entries codetree_struct_entry[] ]]

--[[@class codetree_struct_entry]]
--[[@field key codetree_node]]
--[[@field value codetree_node]]

--[[@class codetree_block_node: codetree_base_node]]
--[[@field type "block"]]
--[[@field statements codetree_node[] ]]

--[[@class codetree_function_node: codetree_base_node]]
--[[@field type "function"]]
--[[@field parameters codetree_node[] ]]
--[[@field body codetree_node ]]

--[[@class codetree_call_node: codetree_base_node]]
--[[@field type "call"]]
--[[@field function codetree_node]]
--[[@field arguments codetree_node[] ]]

--[[TODO: how to distinguish between let and const? and maybe noreassign]]
--[[@class codetree_declaration_node: codetree_base_node]]
--[[@field type "declaration"]]
--[[@field name string]]
--[[@field value codetree_node]]

--[[FIXME: consider match arms; update spec.md]]

return mod

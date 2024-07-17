#!/usr/bin/env luajit
local version = "dev" --[["v0.17.0"]]

local sh = function(cmd) --[[@param cmd string]]
	--[[@return string?]]
	local f = io.popen(cmd)
	local ret = f and f:read("*all"):gsub("\n$", "")
	if f then f:close() end
	return ret
end

local shl = function(cmd) --[[@param cmd string]]
	--[[@return string?]]
	local f = io.popen(cmd)
	--[[@return string?]]
	return function()
		if not f then return end
		local ret = f:read("*line")
		while ret and #ret == 0 do ret = f:read("*line") end
		return ret
	end
end

local to_snake_case = function(s) --[[@param s string]]
	return s:sub(1, 1):lower() .. s:sub(2):gsub("[A-Z]", function(m) return "_" .. m:lower() end)
end

local replacements = { ["\r"] = "\\r", ["\n"] = "\\n", ["\t"] = "\\t", ["\""] = "\\\"", ["\\"] = "\\\\" }

local is_tensor_function_prefix = { vec = true, mat = true, newVec = true, newMat = true, quat = true }

local field_x = { name = "x", value = "0.0" }
local field_y = { name = "y", value = "0.0" }
local field_z = { name = "z", value = "0.0" }
local field_w = { name = "w", value = "0.0" }
local fields_for_class = {
	Vec2 = { field_x, field_y },
	Vec3 = { field_x, field_y, field_z },
	Vec4 = { field_x, field_y, field_z, field_w },
}

--[[@param s string]]
local escape = function(s) return s:gsub("[\r\n\t\"\\]", replacements) end

local is_keyword = {
	["and"] = true,
	["break"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
	["while"] = true,
}

local to_arg_name = function(s) --[[@param s string]]
	return s:find("^%.%.%.") and "..." or (is_keyword[s] and (s .. "_") or s)
end

--[[@param k string|number]]
local as_key = function(k)
	if type(k) ~= "string" then return "[" .. tostring(k) .. "]" end
	local escaped = escape(k)
	if escaped == k and not k:find("%W") and not k:find("^%d") and not is_keyword[k] then
		return k
	else
		return "[\"" .. escaped .. "\"]"
	end
end

--[[assume posix]]
local root = sh([[realpath "]] .. arg[0] .. [["]]):gsub("/([^/]+)/([^/]+)$", "")
local deps = root .. "/deps/"
local docs = deps .. "lovr-docs/"
local _, _, code = os.execute("ls " .. docs .. " >/dev/null 2>&1")
if code then
	os.execute("git clone https://github.com/bjornbytes/lovr-docs " .. docs)
end
os.execute("cd " .. docs .. "; git checkout " .. version .. "; git pull")


local types = io.open(root .. "/lovr/_types.lua", "w")
if not types then return end
local write = function(...) types:write(...) end --[[@param ... string|number]]
write([=[
--[[@diagnostic disable: redefined-local, unused-local, lowercase-global]]

--[[make luals happy]]
if false then
	local userdata --[[@type userdata]]
	local lightuserdata --[[@type lightuserdata]]

	--[[https://lovr.org/docs/lovr  ]]
	--[[@class lovr]]
]=])

local table_docs = {} --[[@type string[][] ]]

local flush_table_docs = function()
	for _, doc in ipairs(table_docs) do
		write(unpack(doc))
		write("\n")
	end
	table_docs = {}
end

local builtin_type_values = {
	boolean = "false",
	number = "0",
	string = "\"\"",
	["function"] = "function() end",
	userdata = "userdata",
	lightuserdata = "lightuserdata",
	table = "{}",
	["*"] = "nil"
}

local value_of_type = function(arg)
	local value = builtin_type_values[arg.type]
	if value then return value end
	if arg.type:find("^[A-Z]") then return arg.type .. "_class" end
	io.stderr:write("error: unknown type ", arg.type, "\n")
end

--[[@param names string[] ]]
local write_related_internal = function(names)
	for _, name in ipairs(names) do
		write("\t--[[* [`" .. name .. "`](lua://")
		if name:find("^[A-Z]") then
			write("lovr_" .. name:sub(1, 1):lower() .. name:sub(2):gsub(":", "."))
		else
			write(name)
		end
		write(")]]\n")
	end
end

--[[@param names? string[] ]]
--[[@param extra_names? string[] ]]
local write_related = function(names, extra_names)
	if (not names or #names == 0) and (not extra_names or #extra_names == 0) then return end
	write("\t--[[### See also]]\n")
	if names then write_related_internal(names) end
	if extra_names then write_related_internal(extra_names) end
end

local is_table_generated = {} --[[@type table<string,boolean>]]

local write_type
--[[@param arg table]]
--[[@param write_ fun(...: string)]]
--[[@param id string]]
--[[@param header string]]
write_type = function(arg, write_, id, header)
	if arg.type:find("^[A-Z]") then
		write_("lovr_", to_snake_case(arg.type))
	elseif arg.type == "table" then
		if not arg.table then
			write_("table<string,string|number>")
		else
			local is_array = arg.table and arg.table[1].name:find("^%[%]")
			write_(id)
			if is_array then write_("[]") end
			if is_table_generated[id] then return end
			is_table_generated[id] = true
			local table_doc = {}
			table_docs[#table_docs + 1] = table_doc
			local write_inner = function(...)
				for i = 1, select("#", ...) do table_doc[#table_doc + 1] = select(i, ...) end
			end
			write_inner(header)
			write_inner("\t--[[@class ", id, "]]\n")
			for _, entry in ipairs(arg.table) do
				local entry_name = is_array and entry.name:gsub("^%[%]%.?", "") or entry.name
				local is_optional = entry.default or (id == "lovr_graphics_new_buffer_format" and entry_name == "stride")
				write_inner("\t--[[@field ", entry_name, is_optional and "? " or " ")
				write_type(entry, write_inner, id .. "_" .. entry_name, header)
				if entry.default ~= nil then
					write_inner(" default=`", entry.default, "`]]\n")
				else
					write_inner(" ]]\n")
				end
			end
		end
	elseif arg.type == "*" then
		write_("unknown")
	else
		write_(arg.type)
	end
end

--[[@param arg table]]
--[[@param arg_name string]]
local is_arg_optional = function(arg, arg_name) return arg.default ~= nil or arg_name == "options" end

--[[@param overload table]]
--[[@param data table]]
--[[@param id string]]
--[[@param header string]]
--[[@param class_name? string]]
local write_function_type = function(overload, data, id, header, class_name)
	if overload.deprecated then return end
	write("fun(")
	if class_name then write("self: lovr_", to_snake_case(class_name:gsub("_class$", ""))) end
	for j, arg_name in ipairs(overload.arguments) do
		if j > 1 or class_name then write(", ") end
		local arg = data.arguments[arg_name]
		arg_name = to_arg_name(arg_name)
		write(arg_name, is_arg_optional(arg, arg_name) and "?: " or ": ")
		write_type(arg, write, id .. "_" .. arg_name, header)
	end
	write(")")
	for j, ret_name in ipairs(overload.returns) do
		write(j > 1 and ", " or ": ")
		local ret = data.returns[ret_name]
		ret_name = to_arg_name(ret_name)
		write_type(ret, write, id .. "_" .. ret_name, header)
		if id == "lovr_draw" and ret_name == "skip" then write("?") end
	end
end

--[[@param data table]]
--[[@param name string]]
--[[@param id string]]
--[[@param extra_related? string[] ]]
--[[@param is_cb? boolean]]
local write_function = function(data, name, id, extra_related, is_cb)
	local id_raw = id
	local class_name = name:find(":") and (name:match("^([^:]+)"))
	id = "lovr_" .. id
	local var_name = name
	name = name:gsub("_class", "")
	local header = [=[
	--[[https://lovr.org/docs/]=] .. name .. [=[  ]]
	--[[see also:  ]]
	--[[[`]=] .. name .. "`](lua://" .. name .. ")  ]]\n"
	local first_overload = data.variants[1]
	if not first_overload then io.stderr:write("error: no overloads: ", name, "\n") end
	write("\t--[[https://lovr.org/docs/", name, "  ]]\n")
	write("\t--[[", data.summary, "  ]]\n")
	write_related(data.related, extra_related)
	if is_cb then
		write("\t--[[@field ", id_raw, " ")
		write_function_type(first_overload, data, id, header)
		write("]]\n")
	else
		for _, arg_name in ipairs(first_overload.arguments) do
			local arg = data.arguments[arg_name]
			arg_name = to_arg_name(arg_name)
			write("\t--[[@param ", arg_name, is_arg_optional(arg, arg_name) and "? " or " ")
			write_type(arg, write, id .. "_" .. arg_name, header)
			if arg.default then write(" default=`", arg.default, "`") end
			write("]]\n")
		end
		for _, ret_name in ipairs(first_overload.returns) do
			local ret = data.returns[ret_name]
			ret_name = to_arg_name(ret_name)
			write("\t--[[@return ")
			write_type(ret, write, id .. "_" .. ret_name, header)
			write(" ", ret_name, "]]\n")
		end
	end
	if data.deprecated then write("\t--[[@deprecated]]\n") end
	if not is_cb then
		for i = 2, #data.variants do
			local overload = data.variants[i]
			if not overload.deprecated then
				write("\t--[[@overload ")
				write_function_type(overload, data, id, header, class_name)
				write("]]\n")
			end
		end
		write("\tfunction ", var_name, "(")
		for i, arg_name in ipairs(first_overload.arguments) do
			if i > 1 then write(", ") end
			write(to_arg_name(arg_name))
		end
		write(")")
		for i, ret_name in ipairs(first_overload.returns) do
			write(i > 1 and ", " or " return ")
			local ret = data.returns[ret_name]
			write(value_of_type(ret))
		end
		write(" end\n")
		write("\n")
	end
end

for cb_path in shl("ls " .. docs .. "api/lovr/callbacks/") do
	local cb_name = cb_path:gsub("%.lua$", "")
	local data = dofile(docs .. "api/lovr/callbacks/" .. cb_path)
	write_function(data, "lovr." .. cb_name, to_snake_case(cb_name), nil, true)
end
write("\tlovr = lovr\n")
write("\n")
flush_table_docs()
local mods_to_skip = { Object = true, http = true, utf8 = true }
write("\t--[[@class lovr_object]]\n")
write("\tlocal Object_class\n")
for mod_path in shl("ls " .. docs .. "api/lovr/") do
	--[[forward declare dummy variables for classes and enums]]
	for member_path in shl("ls " .. docs .. "api/lovr/" .. mod_path) do
		local member_name = member_path:gsub("%.lua$", "")
		local is_enum = member_path:find("%.lua$")
		if member_path:find("^[A-Z]") then
			write("\t--[[@", (is_enum and "type" or "class"), " lovr_", to_snake_case(member_name), "]]\n")
			write("\tlocal ", member_name, "_class\n")
		end
	end
end
do
	local member_path = "Object"
	local member_name = member_path
	local extra_related = { member_path }
	local data = dofile(docs .. "api/lovr/" .. member_path .. "/init.lua")
	write("\t--[[https://lovr.org/docs/", member_path, "  ]]\n")
	write("\t--[[", data.summary, "  ]]\n")
	write_related(data, nil)
	write("\t--[[@class lovr_", to_snake_case(member_name), "]]\n")
	write("\n")
	local class_name = member_name .. "_class"
	for method_path in shl("ls " .. docs .. "api/lovr/" .. member_path) do
		if method_path ~= "init.lua" then
			local method_name = method_path:gsub("%.lua$", "")
			local method_data = dofile(docs .. "api/lovr/" .. member_path .. "/" .. method_path)
			write_function(method_data, class_name .. ":" .. method_name,
				to_snake_case(member_name) .. "_" .. to_snake_case(method_name), extra_related)
		end
	end
end
for mod_path in shl("ls " .. docs .. "api/lovr/") do
	if mod_path ~= "callbacks" and not mod_path:find("%.lua$") and not mods_to_skip[mod_path] then
		write("\t--[[https://lovr.org/docs/lovr.", mod_path, "  ]]\n")
		write("\t--[[@class lovr_", mod_path, "]]\n")
		write("\tlovr.", mod_path, " = {}\n")
		write("\n")
		for member_path in shl("ls " .. docs .. "api/lovr/" .. mod_path) do
			local member_name = member_path:gsub("%.lua$", "")
			if member_path:find("%.lua$") then
				local extra_related = { "lovr." .. mod_path }
				local data = dofile(docs .. "api/lovr/" .. mod_path .. "/" .. member_path)
				if member_path:find("^[A-Z]") then
					--[[is enum]]
					local member_name_raw = member_name
					member_name = to_snake_case(member_name)
					write("\t--[[https://lovr.org/docs/", member_name_raw, "  ]]\n")
					write("\t--[[", data.summary, "  ]]\n")
					write_related(data.related, extra_related)
					write("\t--[[@enum lovr_", member_name, "]]\n")
					write("\tlocal lovr_", member_name, " = {\n")
					for _, value in ipairs(data.values) do
						write("\t\t--[[", value.description:gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n%s*", " "), "  ]]\n")
						write("\t\t", as_key(value.name), " = \"", escape(value.name), "\",\n")
					end
					write("\t}\n")
					write("\n")
				elseif member_name ~= "init" then
					write_function(data, "lovr." .. mod_path .. "." .. member_name,
						mod_path .. "_" .. to_snake_case(member_name), extra_related)
					if mod_path == "math" then
						local is_tensor_function = is_tensor_function_prefix[member_name:gsub("%d+$", "")]
						if is_tensor_function then
							local member_global_name = member_name:gsub("^new", "")
							write_function(data, member_global_name,
								mod_path .. "_" .. to_snake_case(member_name), extra_related)
						end
					end
				end
				flush_table_docs()
			else
				local extra_related = { member_name }
				local data = dofile(docs .. "api/lovr/" .. mod_path .. "/" .. member_path .. "/init.lua")
				write("\t--[[https://lovr.org/docs/", member_path, "  ]]\n")
				write("\t--[[", data.summary, "  ]]\n")
				write_related(data, nil)
				write("\t--[[@class lovr_", to_snake_case(member_name), ": lovr_object]]\n")
				write("\n")
				local class_name = member_name .. "_class"
				for method_path in shl("ls " .. docs .. "api/lovr/" .. mod_path .. "/" .. member_path) do
					if method_path ~= "init.lua" then
						local method_name = method_path:gsub("%.lua$", "")
						local method_data = dofile(docs .. "api/lovr/" .. mod_path .. "/" .. member_path .. "/" .. method_path)
						write_function(method_data, class_name .. ":" .. method_name,
							mod_path .. "_" .. to_snake_case(member_name) .. "_" .. to_snake_case(method_name), extra_related)
					end
				end

				local fields = fields_for_class[member_name]
				if fields then
					for _, field in ipairs(fields) do
						write_related(nil, extra_related)
						write("\t", class_name, ".", field.name, " = ", field.value, "\n")
						write("\n")
					end
				end
			end
		end
		write("\n")
	end
end
write([=[
	--[[https://lovr.org/docs/lovr.headset.getHands  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_hand]]
	local lovr_hand = {
		left = "hand/left",
		right = "hand/right",
	}

	--[[https://lovr.org/docs/http  ]]
	--[[@class lovr_http]]
	local http = {}

	--[[https://lovr.org/docs/http  ]]
	--[[requires libcurl to be installed if on linux  ]]
	--[[@param url string]]
	--[[@param options? lovr_http_options]]
	--[[@return integer? status]]
	--[[@return string data response if status is present, else error]]
	--[[@return table<string,string>? headers]]
	function http.request(url, options) return nil, "" end

	--[[https://lovr.org/docs/http  ]]
	--[[https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods  ]]
	--[[@enum lovr_http_method]]
	local lovr_http_method = {
		get = "GET",
		head = "HEAD",
		post = "POST",
		put = "PUT",
		delete = "DELETE",
		connect = "CONNECT",
		options = "OPTIONS",
		trace = "TRACE",
		patch = "PATCH",
	}

	--[[https://lovr.org/docs/http  ]]
	--[[@class lovr_http_options]]
	--[[@field method? lovr_http_method default "POST" if data is present, else "GET"]]
	--[[@field data? string|table<string,string|number>|lightuserdata]]
	--[[@field datasize? integer size of the payload in bytes, if the payload is a lightuserdata]]
	--[[@field headers? table<string,string|number>]]
]=])
write("end\n")
types:close()

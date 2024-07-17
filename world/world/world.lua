local ui = require("ui")

local mod = {}

--[[@class world: {objects:unknown[]}]]

local io = io
local os = os
local print = print
_G.io = nil
_G.os = nil
_G.print = nil
string.dump = nil
local original_load = load
load = function(chunk, chunkname, _, env)
	return original_load(chunk, chunkname, "t", env)
end
-- loadstring = function() end
_G.loadfile = nil
--[[this is far from 100% bulletproof but it's a start]]
local initialize_sandbox = function()
	setmetatable(_G, { __newindex = function(_, k) io.stderr:write("error: cannot create new global: ", k, "\n") end })
end

mod.null = {}
mod.metatable_symbol = {}
mod.properties_metatable_symbol = {}

local function_metatable = {}
function_metatable.__call = function(self, ...)
	return self.function_(...)
end

--[[@param x unknown]]
local is_function = function(x) return getmetatable(x) == function_metatable end

--[[@param source string]]
mod.function_ = function(source)
	return setmetatable({ source = source, function_ = loadstring("return " .. source)() }, function_metatable)
end
local make_context = function(path, opts)
	opts = opts or {}
	local context = {}
	context.ui = type(opts.ui) == "table" and opts.ui or type(opts.ui) == "string" or ui[opts.ui] or ui.ansi
	context.null = mod.null
	context.function_ = mod.function_
	--[[@param backup? boolean]]
	context.save = function(backup) mod.save(path, context.world, backup) end
	return context
end

local replacements = { ["\r"] = "\\r", ["\n"] = "\\n", ["\t"] = "\\t", ["\""] = "\\\"", ["\\"] = "\\\\" }

--[[@param s string]]
local escape = function(s) return s:gsub("[\r\n\t\"]", replacements) end

--[[@param s string]]
local escape_raw = function(s)
	local count = 0
	while true do
		local end_delimiter = "]" .. ("="):rep(count) .. "]"
		if not s:find(end_delimiter) then break end
		count = count + 1
	end
	local equals = ("="):rep(count)
	return "[" .. equals .. "[" .. s .. "]" .. equals .. "]"
end

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

local write_object

local pretty_print = function(val, write, depth)
	write = write or function(...) io.stdout:write(...) end
	if type(val) ~= "table" then
		write(tostring(val))
	else
		write_object(val, write, nil, nil, depth)
	end
end

local write_object_without_metatable
write_object_without_metatable = function(object, write, on_write_table, data, depth) --[[@param object table]]
	if depth and depth <= 0 then
		write("...")
		return
	end
	on_write_table = on_write_table or
			function(v, k, data2)
				write_object(v, write, on_write_table, data2,
					depth and (depth - (type(k) == "number" and (k <= #object and 0 or 1) or 1)))
			end
	write("{ ")
	local length = #object
	for k, v in pairs(object) do
		if type(k) ~= "number" or k > length then write(as_key(k), " = ") end
		if type(v) == "string" then
			write("\"", escape(v), "\"")
		elseif is_function(v) then
			write("ctx.function_(", escape_raw(v.source), ")")
		elseif type(v) ~= "table" then
			write(tostring(v))
		else
			on_write_table(v, k, data)
		end
		write(", ")
	end
	write("}")
end

--[[@param object table]]
write_object = function(object, write, on_write_table, data, depth)
	if depth and depth <= 0 then
		write("...")
		return
	end
	on_write_table = on_write_table or
			function(v, k, data2)
				write_object(v, write, on_write_table, data2,
					depth and (depth - (type(k) == "number" and (k <= #object and 0 or 1) or 1)))
			end
	local metatable = getmetatable(object) --[[@type table?]]
	if metatable then write("setmetatable(") end
	write_object_without_metatable(object, write, on_write_table, data)
	if metatable then
		write(", ")
		on_write_table(metatable, mod.metatable_symbol, data)
		write(")")
	end
end

--[[@param path string]]
mod.load = function(path)
	local contents; do
		local file = assert(io.open(path, "r"))
		contents = file:read("*all")
		file:close()
	end
	return loadstring(contents)()(make_context(path))
end

--[[@param path string]]
--[[@param world world]]
mod.save_internal = function(path, world)
	local file = assert(io.open(path, "w"))
	local write = function(...) file:write(...) end --[[@param ... string]]
	local nested_object_lookup = {} --[[@type table<table, integer>]]
	local nested_object_counts = {} --[[@type table<table, integer>]]
	local nested_objects = {} --[[@type table[] ]]
	local nested_object_count = 0
	local process_object
	--[[@param v unknown]]
	--[[@param parent_exists boolean?]]
	local process_value = function(v, parent_exists)
		if type(v) == "table" and not is_function(v) then
			local exists = nested_object_counts[v] ~= nil
			nested_object_counts[v] = math.max(1, (nested_object_counts[v] or 0) + (parent_exists and 0 or 1))
			nested_object_count = nested_object_count + 1
			local old_i = nested_object_lookup[v]
			if old_i then nested_objects[old_i] = nil end
			local i = nested_object_count
			nested_objects[i] = v
			nested_object_lookup[v] = i
			process_object(v, exists)
		end
	end
	--[[@param object table]]
	--[[@param exists boolean?]]
	process_object = function(object, exists)
		for _, v in pairs(object) do process_value(v, exists) end
		local metatable = getmetatable(object)
		if type(metatable) == "table" then process_value(metatable, exists) end
	end
	process_object(world)
	do --[[remove nils from nested_objects]]
		local new_nested_objects = {}
		for j = 1, nested_object_count do
			local v = nested_objects[j]
			if v and nested_object_counts[v] > 1 then new_nested_objects[#new_nested_objects + 1] = v end
		end
		nested_objects = new_nested_objects
		--[[@diagnostic disable-next-line: cast-local-type]]
		nested_object_counts = nil
	end
	local nested_end = #nested_objects + 1
	nested_object_lookup = {} --[[update indices based on compacted array]]
	for i, v in ipairs(nested_objects) do nested_object_lookup[v] = nested_end - i end

	local on_write_table
	--[[@param v table]]
	--[[@param k string]]
	--[[@param data table]]
	on_write_table = function(v, k, data)
		local i = nested_object_lookup[v]
		if i then
			write("x[", i, "]")
			return
		end
		local new_self = data.self
		if k == mod.metatable_symbol then
			new_self = "getmetatable(" .. new_self .. ")"
		else
			local key = as_key(k)
			if key:byte(1) ~= 91 --[[ [ ]] then key = "." .. key end
			new_self = new_self .. key
		end
		write_object(v, write, on_write_table, { self = new_self })
	end

	write("return function(ctx)\n")
	write("\tlocal x = {}\n")
	for i = 1, #nested_objects do
		local rev_i = nested_end - i
		write("\tx[", i, "] = ")
		write_object(nested_objects[rev_i], write, on_write_table, { self = "x[" .. i .. "]" })
		write("\n")
	end
	write("\tctx.world = ")
	write_object(world, write, on_write_table, { self = "ctx.world" })
	write("\n")
	write("\treturn ctx\n")
	write("end\n")
	file:close()
end

--[[@param path string]]
--[[@param game world]]
--[[@param backup? boolean]]
mod.save = function(path, game, backup)
	if backup ~= false then
		local file = io.open(path)
		if file then
			file:close()
			assert(os.rename(path, path .. ".bak"))
		end
	end
	local success, err = pcall(mod.save_internal, path, game)
	if not success then
		os.remove(path)
		io.stderr:write(err, "\n")
	end
end

mod.new_game = function() return { objects = {} } end

local normalize_command = { x = "exit", h = "help" }

if pcall(debug.getlocal, 4, 1) then
	return mod
else
	local path = arg[1]
	local success, ctx = pcall(mod.load, path)
	if not success then
		if ctx:find("No such file or directory$") then
			local game = mod.new_game()
			mod.save(path, game)
			success, ctx = pcall(mod.load, path)
		else
			error(ctx)
		end
	end
	do
		local ui_renderer = os.getenv("TG_UI")
		if ui_renderer then ctx.ui = ui[ui_renderer] end
	end
	_G.pretty_print = pretty_print
	_G.ctx = ctx
	for k, v in pairs(ctx) do _G[k] = v end
	for k, v in pairs(ctx.world) do _G[k] = v end
	initialize_sandbox()
	while true do
		io.stdout:write("world> ")
		local input = tostring(io.stdin:read("line"))
		if input:byte(1) == 46 --[[.]] then
			input = input:sub(2)
			input = normalize_command[input] or input
			if input == "exit" then
				break
			elseif input == "help" then
				print([[
commands:
h, help - show this help screen
e, exit - exit the repl

lua context:
world - full state
  world.objects - list of objects
null - a non-nil "null" value, so that it shows up when iterating keys
save() - saves game to the path from which it was loaded]])
			else
				io.stderr:write("error: unknown command\n")
			end
		end
		if input:byte(1) == 59 --[[;]] then
			input = input:sub(2)
		else
			input = "return " .. input
		end
		local chunk, err = loadstring(input)
		if not chunk then
			io.stderr:write("error: invalid code: ", err, "\n")
		else
			local success2, ret = pcall(chunk)
			if not success2 then
				io.stderr:write("error: panic running code: ", ret, "\n")
			elseif ret ~= nil then
				pretty_print(ret, nil, 1)
				io.stdout:write("\n")
			end
		end
	end
end

--[[FIXME:
printf 'save()' | rlwrap luajit world.lua games/pterror.lua

this command causes the repl to enter an infinite loop
exiting on empty input is far from an ideal solution
]]
--[[TODO: test `a = {}; a.a = a; a.b = a` - esp. for objects]]
--[[
- future output formats:
	- qt? (needs to be able to run lua from qml)
		- i don't think this thing needs to access anything special so embedding luajit as a qt plugin should be enough
			- will be slow on mobile though
]]
--[[
next steps:
- player.room
- moving around rooms
- interacting with (mutating) rooms
- inventory
- eating
- verbs/cli
- wear and... unwear?
- objects with their own verbs (both local (`obj verb target` and `verb obj`) and global (`verb` and `verb target`))
]]
--[[
low priority (taking features from lambdamoo):
- permission controls - check for sandbox escapes
- hashing for passwords
- track number of objects created by each user
- track cycles used by functions
]]
--[[
low priority (other):
- regular backups to a different file
  - needs api support
- regular backups to git
]]

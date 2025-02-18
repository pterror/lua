local mod = {}

local maxint = 9007199254740992
local minint = -9007199254740992

local typeid = { ["nil"] = 1, boolean = 2, number = 3, string = 4, table = 5, ["function"] = 6, lightuserdata = 7, thread = 8 }
local sort_any_value = function(a, b)
	if type(a) ~= type(b) then
		return typeid[type(a)] < typeid[type(b)]
	elseif type(a) == "table" then
		return tostring(a) < tostring(b)
		-- it's possible to sort based on element but it's slow
		-- and this should have a consistent as long as the tables are created in the same order
	else
		return a < b
	end
end

local pretty_print_
local pretty_printers = {}
pretty_printers["nil"] = function(n, write) write(tostring(n)) end
pretty_printers.boolean = function(b, write) write(tostring(b)) end
pretty_printers.number = function(n, write)
	write((n % 1 == 0 and n >= minint and n <= maxint) and string.format("%d", n) or
		n)
end
pretty_printers.string = function(s, write)
	-- FIXME: proper string escape
	write("\"",
		s:gsub("[\"\n\r\t\v]", { ["\""] = "\\\"", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t", ["\v"] = "\\v" }),
		"\"")
end
pretty_printers["function"] = function(_, write) write("<function>") end -- TODO: yucky, replace with string.dump and loadstring(f, "b")
pretty_printers.lightuserdata = function(_, write) write("<lightuserdata>") end
pretty_printers.thread = function(_, write) write("<thread>") end
pretty_printers.cdata = function(_, write) write("<cdata>") end
pretty_printers.userdata = function(_, write) write("<userdata>") end
pretty_printers.table = function(t, write, seen)
	seen[t] = true
	do
		local mt = getmetatable(t)
		local tostring = mt and mt.__tostring
		if tostring and type(tostring) == "function" then
			write(tostring(t)); return
		end
	end
	if t.__keyorder then
		local not_first = false
		for _, k in ipairs(t.__keyorder) do
			write(not_first and ", " or "{ ")
			if type(k) == "string" and k:find("^[_%a][_%w]*$") then
				write(k)
			else
				write("["); pretty_print_(k, write, true); write("]")
			end
			write(" = ")
			pretty_print_(t[k], write, true)
			not_first = true
		end
		write(not_first and " }" or "{}")
		return
	end
	local is_hash = false
	local max = #t
	for k in pairs(t) do
		if type(k) ~= "number" or k < 1 or k > max or k % 1 ~= 0 then
			is_hash = true; break
		end
	end
	if is_hash then
		local keys = {}
		for k in pairs(t) do keys[#keys + 1] = k end
		table.sort(keys, sort_any_value)
		local not_first = false
		for _, k in ipairs(keys) do
			write(not_first and ", " or "{ ")
			if type(k) == "string" and k:find("^[_%a][_%w]*$") then
				write(k)
			else
				write("["); pretty_print_(k, write, true); write("]")
			end
			write(" = ")
			pretty_print_(t[k], write, true, nil, seen)
			not_first = true
		end
		write(not_first and " }" or "{}")
	else
		local not_first = false
		for i = 1, max do
			write(not_first and ", " or "{ ")
			pretty_print_(t[i], write, true, nil, seen)
			not_first = true
		end
		write(not_first and " }" or "{}")
	end
end

--[[@param opts? { no_trailing_newline: boolean; no_print_nil: boolean; }]]
--[[@param seen? table<unknown,true>]]
pretty_print_ = function(value, write, not_top_level, opts, seen)
	write = write or io.write
	seen = seen or {}
	if seen[value] then
		io.write("<circular>"); return
	end
	opts = opts or {}
	if not not_top_level then
		if type(value) == "string" then
			io.write(value, "\n"); return
		elseif value == nil and opts.no_print_nil then
			return
		end
	end
	pretty_printers[type(value)](value, write, seen)
	if not not_top_level and not opts.no_trailing_newline then io.write("\n") end
end
mod.uneval = function(value)
	local parts = {} --[[@type string[] ]]
	local write = function(part) parts[parts + 1] = part end
	pretty_print_(value, write, true)
end
mod.pretty_print = function(...)
	local count = select("#", ...)
	if count == 1 then
		pretty_print_(select(1, ...), io.write)
	else
		if count > 1 then pretty_print_(select(1, ...), io.write, true) end
		for i = 2, count do
			io.write(" ")
			pretty_print_(select(i, ...), io.write, true)
		end
		io.write("\n")
	end
end

return mod

local mod = {}

local maxint = 9007199254740992
local minint = -9007199254740992

local typeid = { ["nil"] = 1, boolean = 2, number = 3, string = 4, table = 5, ["function"] = 6, lightuserdata = 7, thread = 8 }
local sort_any_value = function (a, b)
	if type(a) ~= type(b) then return typeid[type(a)] < typeid[type(b)]
	elseif type(a) == "table" then return tostring(a) < tostring(b)
		-- it's possible to sort based on element but it's slow
		-- and this should have a consistent as long as the tables are created in the same order
	else return a < b end
end

local pretty_print_
local pretty_printers = {}
pretty_printers["nil"] = function () io.write(tostring(nil)) end
pretty_printers.boolean = function (b) io.write(tostring(b)) end
pretty_printers.number = function (n) io.write((n % 1 == 0 and n >= minint and n <= maxint) and string.format("%d", n) or n) end
pretty_printers.string = function (s) io.write("\"", s:gsub("[\"\n\r\t\v]", { ["\""] = "\\\"", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t", ["\v"] = "\\v" }), "\"") end -- FIXME: proper string escape
pretty_printers["function"] = function ()  io.write("<function>") end -- TODO: yucky, replace with string.dump and loadstring(f, "b")
pretty_printers.lightuserdata = function () io.write("<lightuserdata>") end
pretty_printers.thread = function () io.write("<thread>") end
pretty_printers.cdata = function () io.write("<cdata>") end
pretty_printers.userdata = function () io.write("<userdata>") end
pretty_printers.table = function (t, seen)
	seen[t] = true
	do
		local mt = getmetatable(t)
		local tostring = mt and mt.__tostring
		if tostring and type(tostring) == "function" then io.write(tostring(t)); return end
	end
	if t.__keyorder then
		local not_first = false
		for _, k in ipairs(t.__keyorder) do
			io.write(not_first and ", " or "{ ")
			if type(k) == "string" and k:find("^[_%a][_%w]*$") then
				io.write(k)
			else
				io.write("["); pretty_print_(k, true); io.write("]")
			end
			io.write(" = ")
			pretty_print_(t[k], true)
			not_first = true
		end
		io.write(not_first and " }" or "{}")
		return
	end
	local is_hash = false
	local max = #t
	for k in pairs(t) do if type(k) ~= "number" or k < 1 or k > max or k % 1 ~= 0 then is_hash = true; break end end
	if is_hash then
		local keys = {}
		for k in pairs(t) do keys[#keys+1] = k end
		table.sort(keys, sort_any_value)
		local not_first = false
		for _, k in ipairs(keys) do
			io.write(not_first and ", " or "{ ")
			if type(k) == "string" and k:find("^[_%a][_%w]*$") then
				io.write(k)
			else
				io.write("["); pretty_print_(k, true); io.write("]")
			end
			io.write(" = ")
			pretty_print_(t[k], true, nil, seen)
			not_first = true
		end
		io.write(not_first and " }" or "{}")
	else
		local not_first = false
		for i = 1, max do
			io.write(not_first and ", " or "{ ")
			pretty_print_(t[i], true, nil, seen)
			not_first = true
		end
		io.write(not_first and " }" or "{}")
	end
end

--[[@param opts? { no_trailing_newline: boolean; no_print_nil: boolean; }]]
--[[@param seen? table<unknown,true>]]
pretty_print_ = function (value, not_top_level, opts, seen)
	seen = seen or {}
	if seen[value] then io.write("<circular>"); return end
	opts = opts or {}
	if not not_top_level then
		if type(value) == "string" then io.write(value, "\n"); return
		elseif value == nil and opts.no_print_nil then return end
	end
	pretty_printers[type(value)](value, seen)
	if not not_top_level and not opts.no_trailing_newline then io.write("\n") end
end
mod.pretty_print = function (...)
	local count = select("#", ...)
	if count == 1 then pretty_print_(select(1, ...))
	else
		if count > 1 then pretty_print_(select(1,  ...), true) end
		for i = 2, count do
			io.write(" ")
			pretty_print_(select(i, ...), true)
		end
		io.write("\n")
	end
end

return mod

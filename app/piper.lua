#!/usr/bin/env luajit
-- syntax:
-- _ to delimit functions in a pipe
-- %% to delimit pipes in a program
-- [ ] to delimit nested pipes
-- [[ ]] to delimit... something idk
-- [f ] to delimit function literals
-- @ to denote where the previous argument goes
-- :var at the beginning of a pipe to assign the pipe (not the result) to a name
-- :var anywhere else to use the variable

-- TODO: like pairs or something. for e.g. pairwise deltas
-- 1 2 3 4 5 -> {1 2} {2 3} {3 4} {4 5}

-- TODO: function to write to file
-- TODO: other stuff like json, csv, toml, json5 etc
-- TODO: dns etc
-- TODO: maybe an iterator based http server? is that even possible?
-- TODO: touch, mkdir, rm, rmdir, rm -r, grep (filter) and stuff
-- TODO: ansi colors?
-- TODO: variables?
-- TODO: grep - but lua doesn't have regex
-- TODO: unit conversion??

-- LINT: warn when using unassigned variable

local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local dummy_file = assert(io.open("."))
local file_mt = getmetatable(dummy_file)
dummy_file:close()

local json_null = {}

-- TODO: consider just wrapping stateless iterators in stateful iterators instead
--[[@class iterator<state, control, t>: { fn: fun(state: state, control: control): t; state: state; control: control; next: fun(self: iterator<state, control, t>): t }]]
local iterator = {}
--[[@generic state, control, t]]
--[[@return t]]
--[[@param self iterator<state, control, t>]]
iterator.next = function (self)
	local ret = { self.fn(self.state, self.control) }
	self.control = ret[1]
	return unpack(ret) -- this is slow
end
iterator.__index = iterator
iterator.__call = iterator.next -- should be `self:next()` so it works fine even when subclassed
-- but we're inlining because why not
--- @generic state, control, t
--- @return iterator<state, control, t>
--- @param self iterator
--- @param fn fun(state: state, control: control): t
--- @param state? state
--- @param control? control
iterator.new = function (self, fn, state, control)
	return setmetatable({
		fn = fn, state = state, control = control
	}, self)
end
--- @param x unknown
local is_iterator = function (x) return getmetatable(x) == iterator end

--- @class argref
local argref = {}
argref.__index = argref
argref.new = function (self, i)
	return setmetatable({ i = i }, self)
end
--- @param x unknown
local is_argref = function (x) return getmetatable(x) == argref end

local maxint = 9007199254740992
local minint = -9007199254740992
--- @param n number
local trunc = function (n) return (n >= 0 and math.floor or math.ceil)(n) end
--- @param ... number
local prod = function (...)
	local ret = 1
	for _, n in ipairs({ ... }) do ret = ret * n end
	return ret
end
--- @param ... number
local sum = function (...)
	local ret = 0
	for _, n in ipairs({ ... }) do ret = ret + n end
	return ret
end

-- TODO: variables like pi and e

local yes_iter = function () return true end
--- @param self file*
local filelines_iter = function (self)
	return self:read("*line")
end
--- @class seq_state
--- @field step integer
--- @field end_ integer
--[[@param self seq_state]] --[[@param curr integer]]
local seq_iter = function (self, curr)
	if curr == nil then return end
	curr = curr + self.step
	if curr > self.end_ then return nil end
	return curr
end
--[[@param self seq_state]] --[[@param curr integer]]
local seq_iter_neg = function (self, curr)
	if curr == nil then return end
	curr = curr + self.step
	if curr < self.end_ then return nil end
	return curr
end
--[[@param iter iterator]] --[[@param count integer]]
local skip = function (iter, count)
	for _ = 1, count do
		local value = iter:next()
		if not value then return end -- TODO: functions accepting ???
	end
	return iter
end
--[[@param iter iterator]]
local itercount = function (iter)
	local count = 0
	while iter:next() do count = count + 1 end
	return count
end

local arr_iter = function (self)
	if self.i > #self.array then return end
	self.i = self.i + 1
	return self.array[self.i]
end
--[[@generic t]]
--[[@return iterator<unknown, nil, t>]]
--[[@param array t[] ]]
local arriter = function (array)
	return iterator:new(arr_iter, { array = array, i = 0 })
end

-- it must somehow have the inner iterator and the end number as nested state
-- could just do { fn = fn, state = s, end_ = end_ }
-- might be slow af tho
local firstn_iter = function (self)
	if self.count == 0 then return end
	self.count = self.count - 1
	return self.iter:next()
end
--[[@generic t]]
--[[@return iterator<unknown, nil, t>]]
--[[@param iter iterator<unknown, unknown, t>]]
--[[@param count integer]]
local firstn = function (iter, count)
	return iterator:new(firstn_iter, { iter = iter, count = count })
end

local lastn_iter = function (self)
	if self.i == self.end_ then return end
	self.i = self.i + 1
	if self.i > self.count then self.i = 1 end
	return self.items[self.i]
end
--[[@generic t]]
--[[@return iterator<unknown, nil, t>]]
--[[@param iter iterator<unknown, unknown, t>]]
--[[@param count integer]]
local lastn = function (iter, count)
	local i = 1
	local items = {}
	local filled = false
	while true do
		local item = iter:next()
		if not item then break end
		items[i] = item
		i = i + 1
		if i > count then filled = true; i = 1 end
	end
	if not filled then return arriter(items) end
	return iterator:new(lastn_iter, { iter = iter, count = count, i = i, end_ = i - 1 })
end

-- for x in iter.next, iter do thing() end
-- could be used for unified iterator and array handling
-- wouldn't work for regular iterators and arrays of course

local strsplit_iter = function (self)
	if self.i > #self.string then return end
	local start, end_ = string.find(self.string, self.separator, self.i, true)
	start = start or #self.string + 1
	local ret = self.string:sub(self.i, start - 1)
	self.i = (end_ or #self.string) + 1
	return ret
end
local split = function (s, sep)
	return iterator:new(strsplit_iter, { string = s, i = 1, separator = sep })
end

local join = function (iter, sep)
	local parts = {}
	local v = iter:next()
	while v do
		parts[#parts+1] = v
		v = iter:next()
	end
	return table.concat(parts, sep)
end

local base_alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
local base_alphabet_rev = {}
for i = 1, #base_alphabet do
	base_alphabet_rev[base_alphabet:byte(i)] = i - 1
end

--[[@param n integer]] --[[@param base integer]]
local tobase = function (n, base)
	local negative_sign = ""
	if n < 0 then negative_sign = "-"; n = -n end
	if n % 1 ~= 0 then return error("error: `tobase` cannot handle decimals") end
	local parts = {}
	if n == 0 then parts[#parts+1] = "0" end
	while n > 0 do
		local i = n % base + 1
		--- @diagnostic disable-next-line: param-type-mismatch
		parts[#parts+1] = base_alphabet:sub(i, i)
		n = math.floor(n / base)
	end
	return negative_sign .. table.concat(parts):reverse()
end

--[[@param s string]] --[[@param base integer]]
local frombase = function (s, base)
	local start = 1
	local sign = 1
	local n = 0
	if s:byte(start) == 0x2d --[[-]] then sign = -1; start = start + 1
	elseif s:byte(start) == 0x2b --[[+]] then start = start + 1 end
	for i = start, #s do
		local digit = base_alphabet_rev[s:byte(i)]
		if not digit or digit >= base then return error("error: invalid digit for `tobase`: '" .. s:sub(i, i) .. "'") end
		n = n * base + digit
	end
	return n * sign
end

local fold = function (iter, fn, ret)
	for x in iter.next, iter do ret = fn(ret, x) end
	return ret
end
local fold1 = function (iter, fn)
	local ret = iter:next()
	for x in iter.next, iter do ret = fn(ret, x) end
	return ret
end

local arrfold = function (arr, fn, ret)
	for i = 1, #arr do ret  = fn(ret, arr[i]) end
	return ret
end
local arrfold1 = function (arr, fn)
	local ret = arr[1]
	for i = 2, #arr do ret  = fn(ret, arr[i]) end
	return ret
end

local map_iter = function (self)
	local value = self.iter:next()
	if value ~= nil then return self.fn(value) end
end
local map = function (iter, fn)
	return iterator:new(map_iter, { iter = iter, fn = fn })
end

local flatmap_iter = function (self)
	if self.done then return end
	if not self.inner_iter then
		local next = self.iter:next()
		if not next then return nil end
		self.inner_iter = self.fn(next)
		if not self.inner_iter then return nil end
	end
	local vals = { self.inner_iter:next() }
	while vals[1] == nil do
		local next = self.iter:next()
		if not next then return nil end
		self.inner_iter = self.fn(next)
		if not self.inner_iter then self.done = true; return nil end
		vals = { self.inner_iter:next() }
	end
	return unpack(vals)
end
local flatmap = function (iter, fn)
	return iterator:new(flatmap_iter, { iter = iter, inner_iter = nil, fn = fn, done = false })
end

local filter_iter = function (self)
	local pred = self.fn
	local iter = self.iter
	local vals = { iter:next() } -- repack/unpack
	if not vals then return nil end
	while vals[1] do
		if pred(vals[1]) then
			return unpack(vals)
		end
		vals = { iter:next() }
	end
	return nil
end
local filter = function (iter, fn)
	return iterator:new(filter_iter, { iter = iter, fn = fn })
end

local iter2arr = function (iter)
	local arr = {}
	while true do local val = iter:next(); if val then arr[#arr+1] = val else break end end
	return arr
end

local reversers = {}
reversers.string = function (s) return string.reverse(s) end
reversers.table = function (a)
	local lenp1 = #a + 1
	local ret = {}
	for i = 1, lenp1 - 1 do
		ret[lenp1 - i] = a[i]
	end
	return ret
end
local reverse = function (x) return reversers[type(x)](x) end

local newline_fn = function () return "\n" end

local strrepeat = function (s, n) return string.rep(s, n) end

local repeat_iter = function (self, value)
	if self.count <= 0 then return end
	self.count = self.count - 1
	return value
end
local repeat_ = function (value, count)
	return iterator:new(repeat_iter, { count = count }, value)
end

local epoll, await, futurify, set_timeout, sleepms

local init_sleep = function ()
	if sleepms then return end
	epoll = epoll or require("dep.epoll"):new()
	await = await or require("lib.async").await
	futurify = futurify or require("lib.async").futurify
	set_timeout = set_timeout or require("dep.timerfd").set_timeout
	sleepms = futurify(function (ms, cb) set_timeout(epoll, ms, cb) end)
end

local iter_wrapped
do
	local iter_wrapped_cache = setmetatable({}, { __mode = "k" })
	iter_wrapped = function (fn)
		local cached = iter_wrapped_cache[fn]
		if cached then return cached end
		local wrapped = function (...)
			local ret = { fn(...) }
			if not ret[1] then error(ret[2]) end
			return iterator:new(unpack(ret))
		end
		iter_wrapped_cache[fn] = wrapped
		return wrapped
	end
end

local dir_list
local get_dir_list = function ()
	if not dir_list then
		local inner = require("lib.fs.dir_list").dir_list
		dir_list = function (path)
			local fn, s, c = inner(path or ".")
			if not fn then error(s) end
			return iterator:new(fn, s, c)
		end
	end
	return dir_list
end

local strlines = function (s) return iterator:new(string.gmatch(s, "%S+")) end

local filelines = function (path)
	-- note that dispatching based on type is non-standard
	-- this api should go. instead maybe have `file foo.bar _ filelines`
	return iterator:new(filelines_iter, getmetatable(path) == file_mt and path or io.open(path, "r"))
end

local fileread = function (path)
	if getmetatable(path) == file_mt then
		return path:read("*all")
	else
		local file = assert(io.open(path, "rb"), "fileread: could not open file")
		local contents = file:read("*all")
		file:close()
		return contents
	end
end

local filewrite = function (contents, path)
	if getmetatable(path) == file_mt then
		return assert(path:write(contents), "filewrite: could not write to file")
	else
		assert(
			assert(io.open(path, "wb"), "filewrite: could not open file: " .. path):write(contents),
			"filewrite: could not write to file: " .. path
		):close()
	end
end

local filetouch = function (path)
	if getmetatable(path) == file_mt then
		-- FIXME
	else
		assert(
			assert(io.open(path, "a+b"), "filetouch: could not open file: " .. path):write(),
			"filetouch: could not touch file: " .. path
		):close()
	end
end

local args2arr = function (...) return { ... } end
local args2dict = function (...)
	local kvs = { ... }
	local ret = {}
	for i = 1, #kvs - 1, 2 do ret[kvs[i]] = kvs[i + 1] end
	return ret
end

local strslice = function (s, i, j) return s:sub(i, j) end
local strfirstn = function (s, n) return s:sub(1, n) end
local strlastn = function (s, n) return s:sub(math.max(1, #s - n + 1), #s) end
local strskipfirstn = function (s, n) return s:sub(n + 1, #s) end
local strskiplastn = function (s, n) return s:sub(1, math.max(0, #s - n)) end

local strtr = function (s, from, to)
	local n = math.min(from, to)
	local parts = {"["}
	for i = 1, n do
		parts[#parts+1] = from[i]
	end
	parts[#parts+1] = "]"
	local pattern = "[" .. table.concat(parts) .. "]"
	local replacements = {}
	for i = 1, n do replacements[from:sub(i, i)] = to:sub(i, i) end
	return string.gsub(s, pattern, replacements)
end

local kvs2dict = function (iter)
	local obj = {}
	local kv = iter:next()
	while kv do
		obj[kv[1]] = kv[2]
		kv = iter:next()
	end
	return obj
end

local keyorder_iter = function (self)
	local next = self.iter:next()
	if not next then return end
	next.__keyorder = self.keyorder
	return next
end

local typeid = { ["nil"] = 1, boolean = 2, number = 3, string = 4, table = 5, ["function"] = 6, lightuserdata = 7, thread = 8 }
local sort_any_value = function (a, b)
	if type(a) ~= type(b) then return typeid[type(a)] < typeid[type(b)]
	elseif type(a) == "table" then return tostring(a) < tostring(b)
		-- it's possible to sort based on element but it's slow
		-- and this should have a consistent as long as the tables are created in the same order
	else return a < b end
end

local fmttable = function (t)
	if type(t) ~= "table" then return end
	if #t == 0 then return "" end
	local keyorder = t[1].__keyorder
	if not keyorder then
		-- assume first object has all keys
		keyorder = {}
		for k in pairs(t[1]) do keyorder[#keyorder+1] = k end
		table.sort(keyorder, sort_any_value)
	end
	local column_lengths = {}
	for i = 1, #keyorder do column_lengths[i] = #tostring(keyorder[i]) end
	for _, elem in ipairs(t) do
		for j = 1, #keyorder do
			column_lengths[j] = math.max(column_lengths[j], #tostring(elem[keyorder[j]]))
		end
	end
	local total_length = 0
	for _, len in ipairs(column_lengths) do total_length = total_length + len end
	local format do
		local column_formats = {}
		for i = 1, #column_lengths do
			column_formats[i] = ("%%-%ds"):format(column_lengths[i] + 1)
		end
		format = table.concat(column_formats)
	end
	local keyorder_strings = {}
	for i = 1, #keyorder do keyorder_strings[i] = tostring(keyorder[i]) end
	local parts = {
		format:format(unpack(keyorder_strings)),
		("-"):rep(total_length),
	}
	for _, elem in ipairs(t) do
		local columns = {}
		for j = 1, #keyorder do columns[j] = elem[keyorder[j]] end
		parts[#parts+1] = format:format(unpack(columns))
	end
	return table.concat(parts, "\n")
end

local fns_keys = {}

local fns

local lazy_by_module = {}

local lazy = {}
lazy.__index = lazy
--- @param key string
--- @param module string?
--- @param load fun(): function
lazy.new = function (self, key, module, load)
	if module then
		lazy_by_module[module] = lazy_by_module[module] or {}
		lazy_by_module[module][key] = load
	end
	return setmetatable({
		key = key, module = module, load_ = load
	}, self)
end
lazy.load = function (self)
	local lbm = lazy_by_module[self.module]
	if lbm then
		lbm[self.key] = nil
		for key2, load2 in pairs(lbm) do
			fns[key2] = load2()
			lbm[key2] = nil
		end
	end
	fns[self.key] = self.load_()
	return fns[self.key]
end
lazy.alias = function (self, key)
	return lazy:new(key, self.module, self.load_)
end
local is_lazy = function (x) return getmetatable(x) == lazy end

fns = {
	fns = function (prefix)
		if not prefix then return arriter(fns_keys) end
		local prefix_len = #prefix
		return filter(arriter(fns_keys), function (s)
			return string.sub(s, 1, prefix_len) == prefix
		end)
	end,
	help = function ()
		-- TODO: help for each function? extra info should be provided by the functions themselves
		return [[
execute `fns` for a list of functions
usage:
		~/piper piper _ code _ here
syntax:
		pipe output from one function to another
									v          v
fn arg1 arg2 arg3 _  fn2 arg4 _ fn3 @ arg5
												^           ^
		result of previous function inserted here

		vv separates two statements. the left pipe runs, then the right pipe runs
fn1 $$ fn2  1 2 3 n@10    foo bar baz s@asdf  f@x
						^ ^ ^  ^       ^   ^   ^    ^      ^
						numbers       these are strings   function reference]]
	end,

	echo = function (...) return table.concat({ ... }, " ") end,
	str = tostring,
	num = function (n) return tonumber(n) end, -- to prevent `tonumber(n, base)`

	-- FIXME: remove aliases 
	args2arr = args2arr,
	args2dict = args2dict,
	args2iter = function (...) return arriter({ ... }) end,
	iter2arr = iter2arr, i2a = iter2arr,
	arr2iter = arriter, a2i = arriter,
	kvs2dict = kvs2dict, k2d = kvs2dict,

	["."] = function (obj, ...)
		for _, seg in ipairs({ ... }) do obj = obj[seg] end
		return obj
	end,

	-- FIXME: the shell must be wrapped in async for this to work.
	-- wait for process spawn first?
	sleep = lazy:new("sleep", "dep.epoll", function ()
		init_sleep()
		return function (s) await(sleepms(s * 1000)) end
	end),
	sleepms = lazy:new("sleepms", "dep.epoll", function ()
		init_sleep()
		return function (ms) await(sleepms(ms)) end
	end),

	id = function (x) return x end, -- doesn't need to be wrapped
	keyorder = function (iter, ...)
		if is_iterator(iter) then
			return iterator:new(keyorder_iter, { iter = iter, keyorder = { ... } })
		else
			iter.__keyorder = { ... }
			return iter
		end
	end,

	-- TODO: these still need to be wrapped for args?
	strlines = strlines,
	inlines = function () return filelines(io.stdin) end,
	inread = function () return io.stdin:read("*all") end,
	outwrite = function (s) return io.stdout:write(s) end,
	filelines = filelines, cat = filelines, -- TODO: cat actually concatenates files...
	fileread = fileread, read = fileread,
	filewrite = filewrite, write = filewrite,
	filetouch = filetouch, touch = filetouch,
	fileremove = os.remove, remove = os.remove, filerm = os.remove, rm = os.remove,
	diritems = lazy:new("diritems", "lib.fs.dir_list", get_dir_list),
	skip = skip,

	-- TODO: polymorphic slice etc
	-- sub may be confused with substitute
	strslice = strslice,
	strfirstn = strfirstn,         strleft = strfirstn,
	strlastn = strlastn,           strright = strlastn,
	strskipfirstn = strskipfirstn, trimleft = strskipfirstn,
	strskiplastn = strskiplastn,   trimright = strskiplastn,
	strtr = strtr,                 tr = strtr,

	firstn = firstn,
	--[[@generic s, c, t]]
	--[[@return t]]
	--[[@param iter iterator<s, c, t>]]
	first = function (iter) return iter:next() end,
	lastn = lastn,
	--- @generic s, c, t
	--- @param iter iterator<s, c, t>
	--- @return t
	last = function (iter)
		local last
		while true do
			local curr = iter:next()
			if not curr then return last end
			last = curr
		end
	end,
	yes = function () return iterator:new(yes_iter) end, --- @return iterator<true, nil, nil>

	-- TODO: figure out what to do wrt polymorphism
	-- fewer functions = better
	-- polymorphic functions = slow
	-- but also does perf really matter
	-- TODO: remove funny bash aliases
	fold1 = fold1,
	arrfold1 = arrfold1,
	fold = fold,
	arrfold = arrfold,
	map = map, f = map,
	flatmap = flatmap,
	-- FIXME: arrflatmap = arrflatmap,
	filter = filter,
	-- FIXME: arrfilter = arrfilter,
	itercount = itercount,

	table = fmttable, fmttable = fmttable, formattable = fmttable,

	-- TODO: should it automatically detect backwards seqs
	seq = function (start, step, end_)
		if not step then start, step, end_ = 1, 1, start
		elseif not end_ then start, step, end_ = start, 1, step end
		if step > 0 then
			-- start - step may potentially under/overflow. but idk a better alternative
			return iterator:new(seq_iter, { end_ = end_, step = step }, start - step)
		else
			return iterator:new(seq_iter_neg, { end_ = end_, step = step }, start - step)
		end
	end,

	call = function (fn, ...) return fn(...) end,

	split = split, strsplit = split,
	join = join, strjoin = join,
	strrev = reversers.string,
	arrrev = reversers.table,
	rev = reverse,
	rep = repeat_,
	strrep = strrepeat,
	-- TODO: chunks and stuff
	-- TODO: polymorphic +?
	["str+"] = function (...) return table.concat({ ... }) end,

	mean = function (...)
		local ns = { ... }
		local sum_ = 0
		for _, n in ipairs(ns) do sum_ = sum_ + n end
		return sum_ / #ns
	end,
	geomean = function (...)
		local ns = { ... }
		local geomean = 1
		local pow = 1 / #ns
		for _, n in ipairs(ns) do geomean = geomean * math.pow(n, pow) end
		return geomean
	end,
	rms = function (...)
		local ns = { ... }
		local sum_ = 0
		for _, n in ipairs(ns) do sum_ = sum_ + n * n end
		return math.sqrt(sum_ / #ns)
	end,

	x = prod,
	["/"] = function (a, b) return a / b end,
	["//"] = function (a, b) return trunc(a / b) end,
	["+"] = sum,
	["-"] = function (a, b) return a - b end,
	["^"] = function (a, b) return a ^ b end,
	["%"] = function (a, b) return a % b end,

	["gt"] = function (a, b) return a > b end,
	["ge"] = function (a, b) return a >= b end,
	["lt"] = function (a, b) return a < b end,
	["le"] = function (a, b) return a <= b end,
	["eq"] = function (a, b) return a == b end,
	["ne"] = function (a, b) return a ~= b end,

	bitand = bit.band,
	bitor = bit.bor,
	bitxor = bit.bxor,
	bitnot = bit.bnot,
	byterev = bit.bswap,
	bitrshift = bit.rshift,
	bitarshift = bit.arshift,
	bitlshift = bit.lshift,
	bitrol = bit.rol,
	bitror = bit.ror,

	["or"] = function (...)
		local or_ = false
		for _, b in ipairs({ ... }) do
			or_ = or_ or b
			if or_ then return or_ end
		end
		return or_
	end,
	["and"] = function (...)
		local and_ = true
		for _, b in ipairs({ ... }) do
			and_ = and_ and b
			if not and_ then return and_ end
		end
		return and_
	end,

	["if"] = function (cond, if_true, if_false)
		if cond then return if_true()
		else return if_false() end
	end,

	abs = math.abs,
	sqrt = math.sqrt,
	hypot = function (a, b) return math.sqrt(a * a + b * b) end,
	floor = math.floor,
	ceil = math.ceil,
	trunc = trunc,

	pow = math.pow,
	sin = math.sin,
	cos = math.cos,
	tan = math.tan,
	sinh = math.sinh,
	cosh = math.cosh,
	tanh = math.tanh,
	asin = math.asin,
	acos = math.acos,
	atan = math.atan,
	atan2 = math.atan2,

	log = math.log,
	log10 = math.log10,
	exp = math.exp,

	bin = function (n) return tobase(n, 2) end, --- @param n integer
	oct = function (n) return tobase(n, 8) end, --- @param n integer
	hex = function (n) return tobase(n, 16) end, --- @param n integer
	unbin = function (s) return frombase(s, 2) end, --- @param s string
	unoct = function (s) return frombase(s, 8) end, --- @param s string
	unhex = function (s) return frombase(s, 16) end, --- @param s string
	frombase = function (s, base) return frombase(s, base) end, --[[@param s string]] --[[@param base integer]]
	tobase = tobase,

	newline = newline_fn, nl = newline_fn,
	jsonnull = function () return json_null end,

	-- TODO: functions lazily importing libraries
	tojson = lazy:new("tojson", "dep.lunajson", function ()
		local fn = require("dep.lunajson").value_to_json
		return function (value) return fn(value, json_null) end
	end),
	fromjson = lazy:new("fromjson", "dep.lunajson", function ()
		local fn = require("dep.lunajson").json_to_value
		return function (json) return fn(json, nil, json_null) end
	end),
	httpstatic = lazy:new("httpstatic", nil, function () return package.loaders[2]("app.http_static") end),
	ple = lazy:new("ple", nil, function () return package.loaders[2]("app.ple") end),
	tcp_client = lazy:new("tcp_client", nil, function () return package.loaders[2]("app.tcp_client") end),
	make = lazy:new("make", nil, function () return package.loaders[2]("app.make") end),
}
if true --[[linux_aliases - TODO: refactor out]] then
	fns.head = fns.firstn
	fns.tail = fns.lastn
	fns.strhead = fns.strfirstn
	fns.strtail = fns.strlastn
	fns.ls = lazy:new("ls", nil, function ()
		local diritems = fns.diritems
		if is_lazy(diritems) then diritems = diritems:load() end
		return function (path)
			return map(diritems(path), function (x) return x.name end)
		end
	end)
end

do
	for k in pairs(fns) do fns_keys[#fns_keys+1] = k end
	table.sort(fns_keys)
end

local eval = function (functions, compile_only, ignore_control_flow)
	if ignore_control_flow then return functions[1] end
	local prev = compile_only and {} or nil
	local is_first = not compile_only
	local compiled = compile_only and {}
	for _, fn_and_args in ipairs(functions) do
		local fn_name = fn_and_args[1]
		if type(fn_name) ~= "string" then return nil, "invalid function name: " .. tostring(fn_name) end
		--- @type function
		--- @diagnostic disable-next-line: assign-type-mismatch
		local fn = fns[fn_name]
		if not fn then return nil, "unknown function: " .. fn_name end
		if is_lazy(fn) then fn = fn:load() end
		local args = {}
		local prev_inserted = false
		-- TODO: inject previous into args
		for i = 2, #fn_and_args do
			local arg2 = fn_and_args[i]
			if not is_first and (arg2 == "@" or arg2 == "@1") then
				-- consider warning when seeing 2 or more @
				prev_inserted = true
				args[i - 1] = prev
			else
				-- TODO: @2 etc
				args[i - 1] = arg2
			end
		end
		if not is_first and not prev_inserted then
			table.insert(args, 1, prev)
		end
		if compile_only then
			compiled[#compiled+1] = function (...)
				local has_args = select("#", ...) > 0
				local gi = 1
				local args2 = {}
				local i = 1
				for _, arg2 in ipairs(args) do
					if arg2 == prev then
						if has_args then
							args2[i] = select(gi, ...)
							-- TODO: @ @ @1 @2 etc
							gi = gi + 1
							i = i + 1
						end
					else args2[i] = arg2; i = i + 1 end
				end
				-- TODO: pcall here so users know what function went wrong
				return fn(unpack(args2))
			end
		else
			-- TODO: pcall here
			prev = fn(unpack(args))
		end
		is_first = false
	end
	return compile_only and function (...)
		local rets = { ... }
		-- LINT: doesn't warn on `for _ in table`
		for _, fn in ipairs(compiled) do rets = { fn(unpack(rets)) } end
		return unpack(rets)
	end or prev
end

local pretty_print
local pretty_printers = {}
pretty_printers["nil"] = function () io.write("nil@") end
pretty_printers.boolean = function (b) io.write(b and "true@" or "false@") end
pretty_printers.number = function (n) io.write((n % 1 == 0 and n >= minint and n <= maxint) and string.format("%d", n) or n) end
--- @param s string
-- TODO: a more comprehensive... string stringifier?
pretty_printers.string = function (s) io.write(tonumber(s) and ("s@" .. s) or s:find(" ") and ("'" .. s:gsub("'", "'\"'\"'") .. "'") or s) end
pretty_printers["function"] = function () io.write("<function>") end -- yucky but oh well what can we do
pretty_printers.lightuserdata = function () io.write("<lightuserdata>") end
pretty_printers.thread = function () io.write("<thread>") end
pretty_printers.table = function (t)
	if t.__keyorder then
		local not_first = false
		for _, k in ipairs(t.__keyorder) do
			io.write(not_first and "   " or "[d ")
			pretty_print(k, true); io.write(" "); pretty_print(t[k], true)
			not_first = true
		end
		io.write(" ]")
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
			io.write(not_first and "   " or "[d ")
			pretty_print(k, true); io.write(" "); pretty_print(t[k], true)
			not_first = true
		end
		io.write(" ]")
	else
		io.write("[a")
		for i = 1, max do
			io.write(" ")
			pretty_print(t[i], true)
		end
		io.write(" ]")
	end
end
pretty_print = function (value, not_top_level)
	if not not_top_level then
		if type(value) == "string" then print(value); return
		elseif value == nil then return end
	end
	pretty_printers[type(value)](value)
	if not not_top_level then io.write("\n") end
end

local converters = {
	f = function (s) return fns[s] or error("function not found: " .. s) end,
	-- technically not necessary; however may be useful in the future in case auto-number is disabled
	n = function (s) return tonumber(s) or error("invalid number: " .. s) end,
	s = function (s) return s end,
	["true"] = function () return true end,
	["false"] = function () return false end,
	["nil"] = function () return nil end,
	c = function () end, -- comment
}

local array_converters = {
	-- f for function is specialcased since it follows control flow
	a = function (items) return items end,
	d = function (kvs)
		local ret = {}
		for i = 1, #kvs - 1, 2 do ret[kvs[i]] = kvs[i + 1] end
		return ret
	end,
	c = function () end, -- comment
}

local process
process = function (i, compile_only, ignore_control_flow)
	local functions = {}
	local fn = {}
	while i <= #arg do
		local s = arg[i]
		if s == "%%" then
			if ignore_control_flow then fn[#fn+1] = "%"; i = i + 1
			else return i + 1, eval(functions, compile_only, ignore_control_flow) end
		elseif s == "_" then
			-- LINT: should disallow setting a variable to itself
			-- also using a variable in its own declaration, assuming it's not a function
			-- i'm assuming functions can access themselves? but it might refer to a previous declaration or global if it exists??
			if ignore_control_flow then fn[#fn+1] = "_"
			else
				if #fn == 0 then error("empty pipe segment - make sure you are not doing `_ _`.") end
				functions[#functions+1], fn = fn, {}
			end
			i = i + 1
		elseif s == "[" then
			local last_arg_n = #fn+1
			i, fn[last_arg_n] = process(i + 1)
			while arg[i - 1] == "%%" do
				i, fn[last_arg_n] = process(i)
			end
		elseif s == "]" then
			if #fn > 0 then functions[#functions+1] = fn end
			return i + 1, eval(functions, compile_only, ignore_control_flow)
		elseif s == "[f" then -- TODO: user-defined array converters
			-- note that `f@[` would be more consistent but fish doesn't like it
			local stmts = {}
			i, stmts[#stmts+1] = process(i + 1, true)
			while arg[i - 1] == "%%" do
				i, stmts[#stmts+1] = process(i, true)
			end
			if #stmts == 1 then fn[#fn+1] = stmts[1]
			else
				fn[#fn+1] = function (...)
					stmts[1](...)
					for j = 2, #stmts-1 do stmts[j]() end
					return stmts[#stmts]()
				end
			end
		else
			local converter_name, value = s:match("(.-)@(.*)")
			if converter_name and #converter_name > 0 then
				local new_args = { converters[converter_name](value) }
				local prev_argc = #fn
				for j = 1, #new_args do fn[prev_argc + j] = new_args[j] end
				i = i + 1
			else
				local array_converter_name = s:match("%[(.+)")
				if array_converter_name then
					local items
					i, items = process(i + 1, compile_only, true)
					local new_args = { array_converters[array_converter_name](items) }
					local prev_argc = #fn
					for j = 1, #new_args do fn[prev_argc + j] = new_args[j] end
				else
					fn[#fn+1] = tonumber(s) or s
					i = i + 1
				end
			end
		end
	end
	if #fn > 0 then functions[#functions+1] = fn end
	return #arg + 1, eval(functions, compile_only, ignore_control_flow)
end

local i = 1
while i <= #arg do
	-- TODO: figure out what to do with `{ a %% b }`. just take the last statement i guess...
	local iter, k, v
	i, iter, k, v = process(i)
	if not iter and k then
		io.stderr:write(k, "\n")
	elseif is_iterator(iter) or type(iter) == "function" then
		for x in iter, k, v do
			-- consider multiple returns
			pretty_print(x)
		end
	elseif iter ~= nil then
		pretty_print(iter)
	end
end
-- TODO: [f id [a @ 1 ] ]
-- TODO: v@name for vars... once setting vars is implemented?
-- TODO: @1 for referring to the same argument twice?

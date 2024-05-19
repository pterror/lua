#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

--[[consider adding inotify as an iterator, but it's async so idk how hard it will be]]

local epoll = require("dep.epoll").new()
--[[@type fun(...: any)]]
print = require("dep.pretty_print").pretty_print
wrap = function (name, f)
	local inner = _G[name]
	_G[name] = f(inner)
end

local co
local is_cli = #arg > 0
local prompt = is_cli and function () end or function () io.stdout:write("$ "); io.stdout:flush() end

local resume = function (...)
	local rets = { coroutine.resume(co, ...) }
	if co and coroutine.status(co) == "dead" then co = nil end
	return unpack(rets)
end

exit = os.exit

input = function (prompt)
	io.stdout:write(prompt or "> ")
	io.stdout:flush()
	return coroutine.yield()
end

id = function (...) return ... end
sh_ = io.popen
sh = function (cmd) return io.popen(cmd):read("*all") end
it_ = function (code) return loadstring("return function (it) " .. (code and code:find("return") and "" or "return ") .. (code or "true") .. " end")() end

identity = function (...) return ... end

iter_fn = require("lib.functional.iterable")
iter = iter_fn.iter

local wrap_in_iter = function (f)
	return function (...)
		local ret = { f(...) }
		if ret[1] then return iter(unpack(ret)) else return unpack(ret) end
	end
end

local lazy_load_table

help = function ()
	local keys = {}
	local key_map = {}
	for key in pairs(_G) do keys[#keys+1] = key; key_map[key] = true end
	for key in pairs(lazy_load_table) do if not key_map[key] then keys[#keys+1] = key end end
	table.sort(keys)
	print(table.concat(keys, "\t"))
end

null = setmetatable({}, { __tostring = function () return "null" end })

local resume_true = function () resume(true) end
local with_epoll = function (f) return function (...) return f(epoll, ...) end end

local http_mod_to_obj = function (mod) --[[@param mod { send: fun(req: http_client_request): string }]]
	local http = require("lib.http.format")
	local send = mod.send
	local method = function (method) --[[@param method string]]
		return function (url, opts)
			opts = opts or {}
			local host_and_port, path = url:match("(.-)(/.*)") --[[@type string?, string?]]
			if not host_and_port then host_and_port = url end
			if not path then path = "/" end
			local host, port = host_and_port:match("(.-):(.+)")
			host = host or host_and_port
			return http.string_to_http_client_response(send({
				--[[@diagnostic disable-next-line: assign-type-mismatch]]
				host = host, path = path, method = method, port = tonumber(port),
				body = opts.body or "", headers = opts.headers or {},
			}))
		end
	end
	return {
		send = send, method = function (method_, url, opts) return method(method_)(url, opts) end,
		get = method("GET"), head = method("HEAD"), post = method("POST"),
		put = method("PUT"), delete = method("DELETE"), connect = method("CONNECT"),
		options = method("OPTIONS"), trace = method("TRACE"), patch = method("PATCH"),
	}
end

lazy_load_table = {
	env = { "dep.env", "env" },
	f = { "lib.it_fn" },
	it = { "lib.it_fn", "it" },
	arr = { "lib.functional.array", "array" },
	dig = { "lib.dns.tcp_client", "client", function (client)
		return function (domain, type)
			client(resume, "localhost", domain, nil, type and require("lib.dns.format").type[type], nil, epoll)
			return coroutine.yield()
		end
	end },
	ls = { "lib.fs.dir_list", "dir_list", wrap_in_iter, function (f)
		return function (...)
			return f(...):map(function (info)
				info.type = info.is_dir and "directory" or "file"
				info.age = os.time() - info.created
				info.modified_age = os.time() - info.modified
				info.is_file = not info.is_dir
				return info
			end)
		end
	end },
	find = { "cli.findx", wrap_in_iter },
	to_base = { "lib.base", "integer_to_base" },
	from_base = { "lib.base", "base_to_integer" },
	to_json = { "dep.lunajson", "value_to_json", function (to_json)
		return function (value) return to_json(value, null) end
	end },
	from_json = { "dep.lunajson", "json_to_value", function (from_json)
		return function (string) return from_json(string, nil, null) end
	end },
	lfilesystems = { "lib.linux.proc", "filesystems" },
	lloadavg = { "lib.linux.proc", "loadavg" },
	lmeminfo = { "lib.linux.proc", "meminfo" },
	lmisc = { "lib.linux.proc", "misc" },
	lmounts = { "lib.linux.proc", "mounts" },
	lpartitions = { "lib.linux.proc", "partitions" },
	lnet = { "lib.linux.proc", "net" }, --[[a table containing { dev }]]
	lstat = { "lib.linux.proc", "stat" },
	lswaps = { "lib.linux.proc", "swaps" },
	luptime = { "lib.linux.proc", "uptime" },
	lversion = { "lib.linux.proc", "version" },
	lvmstat = { "lib.linux.proc", "vmstat" },
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	mock = { "dep.mock", function (mock) math.randomseed(require("lib.time").time()); return mock end },
	sleep_ms = { "dep.timerfd", "set_timeout", function (set_timeout)
		return function (ms) set_timeout(epoll, ms, resume_true); return coroutine.yield() end
	end },
	set_timeout = { "dep.timerfd", "set_timeout", with_epoll },
	set_interval = { "dep.timerfd", "set_interval", with_epoll },
	--[[TODO: http.server???]]
	http = { "lib.http.client", http_mod_to_obj },
	https = { "lib.https.client", http_mod_to_obj },
	sqlite = { "dep.sqlite", "sqlite" },
	epoch = { "lib.time", "time" },
}

sleep_ms = sleep_ms
sleep = function (s) return sleep_ms(s * 1000) end

arr = arr
arr_of = function (...) return arr({ ... }) end

open = io.open
rm = os.remove
delete = os.remove
mv = os.rename
move = os.rename
rename = os.rename

slines = function (s) return iter(string.gmatch(s, "[^\n]*")) end --[[@param s string]]

lines = function (path)
	local file = assert(io.open(path, "r"), "file_lines: could not open file '" .. path .. "'")
	return iter(function () return file:read("*line") end)
end

read = function (path)
	local file = assert(io.open(path, "rb"), "fileread: could not open file '" .. path .. "'")
	local contents = file:read("*all")
	file:close()
	return contents
end

touch = function (path)
	assert(
		assert(io.open(path, "a+b"), "filetouch: could not open file '" .. path .. "'"):write(),
		"filetouch: could not touch file '" .. path .. "'"
	):close()
end

to_base = to_base
from_base = from_base
bin = function (n) return to_base(n, 2) end
oct = function (n) return to_base(n, 8) end
hex = function (n) return to_base(n, 16) end
unbin = function (s) return from_base(s, 2) end
unoct = function (s) return from_base(s, 8) end
unhex = function (s) return from_base(s, 16) end

product = function (...)
	local ret = 1
	for _, n in ipairs({ ... }) do ret = ret * n end
	return ret
end
prod = product
mul = product
times = product
div = function (a, b) return a / b end
floordiv = function (a, b) return trunc(a / b) end
sum = function (...)
	local ret = 0
	for _, n in ipairs({ ... }) do ret = ret + n end
	return ret
end
add = sum
plus = sum
sub = function (a, b) return a - b end
pow = function (a, b) return a ^ b end
mod = function (a, b) return a % b end
fmod = mod

gt = function (a, b) return a > b end
ge = function (a, b) return a >= b end
lt = function (a, b) return a < b end
le = function (a, b) return a <= b end
eq = function (a, b) return a == b end
ne = function (a, b) return a ~= b end

band = bit.band
bor = bit.bor
bxor = bit.bxor
bnot = bit.bnot
bswap = bit.bswap
brshift = bit.rshift
barshift = bit.arshift
blshift = bit.lshift
brol = bit.rol
bror = bit.ror

abs = math.abs
sqrt = math.sqrt
hypot = function (a, b) return math.sqrt(a * a + b * b) end
floor = math.floor
ceil = math.ceil
trunc = function (n) return (n >= 0 and math.floor or math.ceil)(n) end

maxint = 9007199254740992
minint = -9007199254740992
pi = math.pi
e = math.exp(1)

pow = math.pow
sin = math.sin
cos = math.cos
tan = math.tan
sinh = math.sinh
cosh = math.cosh
tanh = math.tanh
asin = math.asin
acos = math.acos
atan = math.atan
atan2 = math.atan2

log = math.log
log10 = math.log10
exp = math.exp

mean = function (...)
	local ns = { ... }
	local sum_ = 0
	for _, n in ipairs(ns) do sum_ = sum_ + n end
	return sum_ / #ns
end
geometric_mean = function (...)
	local ns = { ... }
	local geomean = 1
	local pow = 1 / #ns
	for _, n in ipairs(ns) do geomean = geomean * math.pow(n, pow) end
	return geomean
end
geomean = geometric_mean
root_mean_square = function (...)
	local ns = { ... }
	local sum_ = 0
	for _, n in ipairs(ns) do sum_ = sum_ + n * n end
	return math.sqrt(sum_ / #ns)
end
rms = root_mean_square

sskip = function (s, n) return s:sub(n + 1, #s) end
sskip_last = function (s, n) return s:sub(1, math.max(0, #s - n)) end
stake = function (s, n) return s:sub(1, n) end
stake_last = function (s, n) return s:sub(math.max(1, #s - n + 1), #s) end

tr = function (s, from, to)
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

call = function (fn, ...) return fn(...) end

repeat_ = function (value, count)
	return iter(function ()
		if count > 0 then
			count = count - 1
			return value
		end
	end)
end

--[[FIXME: rename]]
kvs2dict = function (iter)
	local obj = {}
	local kv = iter:next()
	while kv do
		obj[kv[1]] = kv[2]
		kv = iter:next()
	end
	return obj
end

ssplit = function (s, sep)
	local i = 1
	return function ()
		if i > #s then return end
		local start, end_ = string.find(s, sep, i, true)
		start = start or #s + 1
		local ret = string.sub(s, i, start - 1)
		i = (end_ or #s) + 1
		return ret
	end
end

local rawget = rawget
--[[@diagnostic disable-next-line: param-type-mismatch]]
setfenv(0, setmetatable(_G, {
	__index = function (self, key)
		local val = rawget(self, key)
		if val then return val end
		local lazy_load = lazy_load_table[key]
		if lazy_load then
			val = require(lazy_load[1])
			for i = 2, #lazy_load do
				if not val then break end
				local key2 = lazy_load[i]
				val = type(key2) == "function" and key2(val) or val[key2]
			end
			self[key] = val
			lazy_load_table[key] = nil
		end
		return rawget(self, key)
	end,
}))

--[[TODO: iterator based file stuff, buffer with limited history]]
--[[i wanted something else but forgot]]

local smart_print = function (...)
	if select("#", ...) == 1 then
		local obj = select(1, ...)
		if iter_fn.is_iter(obj) then
			local rets = { obj() }
			while rets[1] ~= nil do
				print(unpack(rets))
				rets = { obj() }
			end
			return
		end
	end
	print(...)
end

--[[@param data string]]
local eval = function (data)
	if co == nil then
		local fn, err = loadstring(data:byte(1) == 0x3b --[[;]] and data:sub(2) or ("return " .. data))
		if fn then
			co = coroutine.create(fn)
			--[[TODO: consider printing multiple returns]]
			local __, ret = resume()
			_ = ret
			if ret then smart_print(ret) end
			prompt()
		else
			io.stderr:write("error: ", err or "", "\n")
			prompt()
		end
	else
		local __, ret = resume(data:sub(1, -2))
		_ = ret
		if ret then smart_print(ret) end
		prompt()
	end
end

--[[FIXME: this does not work on windows, which needs a socket, not fd 0]]
if is_cli then
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	epoll:add(0, eval, nil)
	eval(table.concat(arg, " "))
else
	io.stdout:write("$ ")
	io.stdout:flush()
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	epoll:add(0, eval)
end

--[[@diagnostic disable-next-line: undefined-field]]
if not is_cli or co ~= nil or epoll.count > 1 then
	while true do
		local success, err = xpcall(epoll.wait, debug.traceback, epoll)
		if not success and err then
			if err:match("^.+: interrupted!") then return end
			io.stderr:write(err, "\n")
			prompt()
			--[[@diagnostic disable-next-line: undefined-field]]
		elseif is_cli and co == nil and epoll.count <= 1 then break end
	end
end

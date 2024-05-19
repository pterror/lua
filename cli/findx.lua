#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

--[[@alias find_callback fun(info:file_info):boolean,("stop"|"skip")?]]

b = function (n) return n end
local kib_1 = 2 ^ 10
kib = function (n) return n * kib_1 end
local mib_1 = 2 ^ 20
mib = function (n) return n * mib_1 end
local gib_1 = 2 ^ 30
gib = function (n) return n * gib_1 end
local tib_1 = 2 ^ 40
yib = function (n) return n * tib_1 end
local eib_1 = 2 ^ 50
eib = function (n) return n * eib_1 end
local kb_1 = 10 ^ 3
kb = function (n) return n * kb_1 end
local mb_1 = 10 ^ 6
mb = function (n) return n * mb_1 end
local gb_1 = 10 ^ 9
gb = function (n) return n * gb_1 end
local tb_1 = 10 ^ 12
tb = function (n) return n * tb_1 end
local eb_1 = 10 ^ 15
eb = function (n) return n * eb_1 end
local sec_1 = 1
sec = function (n) return n * sec_1 end
local min_1 = 60 * sec_1
min = function (n) return n * min_1 end
local hr_1 = 60 * min_1
hr = function (n) return n * hr_1 end
local day_1 = 24 * hr_1
day = function (n) return n * day_1 end
local month_1 = 30 * day_1
month = function (n) return n * month_1 end
local year_1 = 365.25 * day_1
year = function (n) return n * year_1 end

local dir_list = require("lib.fs.dir_list").dir_list

--[[@param info file_info]] --[[@param callback find_callback]] --[[@param write fun(info:file_info)]]
local handle_file = function (info, callback, write)
	local ret, action = callback(info)
	if ret then write(info) end
	if action == "stop" then os.exit(0) end
end

local next = function (_, ...) return ... end

local handle_dir
--[[@param info file_info]] --[[@param callback find_callback]] --[[@param write fun(info:file_info)]]
handle_dir = function (info, callback, write)
	local ret, action = callback(info)
	if ret then write(info) end
	if action == "skip" then return
	elseif action == "stop" then os.exit(0) end
	local iter, state = dir_list(info.path)
	if not iter then
		io.stderr:write("find: could not open directory: " .. info.path .. " error: " .. state .. "\n")
		return
	end
	for f in iter, state do
		f.age = os.time() - f.created
		f.modified_age = os.time() - f.modified
		f.is_file = not f.is_dir
		if f.is_dir then f.type = "directory"; handle_dir(f, callback, write)
		else f.type = "file"; handle_file(f, callback, write) end
	end
end

if pcall(debug.getlocal, 4, 1) then
	--[[@param path string]] --[[@param callback find_callback]]
	return function (path, callback)
		local info = assert(require("lib.fs.dir_list").dir_info(path))
		info.type = "directory"
		info.name = arg[1]:match("[\\/](.-)[\\/]?$") or arg[1]
		info.age = os.time() - info.created
		info.modified_age = os.time() - info.modified
		info.is_file = not info.is_dir
		local co = coroutine.create(function ()
			handle_dir(info, callback, coroutine.yield)
		end)
		return function ()
			if coroutine.status(co) == "dead" then return end
			return next(coroutine.resume(co))
		end
	end
else
	if not arg[1] then io.stderr:write("find: root directory needs to be given as first argument") end
	local callback = assert(loadstring("return function (it) " .. (arg[2] and arg[2]:find("return") and "" or "return ") .. (arg[2] or "true") .. " end"))()

	local info = assert(require("lib.fs.dir_list").dir_info(arg[1]))
	info.type = "directory"
	info.name = arg[1]:match("[\\/](.-)[\\/]?$") or arg[1]
	info.age = os.time() - info.created
	info.modified_age = os.time() - info.modified
	info.is_file = not info.is_dir

	handle_dir(info, callback, function (file_info) print(file_info.path) end)
end

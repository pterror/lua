#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local package_whitelist = {} --[[@type table<string, boolean>]]
--[[@diagnostic disable-next-line: lowercase-global]]
register_ffi_module = function (name) package_whitelist[name] = true end
--[[@diagnostic disable-next-line: lowercase-global]]
epoll = require("dep.epoll").new()
DEV = true
local rest = function (_, ...) return ... end
local inotify_mod = require("dep.inotify")
local inotify = inotify_mod.new(epoll)
local ok = true
local mod
--[[@type luajitsocket]]
local sock
local here = debug.getinfo(1).source:match("@?(.*[/\\])")
local sep = here:find("/") and "/" or "\\"
for k in pairs(package.loaded) do package_whitelist[k] = true end
--[[@diagnostic disable-next-line: param-type-mismatch]]
inotify:add(here .. ".." .. sep .. "serve", bit.bor(
	inotify_mod.event_mask.IN_ATTRIB,
	inotify_mod.event_mask.IN_CREATE,
	inotify_mod.event_mask.IN_MODIFY,
	inotify_mod.event_mask.IN_MOVE,
	inotify_mod.event_mask.IN_MOVE_SELF,
	inotify_mod.event_mask.IN_DELETE,
	inotify_mod.event_mask.IN_DELETE_SELF,
	inotify_mod.event_mask.IN_UNMOUNT
), function ()
	for k in pairs(package.loaded) do if not package_whitelist[k] then package.loaded[k] = nil end end
	if sock and type(sock.close) == "function" then sock:close() end
	ok, mod = pcall(package.loaders[2], "serve." .. arg[1])
	if not ok then print("error reloading server:"); io.stdout:write(mod, "\n"); return end
	ok, sock = pcall(mod, rest(unpack(arg)))
	if ok then print("server reloaded.")
	else print("error reloading server"); io.stdout:write(sock, "\n") end
end)
print("server loading...")
ok, mod = pcall(package.loaders[2], "serve." .. arg[1])
if not ok then print("error loading server:"); io.stdout:write(mod, "\n")
else
	ok, sock = pcall(mod, rest(unpack(arg)))
	if ok then print("server loaded.")
	else print("error loading server:"); io.stdout:write(sock, "\n") end
end
--[[FIXME: recursive watch, here and in serve_api_dev]]
local err
--[[@diagnostic disable-next-line: undefined-field]]
while epoll.count > 0 do
	ok, err = pcall(epoll.wait, epoll)
	if err and err:match("^.+: interrupted!") then return end
	if not ok then
		if err and err:match("^.+: interrupted!") then return end
		print("server encountered an error:")
		io.stdout:write(err, "\n")
	end
end
if err then os.exit(1) end

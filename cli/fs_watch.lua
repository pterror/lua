#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")
local epoll = require("dep.epoll").new()
local inotify_mod = require("dep.inotify")
local inotify = inotify_mod.new(epoll)
local special_flags = {
	inotify_mod.event_mask.IN_IGNORED,
	inotify_mod.event_mask.IN_ISDIR,
	inotify_mod.event_mask.IN_Q_OVERFLOW,
	inotify_mod.event_mask.IN_UNMOUNT,
}
local recursive = os.getenv("recursive") == "true" or os.getenv("RECURSIVE") == "true"
local wd_paths = {} --[[@type table<inotify_wd_c, string>]]
local wd_removes = {} --[[@type table<inotify_wd_c, fun()>]]
local watch
--[[@param event inotify_event_c]]
watch = function (event)
	local extra = {} --[[@type string[] ]]
	local name --[[@type string?]]
	if event.len > 0 then name = ffi.string(event.name, event.len); extra[#extra+1] = "name: " .. name end
	if recursive and event.len > 0 then
		if wd_paths[event.wd] == nil then
			io.stderr:write("fs_watch: no path for wd: " .. event.wd)
		else
			local path = wd_paths[event.wd] .. "/" .. name
			if bit.band(event.mask, inotify_mod.event_mask.IN_CREATE) ~= 0 then
				local wd, remove = inotify:add(path, inotify_mod.event_mask.IN_ALL_EVENTS, watch)
				wd_paths[wd] = path
				wd_removes[wd] = remove
			elseif bit.band(event.mask, inotify_mod.event_mask.IN_DELETE) ~= 0 then
				wd_paths[event.wd] = nil
				wd_removes[event.wd]()
				wd_removes[event.wd] = nil
			end
		end
	end
	local mask = event.mask
	local flags = {} --[[@type string[] ]]
	for _, flag in ipairs(special_flags) do
		if bit.band(mask, flag) ~= 0 then
			flags[#flags+1] = inotify_mod.event_mask_name[flag]
			mask = bit.bxor(mask, flag)
		end
	end
	if #flags > 0 then extra[#extra+1] = "flags: " .. table.concat(flags, " ") end
	print("wd: " .. event.wd, "event: " .. (inotify_mod.event_mask_name[mask] or mask), unpack(extra))
end
local root = arg[1] or "."
local root_wd = inotify:add(root, inotify_mod.event_mask.IN_ALL_EVENTS, watch)
wd_paths[root_wd] = root
if recursive then
	local dir_list = require("lib.fs.dir_list").dir_list
	local recursively_add
	recursively_add = function (path) --[[@param path string]]
		local wd, remove = inotify:add(path, inotify_mod.event_mask.IN_ALL_EVENTS, watch)
		wd_paths[wd] = path
		wd_removes[wd] = remove
		for f in dir_list(path) do if f.is_dir then recursively_add(path .. "/" .. f.name) end end
	end
	for f in dir_list(root) do if f.is_dir then recursively_add(root .. "/" .. f.name) end end
end
while true do
	local success, err = xpcall(epoll.wait, debug.traceback, epoll)
	if not success and err then
		if err:match("^.+: interrupted!") then return end
		io.stderr:write(err, "\n")
	end
end
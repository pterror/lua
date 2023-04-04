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
inotify:add(arg[1] or ".", inotify_mod.event_mask.IN_ALL_EVENTS, function (event)
	local extra = {}
	if event.len > 0 then extra[#extra+1] = "name: " .. ffi.string(event.name, event.len) end
	local mask = event.mask
	local flags = {}
	for _, flag in ipairs(special_flags) do
		if bit.band(mask, flag) ~= 0 then
			flags[#flags+1] = inotify_mod.event_mask_name[flag]
			mask = bit.bxor(mask, flag)
		end
	end
	if #flags > 0 then extra[#extra+1] = "flags: " .. table.concat(flags, " ") end
	print("wd: " .. event.wd, "event: " .. (inotify_mod.event_mask_name[mask] or mask), unpack(extra))
end)
epoll:loop()

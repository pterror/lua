#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")
local epoll = require("dep.epoll").new()
local xlib = require("dep.xlib")
local et = xlib.event_type
local event_name = {}
for k, v in pairs(xlib.event_type) do
	event_name[v] = ("_" .. k):gsub("_(.)", function (c) return c:upper() end)
end
local d = assert(xlib.display:new())

local writers = {} --[[@type table<xlib_event_type, fun(e: xlib_event_c)>]]
writers[et.motion_notify] = function (e_)
	local e = e_.xmotion
	io.stdout:write(
		"    root 0x", ("%x"):format(e.root), ", subw 0x", ("%x"):format(e.subwindow), ", time ", tostring(e.time):sub(1, -4),
		", (", e.x, ",", e.y, "), root:(", e.x_root, ",", e.y_root, "),\n",
		"    state 0x", ("%x"):format(e.state), ", is_hint ", e.is_hint, ", same_screen ", e.same_screen and "YES" or "NO", "\n"
	)
end
writers[et.button_press] = function (e_)
	local e = e_.xbutton
	io.stdout:write(
		"    root 0x", ("%x"):format(e.root), ", subw 0x", ("%x"):format(e.subwindow), ", time ", tostring(e.time):sub(1, -4),
		", (", e.x, ",", e.y, "), root:(", e.x_root, ",", e.y_root, "),\n",
		"    state 0x", ("%x"):format(e.state), ", button ", e.button, ", same_screen ", e.same_screen and "YES" or "NO", "\n"
	)
end
writers[et.button_release] = writers[et.button_press]
--[[@diagnostic disable-next-line: redundant-parameter]]
writers[et.key_press] = function (e_, is_release)
	local e = e_.xkey
	local keysym = d:keycode_to_keysym(e.keycode, 0)
	local ls = xlib.lookup_string(e) --[[FIXME: why does it give 0 bytes]]
	--[[FIXME]]
	-- local mbls = (not is_release) and xlib.mb_lookup_string(e)
	io.stdout:write(
		"    root 0x", ("%x"):format(e.root), ", subw 0x", ("%x"):format(e.subwindow), ", time ", tostring(e.time):sub(1, -4),
		", (", e.x, ",", e.y, "), root:(", e.x_root, ",", e.y_root, "),\n",
		"    state 0x", ("%x"):format(e.state), ", keycode ", e.keycode, " (keysym 0x", ("%x"):format(keysym), " ",
		ffi.string(xlib.keysym_to_string(keysym)), "), same_screen ", e.same_screen and "YES" or "NO",
		"\nXLookupString gives ", #ls, " bytes:" ..
		(#ls > 0 and (" (" .. table.concat({ ls:byte(1, #ls) }, ", ") .. ") \"" .. ls .. "\"") or ""),
		-- "\nXmbLookupString gives ", #mbls, " bytes:" ..
		-- (mbls and #mbls > 0 and (" (" .. table.concat({ mbls:byte(1, #mbls) }, ", ") .. ") \"" .. mbls .. "\"") or ""),
		"\nXFilterEvent returns: ", (xlib.filter_event(e_, e.window) and "True" or "False")
	)
end
--[[@diagnostic disable-next-line: redundant-parameter]]
writers[et.key_release] = function (e) return writers[et.key_press](e, true) end

local default_writer = function () io.stdout:write("    ???\n") end
local f = function ()
	while d:pending() > 0 do
		local e = d:next_event()
		local a = e.xany
		io.stdout:write(event_name[e.type], " event, serial ", tostring(a.serial), ", synthetic ", a.send_event and "YES" or "NO", ", window 0x", ("%x"):format(a.window), ",\n")
		--[[LINT: warn about ambiguous syntax]]
		;(writers[e.type] or default_writer)(e)
	end
end
local root = d.c[0].screens[d.c[0].default_screen].root
local w = assert(d:create_simple_window(root, 0, 0, 1000, 1000, 0, 0, 0))

epoll:add(d.c[0].fd, f)

d:map_window(w)
f()
d:grab_button(xlib.button.any, xlib.key_button_mask.any_modifier, w, false, 0, xlib.grab_mode.async, xlib.grab_mode.async, xlib.none_window, xlib.none_cursor)
f()
d:grab_key(xlib.any_key, xlib.key_button_mask.any_modifier, w, false, xlib.grab_mode.async, xlib.grab_mode.async)
f()
d:grab_pointer(w, true, 0, xlib.grab_mode.async, xlib.grab_mode.async, xlib.none_window, xlib.none_cursor, xlib.current_time)
epoll:loop()

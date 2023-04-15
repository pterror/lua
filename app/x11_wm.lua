#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")
local epoll = require("dep.epoll").new()
local xlib = require("dep.xlib")
local evmask = bit.bor(xlib.input_event_mask.substructure_redirect, xlib.input_event_mask.substructure_notify)

local display = assert(xlib.display:new())
local root = display.c[0].screens[display.c[0].default_screen].root

-- FIXME: extract *all* functionality to plugins (just like xmonad)
-- unmap+remap windows when switching workspaces
-- make sure to map them all somewhere on first start

WM = {}

--[[@class x11_wm_state]]
WM.state = {}

--[[@generic t]]
--[[@param v t]]
--[[@return { [1]: t }]]
local weak_ref = function (v) return setmetatable({ v }, { __mode = "v" }) end

-- TODO: win+mouse1 drag space between windows to resize partitions (and open up new ones)

--[[@class x11_wm_partition]]
--[[@field parent { [1]: x11_wm_partition?; }]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field children? x11_wm_partition[] ]]
--[[@field window? xlib_window_c]]
--[[@field tile_mode x11_wm_tile_mode]]

--[[@class x11_wm_workspace]]
--[[@field partition x11_wm_partition]]

WM.state.workspaces = {} --[[@type x11_wm_workspace[] ]]
WM.state.screen_to_workspace_index = {} --[[@type table<xlib_screen_c, integer>]]
WM.state.partition_of = setmetatable({}, { __mode = "v" }) --[[@type table<xlib_window_c, x11_wm_partition>]]

local atom_cache = {} --[[@type table<string, xlib_atom_c>]]
WM.atom = setmetatable(atom_cache, { __index = function (k)
	atom_cache[k] = display:intern_atom(k)
end })

WM.enum = {}
--[[@enum x11_wm_direction]]
WM.enum.direction = { up = 0, right = 1, down = 2, left = 3 }
--[[@enum x11_wm_tile_mode]]
WM.enum.tile_mode = { horizontal = 0, vertical = 1 }

WM.fn = {}

--[[@param d xlib_display]] --[[@param w xlib_window_c]]
WM.fn.screen_of = function (d, w)
	return d:get_window_attributes(w).screen[0]
end

--[[@param s xlib_screen_c]] --[[@param workspace_index integer]]
WM.fn.go_to_workspace = function (s, workspace_index)
	local ws = WM.state.workspaces[workspace_index]
	if not ws then return end --[[silently error]]
	local partition = ws.partition
	--[[FIXME]]
end

--[[drag to center -> swap windows; drag to border between already tiled windows -> reflow partition]]
--[[TODO: for move: recursively recalc geometry + resize all other contents]]
--[[TODO: handle struts and sticky windows (and sticky struts!); calculate usable area]]

--[[@param d xlib_display]] --[[@param w1 xlib_window_c]] --[[@param w2 xlib_window_c]]
WM.fn.swap_windows = function (d, w1, w2)
	local a1 = d:get_window_attributes(w1)
	local a2 = d:get_window_attributes(w2)
	d:move_resize_window(w1, a2.x, a2.y, a2.width, a2.height)
	d:move_resize_window(w2, a1.x, a1.y, a1.width, a1.height)
	--[[partition_of will be nil if the window is floating]]
	if WM.state.partition_of[w1] then WM.state.partition_of[w1].window = w2 end
	if WM.state.partition_of[w2] then WM.state.partition_of[w2].window = w1 end
	WM.state.partition_of[w1], WM.state.partition_of[w2] = WM.state.partition_of[w2], WM.state.partition_of[w1]
end

--[[consider making unresizable windows flash red 3 times to notify user those are preventing resizing]]

--[[@param d xlib_display]] --[[@param w xlib_window_c]]
WM.fn.pop_out_window = function (d, w)
	local partition = WM.state.partition_of[w]
	local parent = partition.parent[1]
	if not parent then partition.window = nil; return end --[[at top level partition for the workspace]]
	for i = 1, #parent.children do
		if parent.children[i] == partition then
			table.remove(parent.children, i)
			-- FIXME: parent mode
		end
	end
end

--[[@param d xlib_display]] --[[@param w xlib_window_c]] --[[@param p x11_wm_partition]] --[[@param i integer index]]
WM.fn.pop_in_window = function (d, w, p, i)
	local hints = d:get_wm_normal_hints(w)
	--[[if the window cannot be moved or resized then we don't tile it]]
	if hints and bit.band(hints.flags, bit.bor(xlib.size_flag.p_position, xlib.size_flag.p_size, xlib.size_flag.p_min_size, xlib.size_flag.p_max_size)) ~= 0 then return end
end

--[[@param d xlib_display]] --[[@param w xlib_window_c]]
WM.fn.close_window = function (d, w)
	local proto = d:get_wm_protocols(w)
	local supports_delete_window = false
	if proto then
		for i = 0, proto.num_supported_protocols do
			if proto.supported_protocols[i] == WM.atom.WM_DELETE_WINDOW then supports_delete_window = true; break end
		end
	end
	if supports_delete_window and d:send_event(w, false, 0, { xclient = { -- xevent
		type = xlib.event_type.client_message,
		message_type = WM.atom.WM_PROTOCOLS,
		window = w,
		format = 32,
		data = { l = { xlib.what.wm_delete_window } }
	} }) then -- pass
	else
		d:kill_client(w)
	end
end

local color_cache = {} --[[@type table<integer, integer>]]
--[[@param d xlib_display]] --[[@param s xlib_screen_c]] --[[@param rgb integer]]
WM.fn.to_color = function (d, s, rgb)
	local ret = color_cache[rgb]
	if ret then return ret end
	ret = d:alloc_color_x(s.cmap, rgb) or 0
	color_cache[rgb] = ret
end

local et = xlib.event_type

WM.on = {} --[[@type { [xlib_event_type]?: fun(d: xlib_display, e: xlib_event_c); init?: fun(d: xlib_display); restart?: fun(d: xlib_display); }]]

--[[@param d xlib_display]]
WM.on.init = function (d)
	local text_prop = ffi.new("XTextProperty[1]") --[[@type ptr_c<xlib_text_property_c>]]
	text_prop[0].encoding = d:intern_atom("STRING") or {}
	text_prop[0].format = 8
	local s = "LG3D"
	text_prop[0].value = s
	text_prop[0].nitems = #s
	d:set_wm_name(d.c[0].screens[d.c[0].default_screen].root, text_prop)
	io.popen("pipewire")
	io.popen("pipewire-pulse")
	io.popen("wireplumber")
	os.execute("pactl set-default-sink hesuvi")
	os.execute("picom --config ~/.config/picom.conf -b")
	os.execute("redshift -l -27.46794:153.02809")
	os.execute("xrandr --output DP-3 --left-of HDMI-0")
	os.execute("code-server >/dev/null 2>&1 & disown")
	os.execute("PULSE_SINK='alsa_output.pci-0000_00_1f.3.analog-stereo' rustyvibes ~/rustyvibes/Tealios_v2Akira")
end

-- TODO: better naming
--[[@param d xlib_display]]
WM.on.restart = function (d)
	if WM.state.stop_statbar then WM.state.stop_statbar() end
	WM.state.stop_statbar = package.loaders[2]("local.statbar")(d, epoll) --[[@type fun()]]
	WM.state.dzen = require("lib.textbar").new(
		arg[1], 1920, 1056, 1920, 24, 0x1b1d1e, "FantasqueSansMono Nerd Font", require("lib.textbar").dock_side.top
	)
end

WM.on[et.map_request] = function (d, e_)
	local e = e_.xmaprequest
	display:select_input(e.window, evmask)
	display:map_window(e.window)
	d:grab_button(xlib.button.any, xlib.key_button_mask.mod4, e.window, false, bit.bnot(0), xlib.grab_mode.async, xlib.grab_mode.async, xlib.none_window, xlib.none_cursor)
	d:grab_key(xlib.any_key, xlib.key_button_mask.mod4, e.window, false, xlib.grab_mode.async, xlib.grab_mode.async)
end

local opaque = ffi.cast("void *", ffi.new("int[1]", 0xffffffff))
local translucent = ffi.cast("void *", ffi.new("int[1]", 0xdddddddd))

WM.on[et.enter_notify] = function (d, e_)
	local e = e_.xcrossing
	d:set_input_focus(e.window, xlib.revert_to.none, xlib.current_time)
	d:change_property(e.window, WM.atom._NET_WM_WINDOW_OPACITY, WM.atom.CARDINAL, 32, xlib.property_mode.replace, opaque, 1)
end

WM.on[et.leave_notify] = function (d, e_)
	local e = e_.xcrossing
	d:change_property(e.window, WM.atom._NET_WM_WINDOW_OPACITY, WM.atom.CARDINAL, 32, xlib.property_mode.replace, translucent, 1)
end

WM.on[et.configure_request] = function (d, e_)
	local e = e_.xconfigurerequest
	local changes = ffi.new("XWindowChanges[1]") --[[@type ptr_c<xlib_window_changes_c>]]
	changes[0].x = e.x
	changes[0].y = e.y
	changes[0].height = e.height
	changes[0].width = e.width
	changes[0].border_width = e.border_width
	changes[0].sibling = e.above
	changes[0].stack_mode = e.detail
	d:configure_window(e.window, e.value_mask, changes)
end

WM.on[et.motion_notify] = function (d, e_)
	local e = e_.xmotion
	WM.config.movebinds[e.state](d, e)
end

WM.on[et.button_press] = function (d, e_)
	local e = e_.xbutton
	WM.config.clickbinds[bit.bor(bit.lshift(e.button, 24), e.state)](d, e)
end

WM.on[et.key_press] = function (d, e_)
	local e = e_.xkey
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	WM.config.keybinds[bit.bor(bit.lshift(e.keycode, 24), e.state)](d, e)
end

--[[@class wm_button]]

--[[@class wm_buttons]]
--[[@field shift wm_buttons]]
--[[@field caps wm_buttons]]
--[[@field ctrl wm_buttons]]
--[[@field alt wm_buttons]]
--[[@field num_lock wm_buttons]]
--[[@field scroll_lock wm_buttons]]
--[[@field super wm_buttons]]
--[[@field win wm_buttons]]
--[[@field ralt wm_buttons]]
--[[@field mouse_1 wm_button]]
--[[@field mouse_2 wm_button]]
--[[@field mouse_3 wm_button]]
--[[@field mouse_4 wm_button]]
--[[@field mouse_5 wm_button]]

--[[@class wm_key]]

--[[@class wm_keys]]
--[[@field shift wm_keys]]
--[[@field caps wm_keys]]
--[[@field ctrl wm_keys]]
--[[@field alt wm_keys]]
--[[@field num_lock wm_keys]]
--[[@field scroll_lock wm_keys]]
--[[@field super wm_keys]]
--[[@field win wm_keys]]
--[[@field ralt wm_keys]]

local modifier = {
	shift = xlib.key_button_mask.shift,
	caps = xlib.key_button_mask.lock,
	ctrl = xlib.key_button_mask.control,
	alt = xlib.key_button_mask.mod1,
	num_lock = xlib.key_button_mask.mod2, --[[unconfirmed]]
	scroll_lock = xlib.key_button_mask.mod3, --[[unconfirmed]]
	super = xlib.key_button_mask.mod4,
	win = xlib.key_button_mask.mod4,
	ralt = xlib.key_button_mask.mod5,
}

local button = {
	mouse_1 = bit.bor(0x01000000, xlib.key_button_mask.button_1),
	mouse_2 =  bit.bor(0x02000000, xlib.key_button_mask.button_2),
	mouse_3 =  bit.bor(0x03000000, xlib.key_button_mask.button_3),
	mouse_4 =  bit.bor(0x04000000, xlib.key_button_mask.button_4),
	mouse_5 =  bit.bor(0x05000000, xlib.key_button_mask.button_5),
}

local basic_keys = require("dep.x11_keysym_basic").keysym

local key_mt
key_mt = {
	__index = function (self, k)
		local val = modifier[k]
		if val then return setmetatable({ value = bit.bor(self.value, val) }, key_mt) end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		return bit.bor(self.value, bit.lshift(display:keysym_to_keycode(basic_keys[k] or require("dep.x11_keysym").keysym[k] or 0), 24)) --[[silently do nothing on invalid key]]
	end,
}

local button_mt
button_mt = {
	__index = function (self, k)
		local val = modifier[k]
		if val then return setmetatable({ value = bit.bor(self.value, val) }, button_mt) end
		return bit.bor(self.value, button[k] or 0) --[[silently do nothing on invalid button]]
	end,
}

WM.key = setmetatable({ value = 0 }, key_mt) --[[@type wm_keys]]
WM.button = setmetatable({ value = 0 }, button_mt) --[[@type wm_buttons]]

local k = WM.key
local b = WM.button

-- TODO: account for struts:
-- https://specifications.freedesktop.org/wm-spec/wm-spec-1.3.html
-- _NET_WM_STRUT, _NET_WM_STRUT_PARTIAL
-- _NET_WORKAREA ***must*** be set
-- _NET_SUPPORTING_WM_CHECK *must* be set to child window
-- which has _NET_SUPPORTING_WM_CHECK as well, and also _NET_WM_NAME = "LG3D"
-- _NET_SUPPORTED must be present
-- _NET_CLIENT_LIST should be set and updated
-- _NET_NUMBER_OF_DESKTOPS should be set and updated
-- _NET_DESKTOP_GEOMETRY

-- TODO: workspaces (and layout), tabs, a list of floating windows

--[[@class x11_wm_config]]
WM.config = {
	bg_color = 0xffffff,
	-- TODO: refactor out
	keybinds = { --[[@type table<wm_key, fun(d: xlib_display, e: xlib_key_event_c)>]] -- TODO: metatable to detect and apply changes
		[k.super.shift.c] = WM.fn.close_window,
		[k.super.shift["return"]] = function () io.popen("alacritty") end,
		[k.print] = function () io.popen("flameshot gui") end,
		[k.super.t] = function (d)
			-- FIXME
		end,
		[k.audio_raise_volume] = function () io.popen("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
		[k.audio_lower_volume] = function () io.popen("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
		[k.super.a] = function () io.popen("TZ=Australia/Brisbane gtk-launch google-chrome-stable") end, --[[FIXME: disown?]]
		[k.super.shift.q] = function (d) os.exit(0) end,
		[k.super._1] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 1) end,
		[k.super._2] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 2) end,
		[k.super._3] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 3) end,
		[k.super._4] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 4) end,
		[k.super._5] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 5) end,
		[k.super._6] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 6) end,
		[k.super._7] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 7) end,
		[k.super._8] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 8) end,
		[k.super._9] = function (d, e) WM.fn.go_to_workspace(WM.fn.screen_of(d, e.window), 9) end,
		[k.super.shift._1] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 1) end,
		[k.super.shift._2] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 2) end,
		[k.super.shift._3] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 3) end,
		[k.super.shift._4] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 4) end,
		[k.super.shift._5] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 5) end,
		[k.super.shift._6] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 6) end,
		[k.super.shift._7] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 7) end,
		[k.super.shift._8] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 8) end,
		[k.super.shift._9] = function (d, e) WM.fn.move_to_workspace(WM.fn.screen_of(d, e.window), 9) end,
	},
	clickbinds = { --[[@type table<wm_button, fun(d: xlib_display, e: xlib_button_event_c)>]]
		[b.super.mouse_1] = function (d, e)
			-- TODO: set to floating mode
			WM.fn.create_ghost_window(d, e.window)
			WM.state.drag_x = e.x_root
			WM.state.drag_y = e.y_root
			local geom = d:get_geometry(e.window) or {}
			WM.state.window_x = geom.x or 0
			WM.state.window_y = geom.y or 0
		end,
		--[[should be b.super.mouse_3 but my mouse don't work so good]]
		[b.super.shift.mouse_1] = function (d, e)
			-- TODO: set to floating mode
			WM.fn.create_ghost_window(d, e.window)
			if WM.state.just_warped then io.stderr:write("just warped\n"); WM.state.just_warped = false; return end
			WM.state.just_warped = true
			local geom = d:get_geometry(e.window) or {}
			d:warp_pointer(xlib.none_window, e.window, 0, 0, 0, 0, geom.width, geom.height)
			WM.state.drag_x = geom.x + geom.width
			WM.state.drag_y = geom.y + geom.height
			WM.state.window_w = geom.width or 0
			WM.state.window_h = geom.height or 0
		end,
	},
	movebinds = { --[[@type table<wm_button, fun(d: xlib_display, e: xlib_motion_event_c)>]]
		[b.super.mouse_1] = function (d, e)
			local delta_x = e.x_root - WM.state.drag_x
			local delta_y = e.y_root - WM.state.drag_y
			d:move_window(e.window, WM.state.window_x + delta_x, WM.state.window_y + delta_y)
		end,
		[b.super.mouse_3] = function (d, e)
			local delta_x = e.x_root - WM.state.drag_x
			local delta_y = e.y_root - WM.state.drag_y
			d:resize_window(e.window, WM.state.window_w + delta_x, WM.state.window_h + delta_y)
		end,
	},
}
-- TODO: load plugins here. but first define extension points

local wm_detected = false
xlib.set_error_handler(function (display_, error) wm_detected = true end)
display:select_input(nil, evmask)
display:sync(false)
if wm_detected then
	io.stderr:write("x11_wm: another wm is already running\n")
	os.exit(1)
end
xlib.set_error_handler(function (display_, e)
	io.stderr:write(
		"x11_wm: x error ", e.error_code, " request_code=", e.request_code, " resourceid=", e.resourceid, ": ",
		xlib.get_error_text(display_, e.error_code), "\n"
	)
end)
display:grab_server()
local tree = assert(display:query_tree(), "x11_wm: `XQueryTree` failed")
if tree.root ~= root then
	io.stderr:write("x11_wm: `XQueryTree` returned different root window\n")
end
for i = 0, tree.nchildren do display:add_to_save_set(tree.children[i]) end
xlib.free(tree.children)
display:ungrab_server()

WM.on.init(display)
WM.on.restart(display)

epoll:add(display.c[0].fd, function ()
	while display:pending() > 0 do
		local e = display:next_event()
		local fn = WM.on[e.type]
		if fn then fn(display, e) end
	end
end)

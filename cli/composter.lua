#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
local here = nil --[[@type string?]]
if pcall(debug.getlocal, 4, 1) then
	arg = { ... }
else
	here = arg[0]
	package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path
end

local ipc_clients = nil --[[@type table<luajitsocket,true>?]]
local value_to_json --[[@type fun(v): string]]
local ipc_send_event = function(event)
	if not ipc_clients then return end
	local json = value_to_json(event)
	for client in pairs(ipc_clients) do
		client:send(json)
	end
end

local mod = {}

mod.variables = {}
mod.variables.ipc = true
mod.variables.default_server_decoration_mode = "none" --[[@type "none"|"client"|"server"]]
mod.variables.seat_name = "seat0"
mod.variables.cursor_name = nil --[[@type string?]]
mod.variables.cursor_size_px = 24
mod.variables.key_repeats_per_sec = 25
mod.variables.key_repeat_delay_ms = 600

--[[@diagnostic disable: need-check-nil]]

local ffi = require("ffi")
local xkb = require("dep.xkbcommon")
local wl = require("dep.wayland_server")
local wlr = require("dep.wlroots")
local keysym = require("dep.x11_keysym").keysym
local keysym_rev = {} --[[@type table<integer, string>]]
for k, v in pairs(keysym) do
	if #k == 1 then
		v = keysym[k == k:lower() and k:upper() or k:lower()]
	end
	keysym_rev[v] = k
end

--[[TODO: consider hook for on_key]]

local arg_long = { c = "config" }
local arg_count = { config = 1 }
local arg_name = nil --[[@type string?]]
local count_left = 0
local args = { [""] = {} } --[[@type table<string, boolean|string|string[]>]]
for _, arg_ in ipairs(arg) do
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	local arg_s = arg_ --[[@type string]]
	if count_left > 0 and arg_name then
		if arg_count[arg_name] > 1 then
			args[arg_name] = args[arg_name] or {}
			args[arg_name][#args[arg_name] + 1] = arg_s
		else
			args[arg_name] = arg_s
		end
		count_left = count_left - 1
	elseif arg_s:sub(1, 1) == "-" then
		local name = arg_s:sub(2)
		if arg_s:sub(1, 2) == "--" then
			name = arg_s:sub(3)
		end
		name = arg_long[name] or name
		local count = arg_count[name]
		if count == 0 or not count then
			args[name] = true
		else
			arg_name = name
			count_left = count
		end
	else
		args[""][#args[""] + 1] = arg_s
	end
end

--[[@enum composter_cursor_mode]]
local composter_cursor_mode = { passthrough = 0, move = 1, resize = 2 }
mod.cursor_mode = composter_cursor_mode

ffi.cdef [[
	void free(void *ptr);
	int setenv(const char *name, const char *value, int overwrite);
	typedef int pid_t;
	typedef int clockid_t;
	int clock_gettime(clockid_t clk_id, struct timespec *tp);
	pid_t fork(void);
	int execvp(const char *file, const char *argv[]);
	void perror(const char *s);

	enum composter_cursor_mode {
		COMPOSTER_CURSOR_PASSTHROUGH,
		COMPOSTER_CURSOR_MOVE,
		COMPOSTER_CURSOR_RESIZE,
	};

	struct composter_toplevel;
	
	struct composter_server {
		struct wl_display *wl_display;
		struct wlr_backend *backend;
		struct wlr_renderer *renderer;
		struct wlr_allocator *allocator;
		struct wlr_scene *scene;
		struct wlr_scene_output_layout *scene_layout;
		struct composter_toplevel *focused_toplevel;
	
		struct wlr_xdg_shell *xdg_shell;
		struct wl_listener new_xdg_toplevel;
		struct wl_listener new_xdg_popup;
		struct wlr_xwayland *xwayland;
		struct wl_listener new_xwayland_surface;
		struct wl_list toplevels;

		struct wlr_xdg_decoration_manager_v1 *xdg_decoration_manager;
		struct wl_listener new_toplevel_decoration;
	
		struct wlr_cursor *cursor;
		struct wlr_xcursor_manager *cursor_manager;
		struct wl_listener cursor_motion;
		struct wl_listener cursor_motion_absolute;
		struct wl_listener cursor_button;
		struct wl_listener cursor_axis;
		struct wl_listener cursor_frame;
	
		struct wlr_seat *seat;
		struct wl_listener new_input;
		struct wl_listener request_cursor;
		struct wl_listener request_set_selection;
		struct wl_list keyboards;
		enum composter_cursor_mode cursor_mode;
		struct composter_toplevel *grabbed_toplevel;
		double grab_x, grab_y;
		struct wlr_box grab_geobox;
		uint32_t resize_edges;
	
		struct wlr_output_layout *output_layout;
		struct wl_list outputs;
		struct wl_listener new_output;
	};
	
	struct composter_output {
		struct wl_list link;
		struct composter_server *server;
		struct wlr_output *wlr_output;
		struct wl_listener frame;
		struct wl_listener request_state;
		struct wl_listener destroy;
	};
	
	struct composter_toplevel {
		struct wl_list link;
		struct composter_server *server;
		struct wlr_xwayland_surface *xwayland_surface;
		struct wlr_xdg_toplevel *xdg_toplevel;
		struct wlr_scene_tree *scene_tree;
		struct wl_listener map;
		struct wl_listener unmap;
		struct wl_listener commit;
		struct wl_listener destroy;
		struct wl_listener request_move;
		struct wl_listener request_resize;
		struct wl_listener request_maximize;
		struct wl_listener request_fullscreen;
	};

	struct composter_popup {
		struct wlr_xdg_popup *xdg_popup;
		struct wl_listener commit;
		struct wl_listener destroy;
	};
	
	struct composter_keyboard {
		struct wl_list link;
		struct composter_server *server;
		struct wlr_keyboard *wlr_keyboard;
		struct wl_listener modifiers;
		struct wl_listener key;
		struct wl_listener destroy;
	};

	struct composter_decoration {
		struct wlr_xdg_toplevel_decoration_v1 *xdg_decoration;
		struct wl_listener destroy;
		struct wl_listener request_mode;
	};
]]

local permanent = {}
local queue_free = function(obj) permanent[obj] = nil end

--[[@param pointer ptr_c<unknown>]]
local address_string = function(pointer)
	return string.format("%016x", ffi.cast("uint64_t", pointer))
end

--[[@generic t]]
--[[@param type `t`]]
--[[@return ptr_c<t>]]
local new = function(type)
	local obj = ffi.new("struct " .. type .. "[1]")
	permanent[obj] = true
	return obj
end

--[[@generic t]]
--[[@param type `t`]]
--[[@return ptr_c<t>]]
local cast = function(type, data) return ffi.cast("struct " .. type .. " *", data) end

local server_decoration_mode_by_name = {
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	none = wlr.WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE,
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	client = wlr.WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE,
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	server = wlr.WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE,
}

--[[@type table<string, wlr_xdg_toplevel_decoration_v1_mode>]]
server_decoration_mode_by_name = server_decoration_mode_by_name

mod.keybinds = {} --[[@type table<string, fun(server: composter_server)>]]

mod.hooks = {}
--[[@param server composter_server]]
mod.hooks.on_new_toplevel = function(server) end
--[[@param server composter_server]]
mod.hooks.on_press = function(server) end
--[[@param server composter_server]]
mod.hooks.on_release = function(server) mod.reset_cursor_mode(server) end
--[[@param server composter_server]]
mod.hooks.on_move = function(server) mod.functions.focus_window_below_mouse(server) end
mod.hooks.on_startup = function() end
--[[@param server composter_server]]
mod.hooks.on_exit = function(server) end

mod.functions = {}
--[[@param name string]]
--[[@param value string]]
mod.functions.setenv = function(name, value)
	ffi.C.setenv(name, value, true)
end
--[[@param ... string]]
mod.functions.exec = function(...)
	local pid = ffi.C.fork()
	if pid == 0 then
		local count = select("#", ...)
		local exec_args = ffi.new("const char *[?]", count + 1, { ... })
		exec_args[count] = nil
		local ret = ffi.C.execvp(select(1, ...), exec_args)
		if ret < 0 then
			ffi.C.perror("\x1b[33merr\x1b[0m: composter: exec failed")
		end
		os.exit(ret)
	end
end
--[[@param exec_args string|string[] ]]
mod.functions.exec1 = function(exec_args)
	if type(exec_args) == "string" then
		mod.functions.exec(exec_args)
	else
		mod.functions.exec(unpack(exec_args))
	end
end
--[[@param server composter_server]]
mod.functions.exit = function(server)
	mod.hooks.on_exit(server)
	wl.wl_display_terminate(server[0].wl_display)
end
--[[@param server composter_server]]
mod.functions.focus_window_below_mouse = function(server)
	local toplevel, surface = mod.desktop_toplevel_at(server, server[0].cursor[0].x, server[0].cursor[0].y)
	mod.focus_toplevel(toplevel, surface)
end
--[[@param server composter_server]]
mod.functions.focus_next_window = function(server)
	if wl.wl_list_length(server[0].toplevels) < 2 then return end
	local next_toplevel = wl.wl_container_of(server[0].toplevels.prev, "composter_toplevel", "link")
	mod.focus_toplevel(next_toplevel, next_toplevel[0].xdg_toplevel[0].base[0].surface)
end
--[[@param server composter_server]]
mod.functions.focused_window = function(server)
	return server[0].focused_toplevel
end
--[[@param window composter_toplevel]]
mod.functions.close_window = function(window)
	if window.xwayland_surface ~= nil then
		wlr.wlr_xwayland_surface_close(window.xwayland_surface)
	else
		wlr.wlr_xdg_toplevel_send_close(window.xdg_toplevel)
	end
end
--[[@param server composter_server]]
mod.functions.close_focused_window = function(server)
	mod.functions.close_window(mod.functions.focused_window(server))
end
--[[@param server composter_server]]
--[[@param lx number]]
--[[@param ly number]]
--[[@return composter_toplevel window]]
--[[@return wlr_surface? surface]]
--[[@return number sx]]
--[[@return number sy]]
mod.functions.window_at = function(server, lx, ly)
	return mod.desktop_toplevel_at(server, lx, ly)
end
--[[@param server composter_server]]
--[[@param cursor "invalid"|"default"|"context-menu"|"help"|"pointer"|"progress"|"wait"|"cell"|"crosshair"|"text"|"vertical-text"|"alias"|"copy"|"move"|"no-drop"|"not-allowed"|"grab"|"grabbing"|"e-resize"|"n-resize"|"ne-resize"|"nw-resize"|"s-resize"|"se-resize"|"sw-resize"|"w-resize"|"ew-resize"|"ns-resize"|"nesw-resize"|"nwse-resize"|"col-resize"|"row-resize"|"all-scroll"|"zoom-in"|"zoom-out")]]
mod.functions.set_cursor = function(server, cursor)
	wlr.wlr_cursor_set_xcursor(server[0].cursor, server[0].cursor_manager, cursor)
end

--[[@param toplevel ptr_c<composter_toplevel>]]
--[[@param surface ptr_c<wlr_surface>]]
mod.focus_toplevel = function(toplevel, surface)
	if toplevel == nil then return end
	local server = toplevel[0].server
	local seat = server[0].seat
	local prev_surface = seat[0].keyboard_state.focused_surface
	if prev_surface == surface then return end
	if prev_surface ~= nil then
		local prev_toplevel = wlr.wlr_xdg_toplevel_try_from_wlr_surface(prev_surface)
		if prev_toplevel ~= nil then
			wlr.wlr_xdg_toplevel_set_activated(prev_toplevel, false)
		end
	end
	server[0].focused_toplevel = toplevel
	local keyboard = wlr.wlr_seat_get_keyboard(seat) --[[@type ptr_c<wlr_keyboard>]]
	wlr.wlr_scene_node_raise_to_top(toplevel[0].scene_tree[0].node)
	wl.wl_list_remove(toplevel[0].link)
	wl.wl_list_insert(server[0].toplevels, toplevel[0].link)
	wlr.wlr_xdg_toplevel_set_activated(toplevel[0].xdg_toplevel, true)
	if keyboard ~= nil then
		wlr.wlr_seat_keyboard_notify_enter(seat, toplevel[0].xdg_toplevel[0].base[0].surface, keyboard[0].keycodes,
			keyboard[0].num_keycodes, keyboard[0].modifiers)
	end
end

--[[@type wl_notify_func_t]]
mod.keyboard_handle_modifiers = function(listener, data)
	local keyboard = wl.wl_container_of(listener, "composter_keyboard", "modifiers")
	wlr.wlr_seat_set_keyboard(keyboard[0].server[0].seat, keyboard[0].wlr_keyboard)
	wlr.wlr_seat_keyboard_notify_modifiers(keyboard[0].server[0].seat, keyboard[0].wlr_keyboard[0].modifiers)
end

--[[@type wl_notify_func_t]]
mod.keyboard_handle_key = function(listener, data)
	local keyboard = wl.wl_container_of(listener, "composter_keyboard", "key")
	local server = keyboard[0].server
	local event = cast("wlr_keyboard_key_event", data)
	local seat = server[0].seat
	local keycode = event[0].keycode + 8
	local syms = ffi.cast("const xkb_keysym_t **", ffi.new("xkb_keysym_t *[1]")) --[[@type ptr_c<xkb_keysym_t>]]
	local nsyms = xkb.xkb_state_key_get_syms(keyboard[0].wlr_keyboard[0].xkb_state, keycode, syms)
	local handled = false
	local modifiers = wlr.wlr_keyboard_get_modifiers(keyboard[0].wlr_keyboard)
	local mod_str = ""
	if event[0].state == wl.WL_KEYBOARD_KEY_STATE_PRESSED then
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		if bit.band(modifiers, wlr.WLR_MODIFIER_CTRL) ~= 0 then mod_str = mod_str .. "ctrl+" end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		if bit.band(modifiers, wlr.WLR_MODIFIER_SHIFT) ~= 0 then mod_str = mod_str .. "shift+" end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		if bit.band(modifiers, wlr.WLR_MODIFIER_ALT) ~= 0 then mod_str = mod_str .. "alt+" end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		if bit.band(modifiers, wlr.WLR_MODIFIER_LOGO) ~= 0 then mod_str = mod_str .. "meta+" end
		for i = 0, nsyms - 1 do
			local key_str = mod_str .. keysym_rev[syms[0][i]]
			local keybind = mod.keybinds[key_str]
			if keybind then
				handled = keybind(server) ~= false
			end
		end
	end
	if not handled then
		wlr.wlr_seat_set_keyboard(seat, keyboard[0].wlr_keyboard)
		wlr.wlr_seat_keyboard_notify_key(seat, event[0].time_msec, event[0].keycode, event[0].state)
	end
end

--[[@type wl_notify_func_t]]
mod.keyboard_handle_destroy = function(listener, data)
	local keyboard = wl.wl_container_of(listener, "composter_keyboard", "destroy")
	wl.wl_list_remove(keyboard[0].modifiers.link)
	wl.wl_list_remove(keyboard[0].key.link)
	wl.wl_list_remove(keyboard[0].destroy.link)
	wl.wl_list_remove(keyboard[0].link)
	queue_free(keyboard)
end

--[[@param server composter_server]]
--[[@param device wlr_input_device]]
mod.server_new_keyboard = function(server, device)
	local wlr_keyboard = wlr.wlr_keyboard_from_input_device(device) --[[@type ptr_c<wlr_keyboard>]]
	local keyboard = new("composter_keyboard")
	keyboard[0].server = server
	keyboard[0].wlr_keyboard = wlr_keyboard
	local context = xkb.xkb_context_new(xkb.XKB_CONTEXT_NO_FLAGS)
	local keymap = xkb.xkb_keymap_new_from_names(context, nil, xkb.XKB_KEYMAP_COMPILE_NO_FLAGS)
	wlr.wlr_keyboard_set_keymap(wlr_keyboard, keymap)
	xkb.xkb_keymap_unref(keymap)
	xkb.xkb_context_unref(context)
	wlr.wlr_keyboard_set_repeat_info(wlr_keyboard, mod.variables.key_repeats_per_sec, mod.variables.key_repeat_delay_ms)
	keyboard[0].modifiers.notify = mod.keyboard_handle_modifiers
	wl.wl_signal_add(wlr_keyboard[0].events.modifiers, keyboard[0].modifiers)
	keyboard[0].key.notify = mod.keyboard_handle_key
	wl.wl_signal_add(wlr_keyboard[0].events.key, keyboard[0].key)
	keyboard[0].destroy.notify = mod.keyboard_handle_destroy
	wl.wl_signal_add(device.events.destroy, keyboard[0].destroy)
	wlr.wlr_seat_set_keyboard(server[0].seat, keyboard[0].wlr_keyboard)
	wl.wl_list_insert(server[0].keyboards, keyboard[0].link)
end

--[[@param server composter_server]]
--[[@param device wlr_input_device]]
mod.server_new_pointer = function(server, device)
	wlr.wlr_cursor_attach_input_device(server[0].cursor, device)
end

local device_type_name = { [0] = "keyboard", "pointer", "touch", "tablet", "tablet pad", "switch" }

--[[@type wl_notify_func_t]]
mod.server_new_input = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "new_input")
	local device = cast("wlr_input_device", data)
	if device[0].type == wlr.WLR_INPUT_DEVICE_KEYBOARD then
		mod.server_new_keyboard(server, device)
	elseif device[0].type == wlr.WLR_INPUT_DEVICE_POINTER then
		mod.server_new_pointer(server, device)
	else
		wlr._wlr_log(wlr.WLR_ERROR, "unknown input device type: %s", device_type_name[tonumber(device[0].type)])
	end
	local caps = wl.WL_SEAT_CAPABILITY_POINTER
	if wl.wl_list_empty(server[0].keyboards) == 0 then
		caps = bit.bor(caps, wl.WL_SEAT_CAPABILITY_KEYBOARD)
	end
	wlr.wlr_seat_set_capabilities(server[0].seat, caps)
end

--[[@type wl_notify_func_t]]
mod.seat_request_cursor = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "request_cursor")
	local event = cast("wlr_seat_pointer_request_set_cursor_event", data)
	local focused_client = server[0].seat[0].pointer_state.focused_client
	if focused_client == event[0].seat_client then
		wlr.wlr_cursor_set_surface(server[0].cursor, event[0].surface, event[0].hotspot_x, event[0].hotspot_y)
	end
end

--[[@type wl_notify_func_t]]
mod.seat_request_set_selection = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "request_set_selection")
	local event = cast("wlr_seat_request_set_selection_event", data)
	wlr.wlr_seat_set_selection(server[0].seat, event[0].source, event[0].serial)
end

local static_sx = ffi.new("double[1]") --[[@type ptr_c<number>]]
local static_sy = ffi.new("double[1]") --[[@type ptr_c<number>]]

--[[@param server composter_server]]
--[[@param lx number]]
--[[@param ly number]]
--[[@return ptr_c<composter_toplevel> toplevel]]
--[[@return ptr_c<wlr_surface> surface]]
--[[@return number sx]]
--[[@return number sy]]
mod.desktop_toplevel_at = function(server, lx, ly)
	local node = wlr.wlr_scene_node_at(server[0].scene[0].tree.node, lx, ly, static_sx, static_sy)
	--[[@diagnostic disable-next-line: return-type-mismatch, missing-return-value]]
	if node == nil or node[0].type ~= wlr.WLR_SCENE_NODE_BUFFER then return nil end
	local scene_buffer = wlr.wlr_scene_buffer_from_node(node)
	local scene_surface = wlr.wlr_scene_surface_try_from_buffer(scene_buffer)
	--[[@diagnostic disable-next-line: return-type-mismatch, missing-return-value]]
	if scene_surface == nil then return nil end
	local tree = node[0].parent
	while tree ~= nil and tree[0].node.data == nil do
		tree = tree[0].node.parent
	end
	return cast("composter_toplevel", tree[0].node.data), scene_surface[0].surface, static_sx[0], static_sy[0]
end

--[[@param server composter_server]]
mod.reset_cursor_mode = function(server)
	server[0].cursor_mode = composter_cursor_mode.passthrough
	server[0].grabbed_toplevel = nil
end

--[[@param server composter_server]]
--[[@param time integer]]
mod.process_cursor_move = function(server, time)
	local toplevel = server[0].grabbed_toplevel
	wlr.wlr_scene_node_set_position(toplevel[0].scene_tree[0].node, server[0].cursor[0].x - server[0].grab_x,
		server[0].cursor[0].y - server[0].grab_y)
end

--[[@param server composter_server]]
--[[@param time integer]]
mod.process_cursor_resize = function(server, time)
	local toplevel = server[0].grabbed_toplevel
	local border_x = server[0].cursor[0].x - server[0].grab_x
	local border_y = server[0].cursor[0].y - server[0].grab_y
	local new_left = server[0].grab_geobox.x --[[@type number]]
	local new_right = server[0].grab_geobox.x + server[0].grab_geobox.width --[[@type number]]
	local new_top = server[0].grab_geobox.y --[[@type number]]
	local new_bottom = server[0].grab_geobox.y + server[0].grab_geobox.height --[[@type number]]
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if bit.band(server[0].resize_edges, wlr.WLR_EDGE_TOP) ~= 0 then
		new_top = math.min(border_y, new_bottom - 1)
		--[[@diagnostic disable-next-line: param-type-mismatch]]
	elseif bit.band(server[0].resize_edges, wlr.WLR_EDGE_BOTTOM) ~= 0 then
		new_bottom = math.max(border_y, new_top + 1)
	end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if bit.band(server[0].resize_edges, wlr.WLR_EDGE_LEFT) ~= 0 then
		new_left = math.min(border_x, new_right - 1)
		--[[@diagnostic disable-next-line: param-type-mismatch]]
	elseif bit.band(server[0].resize_edges, wlr.WLR_EDGE_RIGHT) ~= 0 then
		new_right = math.max(border_x, new_left + 1)
	end
	local geo_box
	wlr.wlr_xdg_surface_get_geometry(toplevel[0].xdg_toplevel[0].base, geo_box)
	wlr.wlr_scene_node_set_position(toplevel[0].scene_tree[0].node, new_left - geo_box.x, new_top - geo_box.y)
	local new_width = new_right - new_left
	local new_height = new_bottom - new_top
	wlr.wlr_xdg_toplevel_set_size(toplevel[0].xdg_toplevel, new_width, new_height)
end

--[[@param server composter_server]]
--[[@param time integer]]
mod.process_cursor_motion = function(server, time)
	if server[0].cursor_mode == composter_cursor_mode.move then
		mod.process_cursor_move(server, time)
		return
	elseif server[0].cursor_mode == composter_cursor_mode.resize then
		mod.process_cursor_resize(server, time)
		return
	end
	local seat = server[0].seat[0]
	local toplevel, surface, sx, sy = mod.desktop_toplevel_at(server, server[0].cursor[0].x, server[0].cursor[0].y)
	if toplevel == nil then
		wlr.wlr_cursor_set_xcursor(server[0].cursor, server[0].cursor_manager, "default")
	end
	if surface ~= nil then
		wlr.wlr_seat_pointer_notify_enter(seat, surface, sx, sy)
		wlr.wlr_seat_pointer_notify_motion(seat, time, sx, sy)
	else
		wlr.wlr_seat_pointer_clear_focus(seat)
	end
	mod.hooks.on_move(server)
end

--[[@type wl_notify_func_t]]
mod.server_cursor_motion = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "cursor_motion")
	local event = cast("wlr_pointer_motion_event", data)
	wlr.wlr_cursor_move(server[0].cursor, event[0].pointer[0].base, event[0].delta_x, event[0].delta_y)
	mod.process_cursor_motion(server, event[0].time_msec)
end

--[[@type wl_notify_func_t]]
mod.server_cursor_motion_absolute = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "cursor_motion_absolute")
	local event = cast("wlr_pointer_motion_absolute_event", data)
	wlr.wlr_cursor_warp_absolute(server[0].cursor, event[0].pointer[0].base, event[0].x, event[0].y)
	mod.process_cursor_motion(server, event[0].time_msec)
end

--[[@type wl_notify_func_t]]
mod.server_cursor_button = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "cursor_button")
	local event = cast("wlr_pointer_button_event", data)
	wlr.wlr_seat_pointer_notify_button(server[0].seat, event[0].time_msec, event[0].button, event[0].state)
	if event[0].state == wl.WL_POINTER_BUTTON_STATE_RELEASED then
		mod.hooks.on_release(server)
	else
		mod.hooks.on_press(server)
	end
end

--[[@type wl_notify_func_t]]
mod.server_cursor_axis = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "cursor_axis")
	local event = cast("wlr_pointer_axis_event", data)
	wlr.wlr_seat_pointer_notify_axis(server[0].seat, event[0].time_msec, event[0].orientation, event[0].delta,
		event[0].delta_discrete,
		event[0].source, event[0].relative_direction)
end

--[[@type wl_notify_func_t]]
mod.server_cursor_frame = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "cursor_frame")
	wlr.wlr_seat_pointer_notify_frame(server[0].seat)
end

local now = ffi.new("struct timespec[1]") --[[@type ptr_c<timespec_c>]]

--[[@type wl_notify_func_t]]
mod.output_frame = function(listener, data)
	local output = wl.wl_container_of(listener, "composter_output", "frame")
	local scene = output[0].server[0].scene[0]
	local scene_output = wlr.wlr_scene_get_scene_output(scene, output[0].wlr_output) --[[@type ptr_c<wlr_scene_output>]]
	wlr.wlr_scene_output_commit(scene_output, nil)
	ffi.C.clock_gettime(1 --[[CLOCK_MONOTONIC]], now)
	wlr.wlr_scene_output_send_frame_done(scene_output, now)
end

--[[@type wl_notify_func_t]]
mod.output_request_state = function(listener, data)
	local output = wl.wl_container_of(listener, "composter_output", "request_state")
	local event = cast("wlr_output_event_request_state", data)
	wlr.wlr_output_commit_state(output[0].wlr_output, event[0].state)
end

--[[@type wl_notify_func_t]]
mod.output_destroy = function(listener, data)
	local output = wl.wl_container_of(listener, "composter_output", "destroy")
	wl.wl_list_remove(output[0].frame.link)
	wl.wl_list_remove(output[0].request_state.link)
	wl.wl_list_remove(output[0].destroy.link)
	wl.wl_list_remove(output[0].link)
	queue_free(output)
end

--[[@type wl_notify_func_t]]
mod.server_new_output = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "new_output")
	local wlr_output = cast("wlr_output", data)
	wlr.wlr_output_init_render(wlr_output, server[0].allocator, server[0].renderer)
	local state = new("wlr_output_state")
	wlr.wlr_output_state_init(state)
	wlr.wlr_output_state_set_enabled(state, true)
	local mode = wlr.wlr_output_preferred_mode(wlr_output)
	if mode ~= nil then wlr.wlr_output_state_set_mode(state, mode) end
	wlr.wlr_output_commit_state(wlr_output, state)
	wlr.wlr_output_state_finish(state)
	local output = new("composter_output")
	output[0].wlr_output = wlr_output
	output[0].server = server
	output[0].frame.notify = mod.output_frame
	wl.wl_signal_add(wlr_output[0].events.frame, output[0].frame)
	output[0].request_state.notify = mod.output_request_state
	wl.wl_signal_add(wlr_output[0].events.request_state, output[0].request_state)
	output[0].destroy.notify = mod.output_destroy
	wl.wl_signal_add(wlr_output[0].events.destroy, output[0].destroy)
	wl.wl_list_insert(server[0].outputs, output[0].link)
	local layout_output = wlr.wlr_output_layout_add_auto(server[0].output_layout, wlr_output)
	local scene_output = wlr.wlr_scene_output_create(server[0].scene, wlr_output)
	wlr.wlr_scene_output_layout_add_output(server[0].scene_layout, layout_output, scene_output)
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_map = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "map")
	wl.wl_list_insert(toplevel[0].server[0].toplevels, toplevel[0].link)
	mod.focus_toplevel(toplevel, toplevel[0].xdg_toplevel[0].base[0].surface)
	local xdg_toplevel = toplevel[0].xdg_toplevel
	if ipc_clients then
		ipc_send_event({
			type = "new_window",
			version = 1,
			title = ffi.string(xdg_toplevel[0].title),
			app_id = ffi.string(xdg_toplevel[0].app_id),
			address = address_string(toplevel),
		})
	end
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_unmap = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "unmap")
	if toplevel == toplevel[0].server[0].grabbed_toplevel[0] then
		mod.reset_cursor_mode(toplevel[0].server)
	end
	wl.wl_list_remove(toplevel[0].link)
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_commit = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "commit")
	if toplevel[0].xdg_toplevel[0].base[0].initial_commit then
		wlr.wlr_xdg_toplevel_set_size(toplevel[0].xdg_toplevel, 0, 0)
	end
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_destroy = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "destroy")
	wl.wl_list_remove(toplevel[0].map.link)
	wl.wl_list_remove(toplevel[0].unmap.link)
	wl.wl_list_remove(toplevel[0].commit.link)
	wl.wl_list_remove(toplevel[0].destroy.link)
	wl.wl_list_remove(toplevel[0].request_move.link)
	wl.wl_list_remove(toplevel[0].request_resize.link)
	wl.wl_list_remove(toplevel[0].request_maximize.link)
	wl.wl_list_remove(toplevel[0].request_fullscreen.link)
	queue_free(toplevel)
end

--[[@param toplevel composter_toplevel]]
--[[@param mode composter_cursor_mode]]
--[[@param edges integer]]
mod.begin_interactive = function(toplevel, mode, edges)
	local server = toplevel[0].server[0]
	local focused_surface = server[0].seat[0].pointer_state.focused_surface
	if toplevel[0].xdg_toplevel[0].base[0].surface ~= wlr.wlr_surface_get_root_surface(focused_surface) then
		return
	end
	server[0].grabbed_toplevel = toplevel
	server[0].cursor_mode = mode
	if mode == composter_cursor_mode.move then
		server[0].grab_x = server[0].cursor[0].x - toplevel[0].scene_tree[0].node.x
		server[0].grab_y = server[0].cursor[0].y - toplevel[0].scene_tree[0].node.y
	else
		local geo_box = ffi.new("struct wlr_box *") --[[@type ptr_c<wlr_box>]]
		wlr.wlr_xdg_surface_get_geometry(toplevel[0].xdg_toplevel[0].base, geo_box)
		local border_x = (toplevel[0].scene_tree[0].node.x + geo_box[0].x) +
				--[[@diagnostic disable-next-line: param-type-mismatch]]
				(bit.band(edges, wlr.WLR_EDGE_RIGHT) ~= 0 and geo_box[0].width or 0)
		local border_y = (toplevel[0].scene_tree[0].node.y + geo_box[0].y) +
				--[[@diagnostic disable-next-line: param-type-mismatch]]
				(bit.band(edges, wlr.WLR_EDGE_BOTTOM) ~= 0 and geo_box[0].height or 0)
		server[0].grab_x = server[0].cursor[0].x - border_x
		server[0].grab_y = server[0].cursor[0].y - border_y
		server[0].grab_geobox = geo_box
		server[0].grab_geobox.x = server[0].grab_geobox.x + toplevel[0].scene_tree[0].node.x
		server[0].grab_geobox.y = server[0].grab_geobox.y + toplevel[0].scene_tree[0].node.y
		server[0].resize_edges = edges
	end
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_request_move = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "request_move")
	mod.begin_interactive(toplevel, composter_cursor_mode.move, 0)
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_request_resize = function(listener, data)
	local event = cast("wlr_xdg_toplevel_resize_event", data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "request_resize")
	mod.begin_interactive(toplevel, composter_cursor_mode.resize, event[0].edges)
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_request_maximize = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "request_maximize")
	if toplevel[0].xdg_toplevel[0].base[0].initialized then
		wlr.wlr_xdg_surface_schedule_configure(toplevel[0].xdg_toplevel[0].base)
	end
end

--[[@type wl_notify_func_t]]
mod.xdg_toplevel_request_fullscreen = function(listener, data)
	local toplevel = wl.wl_container_of(listener, "composter_toplevel", "request_fullscreen")
	if toplevel[0].xdg_toplevel[0].base[0].initialized then
		wlr.wlr_xdg_surface_schedule_configure(toplevel[0].xdg_toplevel[0].base)
	end
end

--[[@type wl_notify_func_t]]
mod.server_new_xdg_toplevel = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "new_xdg_toplevel")
	local xdg_toplevel = cast("wlr_xdg_toplevel", data)
	local toplevel = new("composter_toplevel")
	toplevel[0].server = server
	toplevel[0].xdg_toplevel = xdg_toplevel
	toplevel[0].scene_tree = wlr.wlr_scene_xdg_surface_create(toplevel[0].server[0].scene[0].tree, xdg_toplevel[0].base)
	toplevel[0].scene_tree[0].node.data = toplevel
	xdg_toplevel[0].base[0].data = toplevel[0].scene_tree
	toplevel[0].map.notify = mod.xdg_toplevel_map
	wl.wl_signal_add(xdg_toplevel[0].base[0].surface[0].events.map, toplevel[0].map)
	toplevel[0].unmap.notify = mod.xdg_toplevel_unmap
	wl.wl_signal_add(xdg_toplevel[0].base[0].surface[0].events.unmap, toplevel[0].unmap)
	toplevel[0].commit.notify = mod.xdg_toplevel_commit
	wl.wl_signal_add(xdg_toplevel[0].base[0].surface[0].events.commit, toplevel[0].commit)
	toplevel[0].destroy.notify = mod.xdg_toplevel_destroy
	wl.wl_signal_add(xdg_toplevel[0].events.destroy, toplevel[0].destroy)
	toplevel[0].request_move.notify = mod.xdg_toplevel_request_move
	wl.wl_signal_add(xdg_toplevel[0].events.request_move, toplevel[0].request_move)
	toplevel[0].request_resize.notify = mod.xdg_toplevel_request_resize
	wl.wl_signal_add(xdg_toplevel[0].events.request_resize, toplevel[0].request_resize)
	toplevel[0].request_maximize.notify = mod.xdg_toplevel_request_maximize
	wl.wl_signal_add(xdg_toplevel[0].events.request_maximize, toplevel[0].request_maximize)
	toplevel[0].request_fullscreen.notify = mod.xdg_toplevel_request_fullscreen
	wl.wl_signal_add(xdg_toplevel[0].events.request_fullscreen, toplevel[0].request_fullscreen)
	mod.hooks.on_new_toplevel(server)
end

--[[@type wl_notify_func_t]]
mod.xdg_popup_commit = function(listener, data)
	local popup = wl.wl_container_of(listener, "composter_popup", "commit")
	local base = popup[0].xdg_popup[0].base[0]
	if base.initial_commit then
		wlr.wlr_xdg_surface_schedule_configure(base)
	end
end

--[[@type wl_notify_func_t]]
mod.xdg_popup_destroy = function(listener, data)
	local popup = wl.wl_container_of(listener, "composter_popup", "destroy")
	wl.wl_list_remove(popup[0].commit.link)
	wl.wl_list_remove(popup[0].destroy.link)
	queue_free(popup)
end

--[[@type wl_notify_func_t]]
mod.server_new_xdg_popup = function(listener, data)
	local xdg_popup = cast("wlr_xdg_popup", data)
	local popup = new("composter_popup")
	popup[0].xdg_popup = xdg_popup
	local parent = wlr.wlr_xdg_surface_try_from_wlr_surface(xdg_popup[0].parent)
	assert(parent ~= nil, "composter: server_new_xdg_popup: parent must not be NULL")
	local parent_tree = parent[0].data[0]
	xdg_popup[0].base[0].data = wlr.wlr_scene_xdg_surface_create(parent_tree, xdg_popup[0].base)
	popup[0].commit.notify = mod.xdg_popup_commit
	wl.wl_signal_add(xdg_popup[0].base[0].surface[0].events.commit, popup[0].commit)
	popup[0].destroy.notify = mod.xdg_popup_destroy
	wl.wl_signal_add(xdg_popup[0].events.destroy, popup[0].destroy)
end

--[[@type wl_notify_func_t]]
mod.server_new_xwayland_surface = function(listener, data)
	local server = wl.wl_container_of(listener, "composter_server", "new_xwayland_surface")
	local xwayland_surface = cast("wlr_xwayland_surface", data)
	local toplevel = new("composter_toplevel")
	toplevel[0].server = server
	toplevel[0].xwayland_surface = xwayland_surface
	toplevel[0].destroy.notify = mod.xdg_toplevel_destroy
	wl.wl_signal_add(xwayland_surface[0].events.destroy, toplevel[0].destroy)
	toplevel[0].request_move.notify = mod.xdg_toplevel_request_move
	wl.wl_signal_add(xwayland_surface[0].events.request_move, toplevel[0].request_move)
	toplevel[0].request_resize.notify = mod.xdg_toplevel_request_resize
	wl.wl_signal_add(xwayland_surface[0].events.request_resize, toplevel[0].request_resize)
	toplevel[0].request_maximize.notify = mod.xdg_toplevel_request_maximize
	wl.wl_signal_add(xwayland_surface[0].events.request_maximize, toplevel[0].request_maximize)
	toplevel[0].request_fullscreen.notify = mod.xdg_toplevel_request_fullscreen
	wl.wl_signal_add(xwayland_surface[0].events.request_fullscreen, toplevel[0].request_fullscreen)
end

--[[@type wl_notify_func_t]]
mod.xdg_decoration_request_mode = function(listener, data)
	local decoration = wl.wl_container_of(listener, "composter_decoration", "request_mode")
	wlr.wlr_xdg_toplevel_decoration_v1_set_mode(decoration[0].xdg_decoration,
		decoration[0].xdg_decoration[0].requested_mode)
end

--[[@type wl_notify_func_t]]
mod.xdg_decoration_destroy = function(listener, data)
	local decoration = wl.wl_container_of(listener, "composter_decoration", "destroy")
	wl.wl_list_remove(decoration[0].request_mode.link)
	wl.wl_list_remove(decoration[0].destroy.link)
	queue_free(decoration)
end

--[[@type wl_notify_func_t]]
mod.server_new_xdg_decoration = function(listener, data)
	local xdg_decoration = cast("wlr_xdg_toplevel_decoration_v1", data)
	local decoration = new("composter_decoration")
	decoration[0].xdg_decoration = xdg_decoration
	xdg_decoration[0].scheduled_mode = server_decoration_mode_by_name[mod.variables.default_server_decoration_mode]
	decoration[0].destroy.notify = mod.xdg_decoration_destroy
	wl.wl_signal_add(xdg_decoration[0].events.destroy, decoration[0].destroy)
	decoration[0].request_mode.notify = mod.xdg_decoration_request_mode
	wl.wl_signal_add(xdg_decoration[0].events.destroy, decoration[0].destroy)
end

local log_level_string = os.getenv("WLR_LOG_LEVEL") or os.getenv("COMPOSTER_LOG_LEVEL")
if log_level_string then log_level_string = log_level_string:upper() end
local log_level = tonumber(log_level_string) or wlr.WLR_INFO
if log_level_string and log_level_string:find("[A-Z]") then
	log_level = wlr[log_level_string:find("^WLR_") and log_level_string:upper() or ("WLR_" .. log_level_string:upper())]
end

mod.run = function(init_log)
	if init_log ~= false then wlr.wlr_log_init(log_level, nil) end
	local server = new("composter_server")
	server[0].wl_display = wl.wl_display_create()
	local loop = wl.wl_display_get_event_loop(server[0].wl_display)
	server[0].backend = wlr.wlr_backend_autocreate(loop, nil)
	if server[0].backend == nil then
		wlr._wlr_log(wlr.WLR_ERROR, "failed to create wlr_backend")
		return 1
	end
	server[0].renderer = wlr.wlr_renderer_autocreate(server[0].backend)
	if server[0].renderer == nil then
		wlr._wlr_log(wlr.WLR_ERROR, "failed to create wlr_renderer")
		return 1
	end
	wlr.wlr_renderer_init_wl_display(server[0].renderer, server[0].wl_display)
	server[0].allocator = wlr.wlr_allocator_autocreate(server[0].backend, server[0].renderer)
	if server[0].allocator == nil then
		wlr._wlr_log(wlr.WLR_ERROR, "failed to create wlr_allocator")
		return 1
	end
	local compositor = wlr.wlr_compositor_create(server[0].wl_display, 5, server[0].renderer)
	wlr.wlr_subcompositor_create(server[0].wl_display)
	wlr.wlr_data_device_manager_create(server[0].wl_display)
	server[0].output_layout = wlr.wlr_output_layout_create(server[0].wl_display)
	wl.wl_list_init(server[0].outputs)
	server[0].new_output.notify = mod.server_new_output
	wl.wl_signal_add(server[0].backend[0].events.new_output, server[0].new_output)
	server[0].scene = wlr.wlr_scene_create()
	server[0].scene_layout = wlr.wlr_scene_attach_output_layout(server[0].scene, server[0].output_layout)
	wl.wl_list_init(server[0].toplevels)
	server[0].xdg_shell = wlr.wlr_xdg_shell_create(server[0].wl_display, 3)
	server[0].new_xdg_toplevel.notify = mod.server_new_xdg_toplevel
	wl.wl_signal_add(server[0].xdg_shell[0].events.new_toplevel, server[0].new_xdg_toplevel)
	server[0].new_xdg_popup.notify = mod.server_new_xdg_popup
	wl.wl_signal_add(server[0].xdg_shell[0].events.new_popup, server[0].new_xdg_popup)
	server[0].xwayland = wlr.wlr_xwayland_create(server[0].wl_display, compositor, true)
	server[0].new_xwayland_surface.notify = mod.server_new_xwayland_surface
	wl.wl_signal_add(server[0].xwayland[0].events.new_surface, server[0].new_xwayland_surface)
	server[0].xdg_decoration_manager = wlr.wlr_xdg_decoration_manager_v1_create(server[0].wl_display)
	server[0].new_toplevel_decoration.notify = mod.server_new_xdg_decoration
	wl.wl_signal_add(server[0].xdg_decoration_manager[0].events.new_toplevel_decoration, server[0].new_toplevel_decoration)
	server[0].cursor = wlr.wlr_cursor_create()
	wlr.wlr_cursor_attach_output_layout(server[0].cursor, server[0].output_layout)
	server[0].cursor_manager = wlr.wlr_xcursor_manager_create(mod.variables.cursor_name, mod.variables.cursor_size_px)
	server[0].cursor_mode = composter_cursor_mode.passthrough
	server[0].cursor_motion.notify = mod.server_cursor_motion
	wl.wl_signal_add(server[0].cursor[0].events.motion, server[0].cursor_motion)
	server[0].cursor_motion_absolute.notify = mod.server_cursor_motion_absolute
	wl.wl_signal_add(server[0].cursor[0].events.motion_absolute, server[0].cursor_motion_absolute)
	server[0].cursor_button.notify = mod.server_cursor_button
	wl.wl_signal_add(server[0].cursor[0].events.button, server[0].cursor_button)
	server[0].cursor_axis.notify = mod.server_cursor_axis
	wl.wl_signal_add(server[0].cursor[0].events.axis, server[0].cursor_axis)
	server[0].cursor_frame.notify = mod.server_cursor_frame
	wl.wl_signal_add(server[0].cursor[0].events.frame, server[0].cursor_frame)
	wl.wl_list_init(server[0].keyboards)
	server[0].new_input.notify = mod.server_new_input
	wl.wl_signal_add(server[0].backend[0].events.new_input, server[0].new_input)
	server[0].seat = wlr.wlr_seat_create(server[0].wl_display, mod.variables.seat_name)
	server[0].request_cursor.notify = mod.seat_request_cursor
	wl.wl_signal_add(server[0].seat[0].events.request_set_cursor, server[0].request_cursor)
	server[0].request_set_selection.notify = mod.seat_request_set_selection
	wl.wl_signal_add(server[0].seat[0].events.request_set_selection, server[0].request_set_selection)
	local socket = wl.wl_display_add_socket_auto(server[0].wl_display)
	if socket == nil then
		wlr.wlr_backend_destroy(server[0].backend)
		return 1
	end
	if not wlr.wlr_backend_start(server[0].backend) then
		wlr.wlr_backend_destroy(server[0].backend)
		wl.wl_display_destroy(server[0].wl_display)
		return 1
	end
	ffi.C.setenv("WAYLAND_DISPLAY", socket, true)
	mod.hooks.on_startup()
	wlr._wlr_log(wlr.WLR_INFO, "running wayland compositor on WAYLAND_DISPLAY=%s", socket)
	if not mod.variables.ipc then
		wl.wl_display_run(server[0].wl_display)
	else
		local epoll = require("dep.epoll").new()
		value_to_json = require("dep.lunajson").value_to_json
		local epoll_running = true
		local wl_fd = wl.wl_event_loop_get_fd(loop)
		epoll:add(wl_fd, function()
			wl.wl_display_flush_clients(server[0].wl_display)
			if wl.wl_event_loop_dispatch(loop, -1) < 0 then epoll_running = false end
		end)
		local ipc_path = os.getenv("XDG_RUNTIME_DIR") .. "/composter-events.sock"
		os.remove(ipc_path)
		require("lib.socket.server").server(function()
			return ""
			--[[@diagnostic disable-next-line: param-type-mismatch]]
		end, ipc_path, epoll, "unix", function(client)
			ipc_clients = ipc_clients or {}
			ipc_clients[client] = true
		end, function(client)
			if not ipc_clients then return end
			ipc_clients[client] = nil
			local first_key = next(ipc_clients)
			if not first_key then ipc_clients = nil end
		end)
		ffi.C.setenv("COMPOSTER_IPC_PATH", ipc_path, true)
		wl.wl_display_flush_clients(server[0].wl_display)
		while epoll_running do epoll:wait() end
		assert(os.remove(ipc_path))
	end
	wl.wl_display_destroy_clients(server[0].wl_display)
	wlr.wlr_scene_node_destroy(server[0].scene[0].tree.node)
	wlr.wlr_xcursor_manager_destroy(server[0].cursor_manager)
	wlr.wlr_cursor_destroy(server[0].cursor)
	wlr.wlr_allocator_destroy(server[0].allocator)
	wlr.wlr_renderer_destroy(server[0].renderer)
	wlr.wlr_backend_destroy(server[0].backend)
	wl.wl_display_destroy(server[0].wl_display)
	queue_free(server)
end

if pcall(debug.getlocal, 4, 1) then
	return mod
else
	wlr.wlr_log_init(log_level, nil)
	--[[@diagnostic disable-next-line: lowercase-global]]
	composter = mod
	local config_path = args.config
	args.config = nil
	for k, v in pairs(args) do
		if k ~= "" or type(v) ~= "table" and #v > 0 then
			wlr._wlr_log(wlr.WLR_ERROR, "unknown command-line argument %s=%s", k,
				(type(v) == "table" and ("{" .. table.concat(v, ", ") .. "}") or v))
		end
	end
	if config_path then
		dofile(tostring(config_path))
	else
		local success
		success = pcall(dofile, tostring(os.getenv("HOME") .. "/.config/composter/config.lua"))
		if not success then
			local default_config_path = assert(here):gsub("/composter.lua$", "/composter/default_config.lua")
			wlr._wlr_log(wlr.WLR_INFO, "config not found at ~/.config/composter/config.lua, using default config at %s",
				default_config_path:gsub(os.getenv("HOME") or "", "~"))
			dofile(default_config_path)
		end
	end
	mod.run(false)
end

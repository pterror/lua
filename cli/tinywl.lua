#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then
	arg = { ... }
else
	package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path
end

local ffi = require("ffi")
local wlr = require("dep.wlroots")
local wl = require("dep.wayland_server")

--[[@enum tinywl_cursor_mode]]
local tinywl_cursor_mode = { passthrough = 0, move = 1, resize = 2 }

ffi.cdef [[
	enum tinywl_cursor_mode {
		TINYWL_CURSOR_PASSTHROUGH,
		TINYWL_CURSOR_MOVE,
		TINYWL_CURSOR_RESIZE,
	};
	
	struct tinywl_server {
		struct wl_display *wl_display;
		struct wlr_backend *backend;
		struct wlr_renderer *renderer;
		struct wlr_allocator *allocator;
		struct wlr_scene *scene;
		struct wlr_scene_output_layout *scene_layout;
	
		struct wlr_xdg_shell *xdg_shell;
		struct wl_listener new_xdg_toplevel;
		struct wl_listener new_xdg_popup;
		struct wl_list toplevels;
	
		struct wlr_cursor *cursor;
		struct wlr_xcursor_manager *cursor_mgr;
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
		enum tinywl_cursor_mode cursor_mode;
		struct tinywl_toplevel *grabbed_toplevel;
		double grab_x, grab_y;
		struct wlr_box grab_geobox;
		uint32_t resize_edges;
	
		struct wlr_output_layout *output_layout;
		struct wl_list outputs;
		struct wl_listener new_output;
	};
	
	struct tinywl_output {
		struct wl_list link;
		struct tinywl_server *server;
		struct wlr_output *wlr_output;
		struct wl_listener frame;
		struct wl_listener request_state;
		struct wl_listener destroy;
	};
	
	struct tinywl_toplevel {
		struct wl_list link;
		struct tinywl_server *server;
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
	
	struct tinywl_popup {
		struct wlr_xdg_popup *xdg_popup;
		struct wl_listener commit;
		struct wl_listener destroy;
	};
	
	struct tinywl_keyboard {
		struct wl_list link;
		struct tinywl_server *server;
		struct wlr_keyboard *wlr_keyboard;
		struct wl_listener modifiers;
		struct wl_listener key;
		struct wl_listener destroy;
	};	
]]

local mod = {}

--[[@param toplevel ptr_c<tinywl_toplevel>]]
--[[@param surface ptr_c<wlr_surface>]]
mod.focus_toplevel = function(toplevel, surface)
	--[[Note: this function only deals with keyboard focus.]]
	if toplevel == nil then
		return
	end
	local server = toplevel[0].server
	local seat = server[0].seat
	local prev_surface = seat[0].keyboard_state.focused_surface
	if prev_surface == surface then
		--[[Don't re-focus an already focused surface.]]
		return
	end
	if prev_surface ~= nil then
		--[[
		 * Deactivate the previously focused surface. This lets the client know
		 * it no longer has focus and the client will repaint accordingly, e.g.
		 * stop displaying a caret.
		 ]]
		local prev_toplevel =
				wlr.wlr_xdg_toplevel_try_from_wlr_surface(prev_surface)
		if prev_toplevel ~= nil then
			wlr.wlr_xdg_toplevel_set_activated(prev_toplevel, false)
		end
	end
	local keyboard = wlr.wlr_seat_get_keyboard(seat)
	--[[Move the toplevel to the front]]
	wlr.wlr_scene_node_raise_to_top(toplevel[0].scene_tree[0].node)
	wl.wl_list_remove(toplevel[0].link)
	wl.wl_list_insert(server[0].toplevels, toplevel[0].link)
	--[[Activate the new surface]]
	wlr.wlr_xdg_toplevel_set_activated(toplevel[0].xdg_toplevel, true)
	--[[
	 * Tell the seat to have the keyboard enter this surface. wlroots will keep
	 * track of this and automatically send key events to the appropriate
	 * clients without additional work on your part.
	 ]]
	if keyboard ~= nil then
		wlr.wlr_seat_keyboard_notify_enter(seat, toplevel[0].xdg_toplevel[0].base[0].surface,
			keyboard[0].keycodes, keyboard[0].num_keycodes, keyboard[0].modifiers)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.keyboard_handle_modifiers = function(listener, data)
	--[[ This event is raised when a modifier key, such as shift or alt, is
	 * pressed. We simply communicate this to the client. ]]
	local keyboard = wl.wl_container_of(listener, keyboard, modifiers)
	--[[
	 * A seat can only have one keyboard, but this is a limitation of the
	 * Wayland protocol - not wlroots. We assign all connected keyboards to the
	 * same seat. You can swap out the underlying wlr_keyboard like this and
	 * wlr_seat handles this transparently.
	 ]]
	wlr.wlr_seat_set_keyboard(keyboard[0].server[0].seat, keyboard[0].wlr_keyboard)
	--[[Send modifiers to the client.]]
	wlr.wlr_seat_keyboard_notify_modifiers(keyboard[0].server[0].seat,
		keyboard[0].wlr_keyboard[0].modifiers)
end

--[[FIXME: have a table of keybinds, allow arbitrary modifiers]]
--[[@param server ptr_c<tinywl_server>]]
--[[@param sym xkb_keysym_t]]
--[[@return boolean]]
mod.handle_keybinding = function(server, sym)
	--[[alt was presse, try to handle shortcut]]
	if sym == xkb_key.escape then
		wl.wl_display_terminate(server[0].wl_display)
	elseif sym == xkb_key.f1 then
		--[[Cycle to the next toplevel]]
		if wl.wl_list_length(server[0].toplevels) >= 2 then
			local next_toplevel =
					wl.wl_container_of(server[0].toplevels.prev, next_toplevel, link)
			focus_toplevel(next_toplevel, next_toplevel[0].xdg_toplevel[0].base[0].surface)
		end
	else
		return false
	end
	return true
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.keyboard_handle_key = function(listener, data)
	--[[This event is raised when a key is pressed or released.]]
	local keyboard =
			wl.wl_container_of(listener, keyboard, key)
	local server = keyboard[0].server
	local event = data
	local seat = server[0].seat

	--[[Translate libinput keycode [0]. xkbcommon]]
	local keycode = event[0].keycode + 8
	--[[Get a list of keysyms based on the keymap for this keyboard]]
	local syms --[[@type ptr_c<xkb_keysym_t>]]
	local nsyms = xkb_state_key_get_syms(keyboard[0].wlr_keyboard[0].xkb_state, keycode, syms)
	local handled = false
	local modifiers = wlr.wlr_keyboard_get_modifiers(keyboard[0].wlr_keyboard)
	if bit.band(modifiers, wlr.wlr_modifier.alt) ~= 0 and event[0].state == wl_keyboard_key_state.pressed then
		--[[if alt was pressed-then try to handle it as a compositor shortcut]]
		for i = 0, nsyms - 1 do
			handled = mod.handle_keybinding(server, syms[i])
		end
	end

	if not handled then
		wlr.wlr_seat_set_keyboard(seat, keyboard[0].wlr_keyboard)
		wlr.wlr_seat_keyboard_notify_key(seat, event[0].time_msec,
			event[0].keycode, event[0].state)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.keyboard_handle_destroy = function(listener, data)
	local keyboard = wl.wl_container_of(listener, keyboard, destroy)
	wl.wl_list_remove(keyboard[0].modifiers.link)
	wl.wl_list_remove(keyboard[0].key.link)
	wl.wl_list_remove(keyboard[0].destroy.link)
	wl.wl_list_remove(keyboard[0].link)
	free(keyboard)
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param device ptr_c<wlr_input_device>]]
mod.server_new_keyboard = function(server, device)
	local wlr_keyboard = wlr.wlr_keyboard_from_input_device(device)
	local keyboard = ffi.new("wlr_keyboard [1]") --[[@type ptr_c<wlr_keyboard>]]
	keyboard[0].server = server
	keyboard[0].wlr_keyboard = wlr_keyboard
	local context = xkb_context_new(XKB_CONTEXT_NO_FLAGS)
	local keymap = xkb_keymap_new_from_names(context, nil,
		XKB_KEYMAP_COMPILE_NO_FLAGS)
	wlr.wlr_keyboard_set_keymap(wlr_keyboard, keymap)
	xkb_keymap_unref(keymap)
	xkb_context_unref(context)
	wlr.wlr_keyboard_set_repeat_info(wlr_keyboard, 25, 600)
	keyboard[0].modifiers.notify = mod.keyboard_handle_modifiers
	wl.wl_signal_add(wlr_keyboard[0].events.modifiers, keyboard[0].modifiers)
	keyboard[0].key.notify = mod.keyboard_handle_key
	wl.wl_signal_add(wlr_keyboard[0].events.key, keyboard[0].key)
	keyboard[0].destroy.notify = mod.keyboard_handle_destroy
	wl.wl_signal_add(device[0].events.destroy, keyboard[0].destroy)
	wlr.wlr_seat_set_keyboard(server[0].seat, keyboard[0].wlr_keyboard)
	wl.wl_list_insert(server[0].keyboards, keyboard[0].link)
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param pointer ptr_c<wlr_input_device>]]
mod.server_new_pointer = function(server, device)
	--[[ We don't do anything special with pointers. All of our pointer handling
	 * is proxied through wlr_cursor. On another compositor, you might take this
	 * opportunity to do libinput configuration on the device to set
	 * acceleration, etc. ]]
	wlr.wlr_cursor_attach_input_device(server[0].cursor, device)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_new_input = function(listener, data)
	--[[ This event is raised by the backend when a new input device becomes
	 * available. ]]
	local server = wl.wl_container_of(listener, server, new_input)
	local device = data
	if device[0].type == wlr_input_device.keyboard then
		server_new_keyboard(server, device)
	elseif device[0].type == wlr_input_device.pointer then
		server_new_pointer(server, device)
	end
	--[[ We need to let the wlr_seat know what our capabilities are, which is
	 * communiciated to the client. In TinyWL we always have a cursor, even if
	 * there are no pointer devices, so we always include that capability. ]]
	local caps = WL_SEAT_CAPABILITY_POINTER
	if not wl.wl_list_empty(server[0].keyboards) then
		caps = bit.bor(caps, wl_seat_capability.keyboard)
	end
	wlr.wlr_seat_set_capabilities(server[0].seat, caps)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.seat_request_cursor = function(listener, data)
	local server = wl.wl_container_of(
		listener, server, request_cursor)
	--[[This event is raised by the seat when a client provides a cursor image]]
	local event = data
	local focused_client =
			server[0].seat[0].pointer_state.focused_client
	--[[ This can be sent by any client, so we check to make sure this one is
	 * actually has pointer focus first. ]]
	if focused_client == event[0].seat_client then
		--[[ Once we've vetted the client, we can tell the cursor to use the
		 * provided surface as the cursor image. It will set the hardware cursor
		 * on the output that it's currently on and continue to do so as the
		 * cursor moves between outputs. ]]
		wlr.wlr_cursor_set_surface(server[0].cursor, event[0].surface,
			event[0].hotspot_x, event[0].hotspot_y)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.seat_request_set_selection = function(listener, data)
	--[[ This event is raised by the seat when a client wants to set the selection,
	 * usually when the user copies something. wlroots allows compositors to
	 * ignore such requests if they so choose, but in tinywl we always honor
	 ]]
	local server = wl.wl_container_of(listener, server, request_set_selection)
	local event = data
	wlr.wlr_seat_set_selection(server[0].seat, event[0].source, event[0].serial)
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param lx number]]
--[[@param ly number]]
--[[@param surface ptr_c<ptr_c<wlr_surface>>]]
--[[@param sx ptr_c<number>]]
--[[@param sy ptr_c<number>]]
--[[@return ptr_c<tinywl_toplevel>]]
mod.desktop_toplevel_at = function(server, lx, ly,
																	 surface, sx, sy)
	--[[ This returns the topmost node in the scene at the given layout coords.
	 * We only care about surface nodes as we are specifically looking for a
	 * surface in the surface tree of a tinywl_toplevel[0]. ]]
	local node = wlr.wlr_scene_node_at(server[0].scene[0].tree.node, lx, ly, sx, sy)
	if node == nil or node[0].type ~= wlr_scene_node.buffer then
		return nil
	end
	local scene_buffer = wlr.wlr_scene_buffer_from_node(node)
	local scene_surface =
			wlr.wlr_scene_surface_try_from_buffer(scene_buffer)
	if not scene_surface then
		return nil
	end

	surface[0] = scene_surface[0].surface
	--[[ Find the node corresponding to the tinywl_toplevel at the root of this
	 * surface tree, it is the only one for which we set the data field. ]]
	local tree = node[0].parent
	while tree ~= nil and tree[0].node.data == nil do
		tree = tree[0].node.parent
	end
	return tree[0].node.data
end

--[[@param server ptr_c<tinywl_server>]]
mod.reset_cursor_mode = function(server)
	--[[Reset the cursor mode to passthrough.]]
	server[0].cursor_mode = tinywl_cursor_mode.passthrough
	server[0].grabbed_toplevel = nil
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param time integer]]
mod.process_cursor_move = function(server, time)
	--[[Move the grabbed toplevel to the new position.]]
	local toplevel = server[0].grabbed_toplevel
	wlr.wlr_scene_node_set_position(toplevel[0].scene_tree[0].node,
		server[0].cursor[0].x - server[0].grab_x,
		server[0].cursor[0].y - server[0].grab_y)
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param time integer]]
mod.process_cursor_resize = function(server, time)
	--[[
	 * Resizing the grabbed toplevel can be a little bit complicated, because we
	 * could be resizing from any corner or edge. This not only resizes the
	 * toplevel on one or two axes, but can also move the toplevel if you resize
	 * from the top or left edges (or top-left corner).
	 *
	 * Note that some shortcuts are taken here. In a more fleshed-out
	 * compositor, you'd wait for the client to prepare a buffer at the new
	 * size, then commit any movement that was prepared.
	 ]]
	local toplevel = server[0].grabbed_toplevel
	local border_x = server[0].cursor[0].x - server[0].grab_x
	local border_y = server[0].cursor[0].y - server[0].grab_y
	local new_left = server[0].grab_geobox.x
	local new_right = server[0].grab_geobox.x + server[0].grab_geobox.width
	local new_top = server[0].grab_geobox.y
	local new_bottom = server[0].grab_geobox.y + server[0].grab_geobox.height

	if bit.band(server[0].resize_edges, wlr_edge.top) ~= 0 then
		new_top = border_y
		if new_top >= new_bottom then new_top = new_bottom - 1 end
	elseif bit.band(server[0].resize_edges, wlr_edge.bottom) ~= 0 then
		new_bottom = border_y
		if new_bottom <= new_top then new_bottom = new_top + 1 end
	end
	if bit.band(server[0].resize_edges, wlr_edge.left) ~= 0 then
		new_left = border_x
		if new_left >= new_right then new_left = new_right - 1 end
	elseif bit.band(server[0].resize_edges, wlr_edge.right) ~= 0 then
		new_right = border_x
		if new_right <= new_left then new_right = new_left + 1 end
	end
	local wlr_box
	local geo_box
	wlr.wlr_xdg_surface_get_geometry(toplevel[0].xdg_toplevel[0].base, geo_box)
	wlr.wlr_scene_node_set_position(toplevel[0].scene_tree[0].node,
		new_left - geo_box.x, new_top - geo_box.y)
	local new_width = new_right - new_left
	local new_height = new_bottom - new_top
	wlr.wlr_xdg_toplevel_set_size(toplevel[0].xdg_toplevel, new_width, new_height)
end

--[[@param server ptr_c<tinywl_server>]]
--[[@param time integer]]
mod.process_cursor_motion = function(server, time)
	--[[If the mode is non-passthrough, delegate to those functions.]]
	if server[0].cursor_mode == tinywl_cursor_mode.move then
		process_cursor_move(server, time)
		return
	elseif server[0].cursor_mode == tinywl_cursor_mode.resize then
		process_cursor_resize(server, time)
		return
	end
	--[[Otherwise, find the toplevel under the pointer and send the event along.]]
	local sx --[[@type number]]
	local sy --[[@type number]]
	local seat = server[0].seat
	local surface = nil
	local toplevel = desktop_toplevel_at(server,
		server[0].cursor[0].x, server[0].cursor[0].y, surface, sx, sy)
	if not toplevel then
		wlr.wlr_cursor_set_xcursor(server[0].cursor, server[0].cursor_mgr, "default")
	end
	if surface ~= nil then
		wlr.wlr_seat_pointer_notify_enter(seat, surface, sx, sy)
		wlr.wlr_seat_pointer_notify_motion(seat, time, sx, sy)
	else
		--[[ Clear pointer focus so future button events and such are not sent to
		 * the last client to have the cursor over it. ]]
		wlr.wlr_seat_pointer_clear_focus(seat)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_cursor_motion = function(listener, data)
	local server = wl.wl_container_of(listener, server, cursor_motion)
	local event = data
	wlr.wlr_cursor_move(server[0].cursor, event[0].pointer[0].base,
		event[0].delta_x, event[0].delta_y)
	mod.process_cursor_motion(server, event[0].time_msec)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_cursor_motion_absolute = function(listener, data)
	local server = wl.wl_container_of(listener, server, cursor_motion_absolute)
	local event = data
	wlr.wlr_cursor_warp_absolute(server[0].cursor, event[0].pointer[0].base, event[0].x,
		event[0].y)
	mod.process_cursor_motion(server, event[0].time_msec)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_cursor_button = function(listener, data)
	local server = wl.wl_container_of(listener, server, cursor_button)
	local event = data
	wlr.wlr_seat_pointer_notify_button(server[0].seat,
		event[0].time_msec, event[0].button, event[0].state)
	local sx --[[@type number]]
	local sy --[[@type number]]
	local surface = nil
	local toplevel = desktop_toplevel_at(server,
		server[0].cursor[0].x, server[0].cursor[0].y, surface, sx, sy)
	if event[0].state == wl_pointer_button_state.released then
		--[[If you released any buttons, we exit interactive move/resize mode.]]
		mod.reset_cursor_mode(server)
	else
		--[[Focus that client if the button was _pressed_]]
		mod.focus_toplevel(toplevel, surface)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_cursor_axis = function(listener, data)
	--[[ This event is forwarded by the cursor when a pointer emits an axis event,
	 * for example when you move the scroll wheel. ]]
	local server = wl.wl_container_of(listener, server, cursor_axis)
	local event = data
	--[[Notify the client with pointer focus of the axis event.]]
	wlr.wlr_seat_pointer_notify_axis(server[0].seat,
		event[0].time_msec, event[0].orientation, event[0].delta,
		event[0].delta_discrete, event[0].source, event[0].relative_direction)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_cursor_frame = function(listener, data)
	local server = wl.wl_container_of(listener, server, cursor_frame)
	--[[Notify the client with pointer focus of the frame event.]]
	wlr.wlr_seat_pointer_notify_frame(server[0].seat)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.output_frame = function(listener, data)
	--[[ This function is called every time an output is ready to display a frame,
	 * generally at the output's refresh rate (e.g. 60Hz). ]]
	local output = wl.wl_container_of(listener, output, frame)
	local scene = output[0].server[0].scene

	local scene_output = wlr.wlr_scene_get_scene_output(
		scene, output[0].wlr_output)

	--[[Render the scene if needed and commit the output]]
	wlr.wlr_scene_output_commit(scene_output, nil)
	local now --[[@type timespec_c]]
	--[[FIXME: call gettime]]
	clock_gettime(CLOCK_MONOTONIC, now)
	wlr.wlr_scene_output_send_frame_done(scene_output, now)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.output_request_state = function(listener, data)
	--[[ This function is called when the backend requests a new state for
	 * the output. For example, Wayland and X11 backends request a new mode
	 * when the output window is resized. ]]
	local output = wl.wl_container_of(listener, output, request_state)
	local event = data
	wlr.wlr_output_commit_state(output[0].wlr_output, event[0].state)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.output_destroy = function(listener, data)
	local output = wl.wl_container_of(listener, output, destroy)

	wl.wl_list_remove(output[0].frame.link)
	wl.wl_list_remove(output[0].request_state.link)
	wl.wl_list_remove(output[0].destroy.link)
	wl.wl_list_remove(output[0].link)
	free(output)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_new_output = function(listener, data)
	local server = wl.wl_container_of(listener, server, new_output)
	local wlr_output = data
	wlr.wlr_output_init_render(wlr_output, server[0].allocator, server[0].renderer)
	local state --[[@type wlr_output_state]]
	wlr.wlr_output_state_init(state)
	wlr.wlr_output_state_set_enabled(state, true)
	local mode = wlr.wlr_output_preferred_mode(wlr_output)
	if mode ~= nil then wlr.wlr_output_state_set_mode(state, mode) end
	wlr.wlr_output_commit_state(wlr_output, state)
	wlr.wlr_output_state_finish(state)
	local output = ffi.new("tinywl_output[1]") --[[@type ptr_c<tinywl_output>]]
	output[0].wlr_output = wlr_output
	output[0].server = server
	output[0].frame.notify = mod.output_frame
	wl.wl_signal_add(wlr_output[0].events.frame, output.frame)
	output[0].request_state.notify = mod.output_request_state
	wl.wl_signal_add(wlr_output[0].events.request_state, output[0].request_state)
	output[0].destroy.notify = mod.output_destroy
	wl.wl_signal_add(wlr_output[0].events.destroy, output[0].destroy)
	wl.wl_list_insert(server[0].outputs, output[0].link)
	local l_output = wlr.wlr_output_layout_add_auto(server[0].output_layout, wlr_output)
	local scene_output = wlr.wlr_scene_output_create(server[0].scene, wlr_output)
	wlr.wlr_scene_output_layout_add_output(server[0].scene_layout, l_output, scene_output)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_map = function(listener, data)
	local toplevel = wl.wl_container_of(listener, toplevel, map)

	wl.wl_list_insert(toplevel[0].server[0].toplevels, toplevel[0].link)

	focus_toplevel(toplevel, toplevel[0].xdg_toplevel[0].base[0].surface)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_unmap = function(listener, data)
	local toplevel = wl.wl_container_of(listener, toplevel, unmap)
	if toplevel == toplevel[0].server[0].grabbed_toplevel then
		reset_cursor_mode(toplevel[0].server)
	end
	wl.wl_list_remove(toplevel[0].link)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_commit = function(listener, data)
	local toplevel = wl.wl_container_of(listener, toplevel, commit)
	if toplevel[0].xdg_toplevel[0].base[0].initial_commit then
		wlr.wlr_xdg_toplevel_set_size(toplevel[0].xdg_toplevel, 0, 0)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_destroy = function(listener, data)
	--[[Called when the xdg_toplevel is destroyed.]]
	local toplevel = wl.wl_container_of(listener, toplevel, destroy)
	wl.wl_list_remove(toplevel[0].map.link)
	wl.wl_list_remove(toplevel[0].unmap.link)
	wl.wl_list_remove(toplevel[0].commit.link)
	wl.wl_list_remove(toplevel[0].destroy.link)
	wl.wl_list_remove(toplevel[0].request_move.link)
	wl.wl_list_remove(toplevel[0].request_resize.link)
	wl.wl_list_remove(toplevel[0].request_maximize.link)
	wl.wl_list_remove(toplevel[0].request_fullscreen.link)
	free(toplevel)
end

--[[@param toplevel ptr_c<tinywl_toplevel>]]
--[[@param mode tinywl_cursor_mode]]
--[[@param edges integer]]
mod.begin_interactive = function(toplevel, mode, edges)
	local server = toplevel[0].server
	local focused_surface =
			server[0].seat[0].pointer_state.focused_surface
	if toplevel[0].xdg_toplevel[0].base[0].surface ~= wlr.wlr_surface_get_root_surface(focused_surface) then
		return
	end
	server[0].grabbed_toplevel = toplevel
	server[0].cursor_mode = mode
	if mode == tinywl_cursor_mode.move then
		server[0].grab_x = server[0].cursor[0].x - toplevel[0].scene_tree[0].node.x
		server[0].grab_y = server[0].cursor[0].y - toplevel[0].scene_tree[0].node.y
	else
		local geo_box --[[@type wlr_box]]
		wlr.wlr_xdg_surface_get_geometry(toplevel[0].xdg_toplevel[0].base, geo_box)
		local border_x = (toplevel[0].scene_tree[0].node.x + geo_box.x) +
				(bit.band(edges, wlr_edge.right) and geo_box.width or 0)
		local border_y = (toplevel[0].scene_tree[0].node.y + geo_box.y) +
				(bit.band(edges, wlr_edge.bottom) and geo_box.height or 0)
		server[0].grab_x = server[0].cursor[0].x - border_x
		server[0].grab_y = server[0].cursor[0].y - border_y
		server[0].grab_geobox = geo_box
		server[0].grab_geobox.x = server[0].grab_geobox.x + toplevel[0].scene_tree[0].node.x
		server[0].grab_geobox.y = server[0].grab_geobox.y + toplevel[0].scene_tree[0].node.y
		server[0].resize_edges = edges
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_request_move = function(listener, data)
	local toplevel = wl.wl_container_of(listener, toplevel, request_move)
	mod.begin_interactive(toplevel, tinywl_cursor_mode.move, 0)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_request_resize = function(listener, data)
	local event = data
	local toplevel = wl.wl_container_of(listener, toplevel, request_resize)
	mod.begin_interactive(toplevel, tinywl_cursor_mode.resize, event[0].edges)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_request_maximize = function(listener, data)
	local toplevel = wl.wl_container_of(listener, toplevel, request_maximize)
	if toplevel[0].xdg_toplevel[0].base[0].initialized then
		wlr.wlr_xdg_surface_schedule_configure(toplevel[0].xdg_toplevel[0].base)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_toplevel_request_fullscreen = function(listener, data)
	--[[Just as with request_maximize, we must send a configure here.]]
	local toplevel = wl.wl_container_of(listener, toplevel, request_fullscreen)
	if toplevel[0].xdg_toplevel[0].base[0].initialized then
		wlr.wlr_xdg_surface_schedule_configure(toplevel[0].xdg_toplevel[0].base)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_new_xdg_toplevel = function(listener, data)
	local server = wl.wl_container_of(listener, server, new_xdg_toplevel)
	local xdg_toplevel = data
	local toplevel = ffi.new("tinywl_toplevel [1]") --[[@type ptr_c<tinywl_toplevel>]]
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
	--[[cotd]]
	toplevel[0].request_move.notify = mod.xdg_toplevel_request_move
	wl.wl_signal_add(xdg_toplevel[0].events.request_move, toplevel[0].request_move)
	toplevel[0].request_resize.notify = mod.xdg_toplevel_request_resize
	wl.wl_signal_add(xdg_toplevel[0].events.request_resize, toplevel[0].request_resize)
	toplevel[0].request_maximize.notify = mod.xdg_toplevel_request_maximize
	wl.wl_signal_add(xdg_toplevel[0].events.request_maximize, toplevel[0].request_maximize)
	toplevel[0].request_fullscreen.notify = mod.xdg_toplevel_request_fullscreen
	wl.wl_signal_add(xdg_toplevel[0].events.request_fullscreen, toplevel[0].request_fullscreen)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_popup_commit = function(listener, data)
	local popup = wl.wl_container_of(listener, popup, commit)
	if popup[0].xdg_popup[0].base[0].initial_commit then
		wlr.wlr_xdg_surface_schedule_configure(popup[0].xdg_popup[0].base)
	end
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.xdg_popup_destroy = function(listener, data)
	local popup = wl.wl_container_of(listener, popup, destroy)
	wl.wl_list_remove(popup[0].commit.link)
	wl.wl_list_remove(popup[0].destroy.link)
	ffi.C.free(popup)
end

--[[@param listener ptr_c<wl_listener>]]
--[[@param data ptr_c<unknown>]]
mod.server_new_xdg_popup = function(listener, data)
	local xdg_popup = data
	local popup = ffi.new("tinywl_popup [1]") --[[@type ptr_c<tinywl_popup>]]
	popup[0].xdg_popup = xdg_popup
	local parent = wlr.wlr_xdg_surface_try_from_wlr_surface(xdg_popup[0].parent)
	assert(parent ~= nil)
	local parent_tree = parent[0].data
	xdg_popup[0].base[0].data = wlr.wlr_scene_xdg_surface_create(parent_tree, xdg_popup[0].base)
	popup[0].commit.notify = mod.xdg_popup_commit
	wl.wl_signal_add(xdg_popup[0].base[0].surface[0].events.commit, popup[0].commit)
	popup[0].destroy.notify = mod.xdg_popup_destroy
	wl.wl_signal_add(xdg_popup[0].events.destroy, popup[0].destroy)
end

mod.run = function()
	wlr.wlr_log_init(wlr.WLR_DEBUG, nil)
	local server = ffi.new("struct tinywl_server") --[[@type tinywl_server]]
	server.wl_display = wl.wl_display_create()
	server.backend = wlr.wlr_backend_autocreate(wl.wl_display_get_event_loop(server.wl_display), nil)
	if server.backend == nil then
		wlr.wlr_log(wlr.WLR_ERROR, "failed to create wlr_backend")
		return 1
	end
	server.renderer = wlr.wlr_renderer_autocreate(server.backend)
	if server.renderer == nil then
		wlr.wlr_log(wlr.WLR_ERROR, "failed to create wlr_renderer")
		return 1
	end
	wlr.wlr_renderer_init_wl_display(server.renderer, server.wl_display)
	server.allocator = wlr.wlr_allocator_autocreate(server.backend, server.renderer)
	if server.allocator == nil then
		wlr.wlr_log(wlr.WLR_ERROR, "failed to create wlr_allocator")
		return 1
	end
	wlr.wlr_compositor_create(server.wl_display, 5, server.renderer)
	wlr.wlr_subcompositor_create(server.wl_display)
	wlr.wlr_data_device_manager_create(server.wl_display)
	server.output_layout = wlr.wlr_output_layout_create(server.wl_display)
	wl.wl_list_init(server.outputs)
	server.new_output.notify = mod.server_new_output
	wl.wl_signal_add(server.backend[0].events.new_output, server.new_output)
	server.scene = wlr.wlr_scene_create()
	server.scene_layout = wlr.wlr_scene_attach_output_layout(server.scene, server.output_layout)
	wl.wl_list_init(server.toplevels)
	server.xdg_shell = wlr.wlr_xdg_shell_create(server.wl_display, 3)
	server.new_xdg_toplevel[0].notify = mod.server_new_xdg_toplevel
	wl.wl_signal_add(server.xdg_shell[0].events.new_toplevel, server.new_xdg_toplevel)
	server.new_xdg_popup.notify = mod.server_new_xdg_popup
	wl.wl_signal_add(server.xdg_shell[0].events.new_popup, server.new_xdg_popup)
	server.cursor = wlr.wlr_cursor_create()
	wlr.wlr_cursor_attach_output_layout(server.cursor, server.output_layout)
	server.cursor_mgr = wlr.wlr_xcursor_manager_create(nil, 24)
	server.cursor_mode = tinywl_cursor_mode.passthrough
	server.cursor_motion.notify = mod.server_cursor_motion
	wl.wl_signal_add(server.cursor[0].events.motion, server.cursor_motion)
	server.cursor_motion_absolute.notify = mod.server_cursor_motion_absolute
	wl.wl_signal_add(server.cursor[0].events.motion_absolute,
		server.cursor_motion_absolute)
	server.cursor_button.notify = mod.server_cursor_button
	wl.wl_signal_add(server.cursor[0].events.button, server.cursor_button)
	server.cursor_axis.notify = mod.server_cursor_axis
	wl.wl_signal_add(server.cursor[0].events.axis, server.cursor_axis)
	server.cursor_frame.notify = mod.server_cursor_frame
	wl.wl_signal_add(server.cursor[0].events.frame, server.cursor_frame)
	wl.wl_list_init(server.keyboards)
	server.new_input.notify = mod.server_new_input
	wl.wl_signal_add(server.backend[0].events.new_input, server.new_input)
	server.seat = wlr.wlr_seat_create(server.wl_display, "seat0")
	server.request_cursor.notify = mod.seat_request_cursor
	wl.wl_signal_add(server.seat[0].events.request_set_cursor,
		server.request_cursor)
	server.request_set_selection.notify = mod.seat_request_set_selection
	wl.wl_signal_add(server.seat[0].events.request_set_selection,
		server.request_set_selection)
	local socket = wl.wl_display_add_socket_auto(server.wl_display)
	if not socket then
		wlr.wlr_backend_destroy(server.backend)
		return 1
	end
	if not wlr.wlr_backend_start(server.backend) then
		wlr.wlr_backend_destroy(server.backend)
		wl.wl_display_destroy(server.wl_display)
		return 1
	end
	setenv("WAYLAND_DISPLAY", socket, true)
	-- if fork() == 0 then
	-- 	--[[TODO: run startup_cmd here]]
	-- 	-- execl("/bin/sh", "/bin/sh", "-c", startup_cmd, nil)
	-- end
	wlr.wlr_log(WLR_INFO, "Running Wayland compositor on WAYLAND_DISPLAY=%s", socket)
	wl.wl_display_run(server.wl_display)
	wl.wl_display_destroy_clients(server.wl_display)
	wlr.wlr_scene_node_destroy(server.scene[0].tree.node)
	wlr.wlr_xcursor_manager_destroy(server.cursor_mgr)
	wlr.wlr_cursor_destroy(server.cursor)
	wlr.wlr_allocator_destroy(server.allocator)
	wlr.wlr_renderer_destroy(server.renderer)
	wlr.wlr_backend_destroy(server.backend)
	wl.wl_display_destroy(server.wl_display)
	return 0
end

if pcall(debug.getlocal, 4, 1) then return mod else mod.run() end

--[[@class tinywl_server]]
--[[@field wl_display ptr_c<wl_display>]]
--[[@field backend ptr_c<wlr_backend>]]
--[[@field renderer ptr_c<wlr_renderer>]]
--[[@field allocator ptr_c<wlr_allocator>]]
--[[@field scene ptr_c<wlr_scene>]]
--[[@field scene_layout ptr_c<wlr_scene_output_layout>]]
--[[@field xdg_shell ptr_c<wlr_xdg_shell>]]
--[[@field new_xdg_toplevel wl_listener]]
--[[@field new_xdg_popup wl_listener]]
--[[@field toplevels wl_list]]
--[[@field cursor ptr_c<wlr_cursor>]]
--[[@field cursor_mgr ptr_c<wlr_xcursor_manager>]]
--[[@field cursor_motion wl_listener]]
--[[@field cursor_motion_absolute wl_listener]]
--[[@field cursor_button wl_listener]]
--[[@field cursor_axis wl_listener]]
--[[@field cursor_frame wl_listener]]
--[[@field seat ptr_c<wlr_seat>]]
--[[@field new_input wl_listener]]
--[[@field request_cursor wl_listener]]
--[[@field request_set_selection wl_listener]]
--[[@field keyboards wl_list]]
--[[@field cursor_mode tinywl_cursor_mode]]
--[[@field grabbed_toplevel? ptr_c<tinywl_toplevel>]]
--[[@field grab_x number]]
--[[@field grab_y number]]
--[[@field grab_geobox wlr_box]]
--[[@field resize_edges integer]]
--[[@field output_layout ptr_c<wlr_output_layout>]]
--[[@field outputs wl_list]]
--[[@field new_output wl_listener]]

--[[@class tinywl_output]]
--[[@field link wl_list]]
--[[@field server ptr_c<tinywl_server>]]
--[[@field wlr_output ptr_c<wlr_output>]]
--[[@field frame wl_listener]]
--[[@field request_state wl_listener]]
--[[@field destroy wl_listener]]

--[[@class tinywl_toplevel]]
--[[@field link wl_list]]
--[[@field server ptr_c<tinywl_server>]]
--[[@field xdg_toplevel ptr_c<wlr_xdg_toplevel>]]
--[[@field scene_tree ptr_c<wlr_scene_tree>]]
--[[@field map wl_listener]]
--[[@field unmap wl_listener]]
--[[@field commit wl_listener]]
--[[@field destroy wl_listener]]
--[[@field request_move wl_listener]]
--[[@field request_resize wl_listener]]
--[[@field request_maximize wl_listener]]
--[[@field request_fullscreen wl_listener]]

--[[@class tinywl_popup]]
--[[@field xdg_popup ptr_c<wlr_xdg_popup>]]
--[[@field commit wl_listener]]
--[[@field destroy wl_listener]]

--[[@class tinywl_keyboard]]
--[[@field link wl_list]]
--[[@field server ptr_c<tinywl_server>]]
--[[@field wlr_keyboard ptr_c<wlr_keyboard>]]
--[[@field modifiers wl_listener]]
--[[@field key wl_listener]]
--[[@field destroy wl_listener]]
--[[@class composter_server]]
--[[@field wl_display ptr_c<wl_display>]]
--[[@field backend ptr_c<wlr_backend>]]
--[[@field renderer ptr_c<wlr_renderer>]]
--[[@field allocator ptr_c<wlr_allocator>]]
--[[@field scene ptr_c<wlr_scene>]]
--[[@field scene_layout ptr_c<wlr_scene_output_layout>]]
--[[@field focused_toplevel ptr_c<composter_toplevel>]]
--[[@field xdg_shell ptr_c<wlr_xdg_shell>]]
--[[@field new_xdg_toplevel wl_listener]]
--[[@field new_xdg_popup wl_listener]]
--[[@field toplevels wl_list]]
--[[@field xwayland ptr_c<wlr_xwayland>]]
--[[@field new_xwayland_surface wl_listener]]
--[[@field xdg_decoration_manager ptr_c<wlr_xdg_decoration_manager_v1>]]
--[[@field new_toplevel_decoration wl_listener]]
--[[@field wlr_layer_shell ptr_c<wlr_layer_shell_v1>]]
--[[@field new_layer_shell_surface wl_listener]]
--[[@field cursor ptr_c<wlr_cursor>]]
--[[@field cursor_manager ptr_c<wlr_xcursor_manager>]]
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
--[[@field cursor_mode composter_cursor_mode]]
--[[@field grabbed_toplevel? ptr_c<composter_toplevel>]]
--[[@field grab_x number]]
--[[@field grab_y number]]
--[[@field grab_geobox wlr_box]]
--[[@field resize_edges integer]]
--[[@field output_layout ptr_c<wlr_output_layout>]]
--[[@field outputs wl_list]]
--[[@field new_output wl_listener]]

--[[@class composter_output]]
--[[@field link wl_list]]
--[[@field server ptr_c<composter_server>]]
--[[@field wlr_output ptr_c<wlr_output>]]
--[[@field frame wl_listener]]
--[[@field request_state wl_listener]]
--[[@field destroy wl_listener]]

--[[@class composter_toplevel]]
--[[@field link wl_list]]
--[[@field server ptr_c<composter_server>]]
--[[@field xwayland_surface ptr_c<wlr_xwayland_surface>]]
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

--[[@class composter_popup]]
--[[@field xdg_popup ptr_c<wlr_xdg_popup>]]
--[[@field commit wl_listener]]
--[[@field destroy wl_listener]]

--[[@class composter_keyboard]]
--[[@field link wl_list]]
--[[@field server ptr_c<composter_server>]]
--[[@field wlr_keyboard ptr_c<wlr_keyboard>]]
--[[@field modifiers wl_listener]]
--[[@field key wl_listener]]
--[[@field destroy wl_listener]]

--[[@class composter_decoration]]
--[[@field xdg_decoration ptr_c<wlr_xdg_toplevel_decoration_v1>]]
--[[@field destroy wl_listener]]
--[[@field request_mode wl_listener]]

--[[@class composter_layer_shell_surface]]
--[[@field wlr_surface ptr_c<wlr_layer_surface_v1>]]
--[[@field destroy wl_listener]]
--[[@field new_popup wl_listener]]

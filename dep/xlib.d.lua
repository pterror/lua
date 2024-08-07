--[[private fields omitted]]

--[[@class xlib_status_c]]
--[[@class xlib_id_c]]
--[[@class xlib_mask_c]]
--[[@class xlib_atom_c]]
--[[@class xlib_visualid_c]]
--[[@class xlib_time_c]]
--[[@class xlib_window_c: xlib_drawable_c]]
--[[@class xlib_drawable_c: xlib_id_c]]
--[[@class xlib_font_c: xlib_id_c]]
--[[@class xlib_pixmap_c: xlib_drawable_c]]
--[[@class xlib_cursor_c: xlib_id_c]]
--[[@class xlib_colormap_c: xlib_id_c]]
--[[@class xlib_gcontext_c: xlib_id_c]]
--[[@class xlib_key_sym_c: xlib_id_c]]
--[[@class xlib_key_code_c]]
--[[@class xlib_pointer_c]]

--[[@class xlib_im_c]]
--[[@class xlib_ic_c]]

--[[@alias xlib_im_proc_c fun(im: xlib_im_c, a: xlib_pointer_c, b: xlib_pointer_c)]]
--[[@alias xlib_ic_proc_c fun(ic: xlib_ic_c, a: xlib_pointer_c, b: xlib_pointer_c): boolean]]
--[[@alias xlib_id_proc_c fun(d: xlib_display_c, a: xlib_pointer_c, b: xlib_pointer_c)]]

--[[@class xlib_rm_database_c]]

--[[Per character font metric information]]
--[[@class xlib_char_struct_c]]
--[[@field lbearing integer]]
--[[@field rbearing integer]]
--[[@field width integer]]
--[[@field ascent integer]]
--[[@field descent integer]]
--[[@field attributes integer]]

--[[To allow arbitrary information with fonts, there are additional properties returned.]]
--[[@class xlib_font_prop_c]]
--[[@field name xlib_atom_c]]
--[[@field card32 integer]]

--[[@class xlib_font_struct_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field fid xlib_font_c]]
--[[@field direction integer]]
--[[@field min_char_or_byte2 integer]]
--[[@field max_char_or_byte2 integer]]
--[[@field min_byte1 integer]]
--[[@field max_byte1 integer]]
--[[@field all_chars_exist boolean]]
--[[@field default_char integer]]
--[[@field n_properties integer]]
--[[@field properties ptr_c<xlib_font_prop_c>]]
--[[@field min_bounds xlib_char_struct_c]]
--[[@field max_bounds xlib_char_struct_c]]
--[[@field per_char ptr_c<xlib_char_struct_c>]]
--[[@field ascent integer]]
--[[@field descent integer]]

--[[@class xlib_font_set_extents_c]]
--[[@field max_ink_extent xlib_rectangle_c]]
--[[@field max_logical_extent xlib_rectangle_c]]

--[[@class xlib_om_c]]

--[[@class xlib_oc_c]]

--[[@class xlib_font_set_c]]

--[[@class xlib_window_changes_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field window xlib_window_c]]
--[[@field stack_mode xlib_window_stacking_method]]

--[[@class xlib_color_c]]
--[[@field pixel integer]]
--[[@field red integer]]
--[[@field green integer]]
--[[@field blue integer]]
--[[@field flags xlib_store_color_flag]]

--[[@class xlib_segment_c]]
--[[@field x1 integer]]
--[[@field y1 integer]]
--[[@field x2 integer]]
--[[@field y2 integer]]

--[[@class xlib_point_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_rectangle_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]

--[[@class xlib_arc_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field angle1 integer]]
--[[@field angle2 integer]]

--[[@class _xlib_base_event_c]]
--[[@field type xlib_event_type]]
--[[@field serial integer]]
--[[@field send_event boolean]]
--[[@field display ptr_c<xlib_display_c>]]

--[[@class xlib_any_event_c: _xlib_base_event_c]]
--[[@field window xlib_window_c]]

--[[@class _xlib_positioned_event_c: xlib_any_event_c]]
--[[@field root xlib_window_c]]
--[[@field subwindow xlib_window_c]]
--[[@field time xlib_time_c ms]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field x_root integer]]
--[[@field y_root integer]]

--[[@class xlib_key_event_c: _xlib_positioned_event_c]]
--[[@field type 2|3]]
--[[@field state xlib_key_button_mask]]
--[[@field keycode xlib_key_code_c]]
--[[@field same_screen boolean]]

--[[@class xlib_key_pressed_event_c: xlib_key_event_c]]
--[[@field type 2]]

--[[@class xlib_key_released_event_c: xlib_key_event_c]]
--[[@field type 3]]

--[[@class xlib_button_event_c: _xlib_positioned_event_c]]
--[[@field type 4|5]]
--[[@field state xlib_key_button_mask]]
--[[@field button xlib_button]]
--[[@field same_screen boolean]]

--[[@class xlib_button_pressed_event_c: xlib_button_event_c]]
--[[@field type 4]]

--[[@class xlib_button_released_event_c: xlib_button_event_c]]
--[[@field type 5]]

--[[@class xlib_motion_event_c: _xlib_positioned_event_c]]
--[[@field type 6]]
--[[@field state xlib_key_button_mask]]
--[[@field is_hint xlib_notify_hint_mode]]
--[[@field same_screen boolean]]

--[[@class xlib_pointer_moved_event_c: xlib_motion_event_c]]

--[[@class xlib_crossing_event_c: _xlib_positioned_event_c]]
--[[@field type 7|8]]
--[[@field mode xlib_notify_mode cannot be `while_grabbed`]]
--[[@field detail xlib_notify_detail]]
--[[@field same_screen boolean]]
--[[@field focus boolean]]

--[[@class xlib_enter_window_event_c: xlib_crossing_event_c]]
--[[@field type 7]]

--[[@class xlib_leave_window_event_c: xlib_crossing_event_c]]
--[[@field type 8]]

--[[@class xlib_focus_change_event_c: xlib_any_event_c]]
--[[@field type 9|10]]
--[[@field mode xlib_notify_mode]]
--[[@field detail xlib_notify_detail]]

--[[@class xlib_focus_in_event_c: xlib_focus_change_event_c]]
--[[@field type 9]]

--[[@class xlib_focus_out_event_c: xlib_focus_change_event_c]]
--[[@field type 10]]

--[[@class xlib_keymap_event_c: xlib_any_event_c]]
--[[@field type 11]]
--[[@field key_vector integer[] length 32]]

--[[@class xlib_expose_event_c: xlib_any_event_c]]
--[[@field type 12]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field count integer]]

--[[@class xlib_graphics_expose_event_c: _xlib_base_event_c]]
--[[@field type 13]]
--[[@field drawable xlib_drawable_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field count integer]]
--[[@field major_code xlib_request_code `copy_area` or `copy_plane`]]
--[[@field minor_code integer]]

--[[@class xlib_no_expose_event_c: _xlib_base_event_c]]
--[[@field type 14]]
--[[@field drawable xlib_drawable_c]]
--[[@field major_code xlib_request_code `copy_area` or `copy_plane`]]
--[[@field minor_code integer]]

--[[@class xlib_visibility_event_c: xlib_any_event_c]]
--[[@field type 15]]
--[[@field state integer]]

--[[@class xlib_create_window_event_c: _xlib_base_event_c]]
--[[@field type 16]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field override_redirect boolean]]

--[[@class xlib_destroy_window_event_c: _xlib_base_event_c]]
--[[@field type 17]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]

--[[@class xlib_unmap_event_c: _xlib_base_event_c]]
--[[@field type 18]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field from_configure boolean]]

--[[@class xlib_map_event_c: _xlib_base_event_c]]
--[[@field type 19]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field override_redirect boolean]]

--[[@class xlib_map_request_event_c: _xlib_base_event_c]]
--[[@field type 20]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]

--[[@class xlib_reparent_event_c: _xlib_base_event_c]]
--[[@field type 21]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field parent xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field override_redirect boolean]]

--[[@class xlib_configure_event_c: _xlib_base_event_c]]
--[[@field type 22]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field above xlib_window_c]]
--[[@field override_redirect boolean]]

--[[@class xlib_configure_request_event_c: _xlib_base_event_c]]
--[[@field type 23]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field above xlib_window_c]]
--[[@field detail xlib_window_stacking_method]]
--[[@field value_mask integer]]

--[[@class xlib_gravity_event_c: _xlib_base_event_c]]
--[[@field type 24]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_resize_request_event_c: xlib_any_event_c]]
--[[@field type 25]]
--[[@field width integer]]
--[[@field height integer]]

--[[@class xlib_circulate_event_c: _xlib_base_event_c]]
--[[@field type 26]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field place xlib_circulate_request_type]]

--[[@class xlib_circulate_request_event_c: _xlib_base_event_c]]
--[[@field type 27]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field place xlib_circulate_request_type]]

--[[@class xlib_property_event_c: xlib_any_event_c]]
--[[@field type 28]]
--[[@field atom xlib_atom_c]]
--[[@field time xlib_time_c]]
--[[@field state xlib_property_notification_type]]

--[[@class xlib_selection_clear_event_c: xlib_any_event_c]]
--[[@field type 29]]
--[[@field atom xlib_atom_c]]
--[[@field time xlib_time_c]]

--[[@class xlib_selection_request_event_c: _xlib_base_event_c]]
--[[@field type 30]]
--[[@field owner xlib_window_c]]
--[[@field requestor xlib_window_c]]
--[[@field selection xlib_atom_c]]
--[[@field target xlib_atom_c]]
--[[@field property xlib_atom_c can be `nil`]]
--[[@field time xlib_time_c]]

--[[@class xlib_selection_event_c: _xlib_base_event_c]]
--[[@field type 31]]
--[[@field requestor xlib_window_c]]
--[[@field selection xlib_atom_c]]
--[[@field target xlib_atom_c]]
--[[@field property xlib_atom_c can be `nil`]]

--[[@class xlib_colormap_event_c: xlib_any_event_c]]
--[[@field type 32]]
--[[@field colormap xlib_colormap_c can be `nil`]]
--[[@field new boolean]]
--[[@field state xlib_colormap_notification_type]]

--[[union `b`, `s`, `l`]]
--[[@class xlib_client_message_event_c: xlib_any_event_c]]
--[[@field type 33]]
--[[@field message_type xlib_atom_c]]
--[[@field format integer]]
--[[@field b integer[] ]]
--[[@field s integer[] ]]
--[[@field l integer[] ]]

--[[@class xlib_mapping_event_c: xlib_any_event_c]]
--[[@field type 34]]
--[[@field request xlib_mapping_type]]
--[[@field first_keycode integer]]
--[[@field count integer]]

--[[@class xlib_error_event_c]]
--[[@field type integer]]
--[[@field display ptr_c<xlib_display_c>]]
--[[@field resourceid xlib_id_c]]
--[[@field serial integer]]
--[[@field error_code integer]]
--[[@field request_code integer major opcode]]
--[[@field minor_code integer minor opcode]]

--[[@class xlib_generic_event_c: _xlib_base_event_c]]
--[[@field type 35]]
--[[@field extension integer]]
--[[@field evtype integer]]

--[[@class xlib_generic_event_cookie_c: xlib_generic_event_c]]
--[[@field cookie integer]]
--[[@field data ffi.cdata*]]


--[[@class xlib_event_c]]
--[[@field type xlib_event_type]]
--[[@field xany xlib_any_event_c]]
--[[@field xkey xlib_key_event_c]]
--[[@field xbutton xlib_button_event_c]]
--[[@field xmotion xlib_motion_event_c]]
--[[@field xcrossing xlib_crossing_event_c]]
--[[@field xfocus xlib_focus_change_event_c]]
--[[@field xexpose xlib_expose_event_c]]
--[[@field xgraphicsexpose xlib_graphics_expose_event_c]]
--[[@field xnoexpose xlib_no_expose_event_c]]
--[[@field xvisibility xlib_visibility_event_c]]
--[[@field xcreatewindow xlib_create_window_event_c]]
--[[@field xdestroywindow xlib_destroy_window_event_c]]
--[[@field xunmap xlib_unmap_event_c]]
--[[@field xmap xlib_map_event_c]]
--[[@field xmaprequest xlib_map_request_event_c]]
--[[@field xreparent xlib_reparent_event_c]]
--[[@field xconfigure xlib_configure_event_c]]
--[[@field xgravity xlib_gravity_event_c]]
--[[@field xresizerequest xlib_resize_request_event_c]]
--[[@field xconfigurerequest xlib_configure_request_event_c]]
--[[@field xcirculate xlib_circulate_event_c]]
--[[@field xcirculaterequest xlib_circulate_request_event_c]]
--[[@field xproperty xlib_property_event_c]]
--[[@field xselectionclear xlib_selection_clear_event_c]]
--[[@field xselectionrequest xlib_selection_request_event_c]]
--[[@field xselection xlib_selection_event_c]]
--[[@field xcolormap xlib_colormap_event_c]]
--[[@field xclient xlib_client_message_event_c]]
--[[@field xmapping xlib_mapping_event_c]]
--[[@field xerror xlib_error_event_c]]
--[[@field xkeymap xlib_keymap_event_c]]
--[[@field xgeneric xlib_generic_event_c]]
--[[@field xcookie xlib_generic_event_cookie_c]]

--[[Extensions need a way to hang private data on some structures.]]
--[[@class xlib_ext_data_c]]
--[[@field number integer number returned by XRegisterExtension]]
--[[@field next? ptr_c<xlib_ext_data_c>]]
--[[@field free_private fun(extension: ptr_c<xlib_ext_data_c>)]]
--[[@field private_data ptr_c<unknown>]]

--[[Visual structure; contains information about colormapping possible.]]
--[[@class xlib_visual_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field visualid xlib_visualid_c]]
--[[@field class integer e.g. monochrome]]
--[[@field red_mask integer]]
--[[@field green_mask integer]]
--[[@field blue_mask integer]]
--[[@field bits_per_rgb integer]]
--[[@field map_entries integer]]

--[[@class xlib_gc_values_c]]
--[[@field function integer logical operation]]
--[[@field plane_mask integer plane mask]]
--[[@field foreground integer foreground pixel]]
--[[@field background integer background pixel]]
--[[@field line_width integer line width]]
--[[@field line_style xlib_line_style]]
--[[@field cap_style xlib_cap_style]]
--[[@field join_style integer xlib_join_style]]
--[[@field fill_style integer xlib_fill_style]]
--[[@field fill_rule integer xlib_fill_rule]]
--[[@field arc_mode integer xlib_arc_mode]]
--[[@field tile xlib_pixmap_c for tiling operations]]
--[[@field stipple xlib_pixmap_c stipple 1 plane pixmap for stippling]]
--[[@field ts_x_origin integer offset for tile or stipple operations]]
--[[@field ts_y_origin integer]]
--[[@field font xlib_font_c default text font for text operations]]
--[[@field subwindow_mode xlib_subwindow_mode]]
--[[@field graphics_exposures boolean should exposures be generated]]
--[[@field clip_x_origin integer origin for clipping]]
--[[@field clip_y_origin integer]]
--[[@field clip_mask xlib_pixmap_c bitmap clipping; other calls for rects]]
--[[@field dash_offset integer patterned/dashed line information]]
--[[@field dashes integer char]]

--[[Graphics context.  ]]
--[[The contents of this structure are implementation dependent.  ]]
--[[A GC should be treated as opaque by application code.]]
--[[@class xlib__gc_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field gid xlib_gcontext_c]]

--[[@alias xlib_gc_c ptr_c<xlib__gc_c>]]

--[[Depth structure; contains information for each possible depth.]]
--[[@class xlib_depth_c]]
--[[@field depth integer]]
--[[@field nvisuals integer]]
--[[@field visuals xlib_visual_c[] ]]

--[[@class xlib_screen_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field display ptr_c<xlib_display_c> parent]]
--[[@field root xlib_window_c]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field mwidth integer millimeters]]
--[[@field mheight integer millimeters]]
--[[@field ndepths integer]]
--[[@field depths xlib_depth_c[] ]]
--[[@field root_depth integer bits per pixel]]
--[[@field root_visual ptr_c<xlib_visual_c>]]
--[[@field default_gc xlib_gc_c GC for the root visual]]
--[[@field cmap xlib_colormap_c default color map]]
--[[@field white_pixel integer white pixel value]]
--[[@field black_pixel integer black pixel value]]
--[[@field max_maps integer max color map]]
--[[@field min_maps integer min color map]]
--[[@field backing_store xlib_backing_store]]
--[[@field save_unders boolean]]
--[[@field root_input_mask integer]]

--[[Format structure; describes ZFormat data the screen will understand.]]
--[[@class xlib_screen_format_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field depth integer]]
--[[@field bits_per_pixel integer]]
--[[@field scanline_pad integer]]

--[[@class xlib_set_window_attributes_c]]
--[[@field background_pixmap xlib_pixmap_c can be `None` or `ParentRelative`]]
--[[@field background_pixel integer]]
--[[@field border_pixmap xlib_pixmap_c]]
--[[@field border_pixel integer]]
--[[@field bit_gravity xlib_gravity]]
--[[@field win_gravity xlib_gravity]]
--[[@field backing_store xlib_backing_store]]
--[[@field backing_planes integer planes to be preserved if possible]]
--[[@field backing_pixel integer value to use in restoring planes]]
--[[@field save_under boolean should bits under be saved? (popups)]]
--[[@field event_mask xlib_input_event_mask saved events mask]]
--[[@field do_not_propagate_mask integer]]
--[[@field override_redirect boolean]]
--[[@field colormap xlib_colormap_c]]
--[[@field cursor xlib_cursor_c can be `None`]]

--[[@class xlib_time_coord_c]]
--[[@field time xlib_time_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_display_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field fd fd_c]]
--[[@field proto_major_version integer]]
--[[@field proto_minor_version integer]]
--[[@field vendor string]]
--[[@field resource_alloc fun(display: ptr_c<xlib_display_c>): xlib_id_c]]
--[[@field byte_order xlib_bit_byte_order]]
--[[@field bitmap_unit integer]]
--[[@field bitmap_pad integer]]
--[[@field bitmap_bit_order xlib_bit_byte_order]]
--[[@field nformats integer]]
--[[@field pixmap_format ptr_c<xlib_screen_format_c>]]
--[[@field release integer]]
--[[@field qlen integer]]
--[[@field last_request_read integer]]
--[[@field request integer]]
--[[@field max_request_size integer]]
--[[@field display_name string]]
--[[@field default_screen integer]]
--[[@field nscreens integer]]
--[[@field screens xlib_screen_c[] ]]
--[[@field motion_buffer integer]]
--[[@field min_keycode xlib_key_code_c]]
--[[@field max_keycode xlib_key_code_c]]
--[[@field xdefaults string]]

-- unused fields should stay for plugin dx
--[[@class xlib_window_attributes_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field depth integer]]
--[[@field visual ptr_c<xlib_visual_c>]]
--[[@field root xlib_window_c]]
--[[@field class integer TODO: enum?]]
--[[@field bit_gravity xlib_gravity]]
--[[@field win_gravity xlib_gravity]]
--[[@field backing_store xlib_backing_store]]
--[[@field backing_planes integer]]
--[[@field backing_pixel integer]]
--[[@field save_under boolean]]
--[[@field colormap xlib_colormap_c]]
--[[@field map_installed boolean]]
--[[@field map_state xlib_map_state]]
--[[@field all_event_masks xlib_input_event_mask]]
--[[@field your_event_mask xlib_input_event_mask]]
--[[@field do_not_propagate_mask xlib_input_event_mask]]
--[[@field override_redirect boolean]]
--[[@field screen ptr_c<xlib_screen_c>]]

--[[@class xlib_size_hints_c]]
--[[@field flags xlib_size_flag marks which fields in this structure are defined]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer should set so old wms don't mess up]]
--[[@field height integer should set so old wms don't mess up]]
--[[@field min_width integer]]
--[[@field min_height integer]]
--[[@field max_width integer]]
--[[@field max_height integer]]
--[[@field width_inc integer]]
--[[@field height_inc integer]]
--[[@field min_aspect { x: integer; y: integer; }]]
--[[@field max_aspect { x: integer; y: integer; }]]
--[[@field base_width integer]]
--[[@field base_height integer]]
--[[@field win_gravity xlib_gravity]]

--[[@class xlib_class_hint_c]]
--[[@field res_name string]]
--[[@field res_class string]]

--[[new structure for manipulating `TEXT` properties  ]]
--[[used with `WM_NAME`, `WM_ICON_NAME`, `WM_CLIENT_MACHINE`, and `WM_COMMAND`.]]
--[[@class xlib_text_property_c]]
--[[@field value string]]
--[[@field encoding xlib_atom_c]]
--[[@field format 8|16|32]]
--[[@field nitems integer]]

--[[@class xlib_compose_status_c]]
--[[@field compose_ptr xlib_pointer_c state table pointer]]
--[[@field matched integer match state]]

--[[@class xlib_record_client_spec_c: integer]]
--[[@class xlib_record_context_c: integer]]

--[[@alias xlib_record_intercept_proc_c fun(closure: ffi.cdata*, recorded_data: ptr_c<xlib_record_intercept_data_c>)]]

--[[@class xlib_record_range_8_c]]
--[[@field first integer]]
--[[@field last integer]]

--[[@class xlib_record_range_16_c]]
--[[@field first integer]]
--[[@field last integer]]

--[[@class xlib_record_ext_range_c]]
--[[@field ext_major xlib_record_range_8_c]]
--[[@field ext_minor xlib_record_range_16_c]]

--[[@class xlib_record_range_c]]
--[[@field core_requests xlib_record_range_8_c core X requests]]
--[[@field core_replies xlib_record_range_8_c core X replies]]
--[[@field ext_requests xlib_record_ext_range_c extension requests]]
--[[@field ext_replies xlib_record_ext_range_c extension replies]]
--[[@field delivered_events xlib_record_range_8_c delivered core and ext events]]
--[[@field device_events xlib_record_range_8_c all core and ext device events]]
--[[@field errors xlib_record_range_8_c  core X and ext errors]]
--[[@field client_started boolean connection setup reply]]
--[[@field client_died boolean notice of client disconnect]]

--[[@class xlib_record_client_info_c]]
--[[@field client xlib_record_client_spec_c]]
--[[@field nranges integer]]
--[[@field ranges ptr_c<xlib_record_range_c[]> ]]

--[[@class xlib_record_state_c]]
--[[@field enabled boolean]]
--[[@field datum_flags xlib_record_datum_flag]]
--[[@field nclients integer]]
--[[@field client_info ptr_c<xlib_record_client_info_c[]> ]]

--[[@class xlib_record_intercept_data_c]]
--[[@field id_base xlib_id_c]]
--[[@field server_time xlib_time_c]]
--[[@field client_seq integer]]
--[[@field category integer]]
--[[@field client_swapped boolean]]
--[[@field data string]]
--[[@field data_len integer in 4-byte units]]

--[[@class xlib_visual_info_c]]
--[[@field visual ptr_c<xlib_visual_c>]]
--[[@field visualid xlib_visualid_c]]
--[[@field screen integer]]
--[[@field depth integer]]
--[[@field class integer]]
--[[@field red_mask integer]]
--[[@field green_mask integer]]
--[[@field blue_mask integer]]
--[[@field colormap_size integer]]
--[[@field bits_per_rgb integer]]

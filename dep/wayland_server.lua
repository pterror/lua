local ffi = require("ffi")

local mod = {}

ffi.cdef [[
	enum wl_data_device_error {
		WL_DATA_DEVICE_ERROR_ROLE,
	};

	enum wl_display_error {
		WL_DISPLAY_ERROR_INVALID_OBJECT,
		WL_DISPLAY_ERROR_INVALID_METHOD,
		WL_DISPLAY_ERROR_NO_MEMORY,
	};

	enum wl_keyboard_key_state {
		WL_KEYBOARD_KEY_STATE_RELEASED,
		WL_KEYBOARD_KEY_STATE_PRESSED,
	};

	enum wl_keyboard_keymap_format {
		WL_KEYBOARD_KEYMAP_FORMAT_NO_KEYMAP,
		WL_KEYBOARD_KEYMAP_FORMAT_XKB_V1,
	};

	enum wl_output_mode {
		WL_OUTPUT_MODE_CURRENT = 0x1,
		WL_OUTPUT_MODE_PREFERRED = 0x2,
	};

	enum wl_output_subpixel {
		WL_OUTPUT_SUBPIXEL_UNKNOWN,
		WL_OUTPUT_SUBPIXEL_NONE,
		WL_OUTPUT_SUBPIXEL_HORIZONTAL_RGB,
		WL_OUTPUT_SUBPIXEL_HORIZONTAL_BGR,
		WL_OUTPUT_SUBPIXEL_VERTICAL_RGB,
		WL_OUTPUT_SUBPIXEL_VERTICAL_BGR,
	};

	enum wl_output_transform {
		WL_OUTPUT_TRANSFORM_NORMAL,
		WL_OUTPUT_TRANSFORM_90,
		WL_OUTPUT_TRANSFORM_180,
		WL_OUTPUT_TRANSFORM_270,
		WL_OUTPUT_TRANSFORM_FLIPPED,
		WL_OUTPUT_TRANSFORM_FLIPPED_90,
		WL_OUTPUT_TRANSFORM_FLIPPED_180,
		WL_OUTPUT_TRANSFORM_FLIPPED_270,
	};

	enum wl_pointer_axis {
		WL_POINTER_AXIS_VERTICAL_SCROLL,
		WL_POINTER_AXIS_HORIZONTAL_SCROLL,
	};

	enum wl_pointer_button_state {
		WL_POINTER_BUTTON_STATE_RELEASED,
		WL_POINTER_BUTTON_STATE_PRESSED,
	};

	enum wl_pointer_error {
		WL_POINTER_ERROR_ROLE,
	};

	enum wl_seat_capability {
		WL_SEAT_CAPABILITY_POINTER,
		WL_SEAT_CAPABILITY_KEYBOARD,
		WL_SEAT_CAPABILITY_TOUCH,
	};

	enum wl_shell_error {
		WL_SHELL_ERROR_ROLE,
	};

	enum wl_shell_surface_fullscreen_method {
		WL_SHELL_SURFACE_FULLSCREEN_METHOD_DEFAULT,
		WL_SHELL_SURFACE_FULLSCREEN_METHOD_SCALE,
		WL_SHELL_SURFACE_FULLSCREEN_METHOD_DRIVER,
		WL_SHELL_SURFACE_FULLSCREEN_METHOD_FILL,
	};

	enum wl_shell_surface_resize {
		WL_SHELL_SURFACE_RESIZE_NONE,
		WL_SHELL_SURFACE_RESIZE_TOP,
		WL_SHELL_SURFACE_RESIZE_BOTTOM,
		WL_SHELL_SURFACE_RESIZE_LEFT,
		WL_SHELL_SURFACE_RESIZE_TOP_LEFT,
		WL_SHELL_SURFACE_RESIZE_BOTTOM_LEFT,
		WL_SHELL_SURFACE_RESIZE_RIGHT,
		WL_SHELL_SURFACE_RESIZE_TOP_RIGHT,
		WL_SHELL_SURFACE_RESIZE_BOTTOM_RIGHT,
	};

	enum wl_shell_surface_transient {
		WL_SHELL_SURFACE_TRANSIENT_INACTIVE = 0x1,
	};

	enum wl_shm_error {
		WL_SHM_ERROR_INVALID_FORMAT,
		WL_SHM_ERROR_INVALID_STRIDE,
		WL_SHM_ERROR_INVALID_FD,
	};

	enum wl_shm_format {
		WL_SHM_FORMAT_ARGB8888,
		WL_SHM_FORMAT_XRGB8888,
		WL_SHM_FORMAT_C8 = 0x20203843,
		WL_SHM_FORMAT_RGB332 = 0x38424752,
		WL_SHM_FORMAT_BGR233 = 0x38524742,
		WL_SHM_FORMAT_XRGB4444 = 0x32315258,
		WL_SHM_FORMAT_XBGR4444 = 0x32314258,
		WL_SHM_FORMAT_RGBX4444 = 0x32315852,
		WL_SHM_FORMAT_BGRX4444 = 0x32315842,
		WL_SHM_FORMAT_ARGB4444 = 0x32315241,
		WL_SHM_FORMAT_ABGR4444 = 0x32314241,
		WL_SHM_FORMAT_RGBA4444 = 0x32314152,
		WL_SHM_FORMAT_BGRA4444 = 0x32314142,
		WL_SHM_FORMAT_XRGB1555 = 0x35315258,
		WL_SHM_FORMAT_XBGR1555 = 0x35314258,
		WL_SHM_FORMAT_RGBX5551 = 0x35315852,
		WL_SHM_FORMAT_BGRX5551 = 0x35315842,
		WL_SHM_FORMAT_ARGB1555 = 0x35315241,
		WL_SHM_FORMAT_ABGR1555 = 0x35314241,
		WL_SHM_FORMAT_RGBA5551 = 0x35314152,
		WL_SHM_FORMAT_BGRA5551 = 0x35314142,
		WL_SHM_FORMAT_RGB565 = 0x36314752,
		WL_SHM_FORMAT_BGR565 = 0x36314742,
		WL_SHM_FORMAT_RGB888 = 0x34324752,
		WL_SHM_FORMAT_BGR888 = 0x34324742,
		WL_SHM_FORMAT_XBGR8888 = 0x34324258,
		WL_SHM_FORMAT_RGBX8888 = 0x34325852,
		WL_SHM_FORMAT_BGRX8888 = 0x34325842,
		WL_SHM_FORMAT_ABGR8888 = 0x34324241,
		WL_SHM_FORMAT_RGBA8888 = 0x34324152,
		WL_SHM_FORMAT_BGRA8888 = 0x34324142,
		WL_SHM_FORMAT_XRGB2101010 = 0x30335258,
		WL_SHM_FORMAT_XBGR2101010 = 0x30334258,
		WL_SHM_FORMAT_RGBX1010102 = 0x30335852,
		WL_SHM_FORMAT_BGRX1010102 = 0x30335842,
		WL_SHM_FORMAT_ARGB2101010 = 0x30335241,
		WL_SHM_FORMAT_ABGR2101010 = 0x30334241,
		WL_SHM_FORMAT_RGBA1010102 = 0x30334152,
		WL_SHM_FORMAT_BGRA1010102 = 0x30334142,
		WL_SHM_FORMAT_YUYV = 0x56595559,
		WL_SHM_FORMAT_YVYU = 0x55595659,
		WL_SHM_FORMAT_UYVY = 0x59565955,
		WL_SHM_FORMAT_VYUY = 0x59555956,
		WL_SHM_FORMAT_AYUV = 0x56555941,
		WL_SHM_FORMAT_NV12 = 0x3231564e,
		WL_SHM_FORMAT_NV21 = 0x3132564e,
		WL_SHM_FORMAT_NV16 = 0x3631564e,
		WL_SHM_FORMAT_NV61 = 0x3136564e,
		WL_SHM_FORMAT_YUV410 = 0x39565559,
		WL_SHM_FORMAT_YVU410 = 0x39555659,
		WL_SHM_FORMAT_YUV411 = 0x31315559,
		WL_SHM_FORMAT_YVU411 = 0x31315659,
		WL_SHM_FORMAT_YUV420 = 0x32315559,
		WL_SHM_FORMAT_YVU420 = 0x32315659,
		WL_SHM_FORMAT_YUV422 = 0x36315559,
		WL_SHM_FORMAT_YVU422 = 0x36315659,
		WL_SHM_FORMAT_YUV444 = 0x34325559,
		WL_SHM_FORMAT_YVU444 = 0x34325659,
	};

	enum wl_subcompositor_error {
		WL_SUBCOMPOSITOR_ERROR_BAD_SURFACE,
	};

	enum wl_subsurface_error {
		WL_SUBSURFACE_ERROR_BAD_SURFACE,
	};

	enum wl_surface_error {
		WL_SURFACE_ERROR_INVALID_SCALE,
		WL_SURFACE_ERROR_INVALID_TRANSFORM,
	};
	enum wp_cursor_shape_device_v1_shape {
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_DEFAULT = 1,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_CONTEXT_MENU = 2,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_HELP = 3,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_POINTER = 4,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_PROGRESS = 5,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_WAIT = 6,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_CELL = 7,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_CROSSHAIR = 8,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_TEXT = 9,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_VERTICAL_TEXT = 10,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_ALIAS = 11,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_COPY = 12,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_MOVE = 13,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NO_DROP = 14,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NOT_ALLOWED = 15,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_GRAB = 16,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_GRABBING = 17,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_E_RESIZE = 18,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_N_RESIZE = 19,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NE_RESIZE = 20,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NW_RESIZE = 21,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_S_RESIZE = 22,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_SE_RESIZE = 23,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_SW_RESIZE = 24,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_W_RESIZE = 25,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_EW_RESIZE = 26,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NS_RESIZE = 27,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NESW_RESIZE = 28,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_NWSE_RESIZE = 29,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_COL_RESIZE = 30,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_ROW_RESIZE = 31,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_ALL_SCROLL = 32,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_ZOOM_IN = 33,
		WP_CURSOR_SHAPE_DEVICE_V1_SHAPE_ZOOM_OUT = 34,
	};
	enum wl_data_device_manager_dnd_action {
		WL_DATA_DEVICE_MANAGER_DND_ACTION_NONE = 0,
		WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY = 1,
		WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE = 2,
		WL_DATA_DEVICE_MANAGER_DND_ACTION_ASK = 4
	};
	enum wl_pointer_axis_source {
		WL_POINTER_AXIS_SOURCE_WHEEL,
		WL_POINTER_AXIS_SOURCE_FINGER,
		WL_POINTER_AXIS_SOURCE_CONTINUOUS,
		WL_POINTER_AXIS_SOURCE_WHEEL_TILT,
	};
	enum zwp_fullscreen_shell_v1_present_method {
		ZWP_FULLSCREEN_SHELL_V1_PRESENT_METHOD_DEFAULT,
		ZWP_FULLSCREEN_SHELL_V1_PRESENT_METHOD_CENTER,
		ZWP_FULLSCREEN_SHELL_V1_PRESENT_METHOD_ZOOM,
		ZWP_FULLSCREEN_SHELL_V1_PRESENT_METHOD_ZOOM_CROP,
		ZWP_FULLSCREEN_SHELL_V1_PRESENT_METHOD_STRETCH,
	};
	enum zwlr_layer_surface_v1_keyboard_interactivity {
		ZWLR_LAYER_SURFACE_V1_KEYBOARD_INTERACTIVITY_NONE,
		ZWLR_LAYER_SURFACE_V1_KEYBOARD_INTERACTIVITY_EXCLUSIVE,
		ZWLR_LAYER_SURFACE_V1_KEYBOARD_INTERACTIVITY_ON_DEMAND,
	};
	enum zwlr_layer_shell_v1_layer {
		ZWLR_LAYER_SHELL_V1_LAYER_BACKGROUND,
		ZWLR_LAYER_SHELL_V1_LAYER_BOTTOM,
		ZWLR_LAYER_SHELL_V1_LAYER_TOP,
		ZWLR_LAYER_SHELL_V1_LAYER_OVERLAY,
	};
	enum zwlr_output_power_v1_mode {
		ZWLR_OUTPUT_POWER_V1_MODE_OFF,
		ZWLR_OUTPUT_POWER_V1_MODE_ON,
	};
	enum wl_pointer_axis_relative_direction {
		WL_POINTER_AXIS_RELATIVE_DIRECTION_IDENTICAL,
		WL_POINTER_AXIS_RELATIVE_DIRECTION_INVERTED,
	};
	enum zwp_pointer_constraints_v1_lifetime {
		ZWP_POINTER_CONSTRAINTS_V1_LIFETIME_ONESHOT = 1,
		ZWP_POINTER_CONSTRAINTS_V1_LIFETIME_PERSISTENT = 2,
	};
	enum wp_tearing_control_v1_presentation_hint {
		WP_TEARING_CONTROL_V1_PRESENTATION_HINT_VSYNC,
		WP_TEARING_CONTROL_V1_PRESENTATION_HINT_ASYNC,
	};
	enum xdg_positioner_anchor {
		XDG_POSITIONER_ANCHOR_NONE = 0,
		XDG_POSITIONER_ANCHOR_TOP = 1,
		XDG_POSITIONER_ANCHOR_BOTTOM = 2,
		XDG_POSITIONER_ANCHOR_LEFT = 3,
		XDG_POSITIONER_ANCHOR_RIGHT = 4,
		XDG_POSITIONER_ANCHOR_TOP_LEFT = 5,
		XDG_POSITIONER_ANCHOR_BOTTOM_LEFT = 6,
		XDG_POSITIONER_ANCHOR_TOP_RIGHT = 7,
		XDG_POSITIONER_ANCHOR_BOTTOM_RIGHT = 8,
	};
	enum xdg_positioner_gravity {
		XDG_POSITIONER_GRAVITY_NONE = 0,
		XDG_POSITIONER_GRAVITY_TOP = 1,
		XDG_POSITIONER_GRAVITY_BOTTOM = 2,
		XDG_POSITIONER_GRAVITY_LEFT = 3,
		XDG_POSITIONER_GRAVITY_RIGHT = 4,
		XDG_POSITIONER_GRAVITY_TOP_LEFT = 5,
		XDG_POSITIONER_GRAVITY_BOTTOM_LEFT = 6,
		XDG_POSITIONER_GRAVITY_TOP_RIGHT = 7,
		XDG_POSITIONER_GRAVITY_BOTTOM_RIGHT = 8,
	};
	enum xdg_positioner_constraint_adjustment {
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_NONE = 0,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_SLIDE_X = 1,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_SLIDE_Y = 2,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_FLIP_X = 4,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_FLIP_Y = 8,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_RESIZE_X = 16,
		XDG_POSITIONER_CONSTRAINT_ADJUSTMENT_RESIZE_Y = 32,
	};
	/*
	* Copyright © 2008 Kristian Høgsberg
	*
	* Permission is hereby granted, free of charge, to any person obtaining
	* a copy of this software and associated documentation files (the
	* "Software"), to deal in the Software without restriction, including
	* without limitation the rights to use, copy, modify, merge, publish,
	* distribute, sublicense, and/or sell copies of the Software, and to
	* permit persons to whom the Software is furnished to do so, subject to
	* the following conditions:
	*
	* The above copyright notice and this permission notice (including the
	* next paragraph) shall be included in all copies or substantial
	* portions of the Software.
	*
	* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	* NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
	* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
	* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	* SOFTWARE.
	*/
	typedef signed int pid_t;
	typedef unsigned int uid_t;
	typedef unsigned int gid_t;
	// https://gitlab.freedesktop.org/wayland/wayland/-/blob/main/src/wayland-util.h
	struct wl_object;
	struct wl_message {
		const char *name;
		const char *signature;
		const struct wl_interface **types;
	};
	struct wl_interface {
		const char *name;
		int version;
		int method_count;
		const struct wl_message *methods;
		int event_count;
		const struct wl_message *events;
	};
	struct wl_list {
			struct wl_list *prev;
			struct wl_list *next;
	};
	void wl_list_init(struct wl_list *list);
	void wl_list_insert(struct wl_list *list, struct wl_list *elm);
	void wl_list_remove(struct wl_list *elm);
	int wl_list_length(const struct wl_list *list);
	int wl_list_empty(const struct wl_list *list);
	void wl_list_insert_list(struct wl_list *list, struct wl_list *other);
	struct wl_array {
			size_t size;
			size_t alloc;
			void *data;
	};
	void wl_array_init(struct wl_array *array);
	void wl_array_release(struct wl_array *array);
	void *wl_array_add(struct wl_array *array, size_t size);
	int wl_array_copy(struct wl_array *array, struct wl_array *source);
	typedef int32_t wl_fixed_t;
	union wl_argument {
		int32_t i;
		uint32_t u;
		wl_fixed_t f;
		const char *s;
		struct wl_object *o;
		uint32_t n;
		struct wl_array *a;
		int32_t h;
	};
	typedef int (*wl_dispatcher_func_t)(const void *user_data, void *target, uint32_t opcode, const struct wl_message *msg, union wl_argument *args);
	typedef void (*wl_log_func_t)(const char *fmt, va_list args); // WL_PRINTF(1, 0);
	enum wl_iterator_result {
			WL_ITERATOR_STOP,
			WL_ITERATOR_CONTINUE
	};

	// https://gitlab.freedesktop.org/wayland/wayland/-/blob/main/src/wayland-server-core.h
	enum {
		WL_EVENT_READABLE = 0x01,
		WL_EVENT_WRITABLE = 0x02,
		WL_EVENT_HANGUP   = 0x04,
		WL_EVENT_ERROR    = 0x08
	};
	typedef int (*wl_event_loop_fd_func_t)(int fd, uint32_t mask, void *data);
	typedef int (*wl_event_loop_timer_func_t)(void *data);
	typedef int (*wl_event_loop_signal_func_t)(int signal_number, void *data);
	typedef void (*wl_event_loop_idle_func_t)(void *data);
	struct wl_event_loop *wl_event_loop_create(void);
	void wl_event_loop_destroy(struct wl_event_loop *loop);
	struct wl_event_source *wl_event_loop_add_fd(struct wl_event_loop *loop, int fd, uint32_t mask, wl_event_loop_fd_func_t func, void *data);
	int wl_event_source_fd_update(struct wl_event_source *source, uint32_t mask);
	struct wl_event_source *wl_event_loop_add_timer(struct wl_event_loop *loop, wl_event_loop_timer_func_t func, void *data);
	struct wl_event_source *wl_event_loop_add_signal(struct wl_event_loop *loop, int signal_number, wl_event_loop_signal_func_t func, void *data);
	int wl_event_source_timer_update(struct wl_event_source *source, int ms_delay);
	int wl_event_source_remove(struct wl_event_source *source);
	void wl_event_source_check(struct wl_event_source *source);
	int wl_event_loop_dispatch(struct wl_event_loop *loop, int timeout);
	void wl_event_loop_dispatch_idle(struct wl_event_loop *loop);
	struct wl_event_source *wl_event_loop_add_idle(struct wl_event_loop *loop, wl_event_loop_idle_func_t func, void *data);
	int wl_event_loop_get_fd(struct wl_event_loop *loop);
	struct wl_listener;
	typedef void (*wl_notify_func_t)(struct wl_listener *listener, void *data);
	void wl_event_loop_add_destroy_listener(struct wl_event_loop *loop, struct wl_listener *listener);
	struct wl_listener *wl_event_loop_get_destroy_listener(struct wl_event_loop *loop, wl_notify_func_t notify);
	struct wl_display *wl_display_create(void);
	void wl_display_destroy(struct wl_display *display);
	struct wl_event_loop *wl_display_get_event_loop(struct wl_display *display);
	int wl_display_add_socket(struct wl_display *display, const char *name);
	const char *wl_display_add_socket_auto(struct wl_display *display);
	int wl_display_add_socket_fd(struct wl_display *display, int sock_fd);
	void wl_display_terminate(struct wl_display *display);
	void wl_display_run(struct wl_display *display);
	void wl_display_flush_clients(struct wl_display *display);
	void wl_display_destroy_clients(struct wl_display *display);
	void wl_display_set_default_max_buffer_size(struct wl_display *display, size_t max_buffer_size);
	struct wl_client;
	typedef void (*wl_global_bind_func_t)(struct wl_client *client, void *data, uint32_t version, uint32_t id);
	uint32_t wl_display_get_serial(struct wl_display *display);
	uint32_t wl_display_next_serial(struct wl_display *display);
	void wl_display_add_destroy_listener(struct wl_display *display, struct wl_listener *listener);
	void wl_display_add_client_created_listener(struct wl_display *display, struct wl_listener *listener);
	struct wl_listener *wl_display_get_destroy_listener(struct wl_display *display, wl_notify_func_t notify);
	struct wl_global *wl_global_create(struct wl_display *display, const struct wl_interface *interface, int version, void *data, wl_global_bind_func_t bind);
	void wl_global_remove(struct wl_global *global);
	void wl_global_destroy(struct wl_global *global);
	typedef bool (*wl_display_global_filter_func_t)(const struct wl_client *client, const struct wl_global *global, void *data);
	void wl_display_set_global_filter(struct wl_display *display, wl_display_global_filter_func_t filter, void *data);
	const struct wl_interface *wl_global_get_interface(const struct wl_global *global);
	uint32_t wl_global_get_name(const struct wl_global *global, const struct wl_client *client);
	uint32_t wl_global_get_version(const struct wl_global *global);
	struct wl_display *wl_global_get_display(const struct wl_global *global);
	void *wl_global_get_user_data(const struct wl_global *global);
	void wl_global_set_user_data(struct wl_global *global, void *data);
	struct wl_client *wl_client_create(struct wl_display *display, int fd);
	struct wl_list *wl_display_get_client_list(struct wl_display *display);
	struct wl_list *wl_client_get_link(struct wl_client *client);
	struct wl_client *wl_client_from_link(struct wl_list *link);
	void wl_client_destroy(struct wl_client *client);
	void wl_client_flush(struct wl_client *client);
	void wl_client_get_credentials(struct wl_client *client, pid_t *pid, uid_t *uid, gid_t *gid);
	int wl_client_get_fd(struct wl_client *client);
	void wl_client_add_destroy_listener(struct wl_client *client, struct wl_listener *listener);
	struct wl_listener *wl_client_get_destroy_listener(struct wl_client *client, wl_notify_func_t notify);
	void wl_client_add_destroy_late_listener(struct wl_client *client, struct wl_listener *listener);
	struct wl_listener *wl_client_get_destroy_late_listener(struct wl_client *client,wl_notify_func_t notify);
	struct wl_resource *wl_client_get_object(struct wl_client *client, uint32_t id);
	void wl_client_post_no_memory(struct wl_client *client);
	void wl_client_post_implementation_error(struct wl_client *client, const char* msg, ...); // WL_PRINTF(2,3);
	void 	wl_client_add_resource_created_listener(struct wl_client *client, struct wl_listener *listener);
	typedef enum wl_iterator_result (*wl_client_for_each_resource_iterator_func_t)(struct wl_resource *resource, void *user_data);
	void wl_client_for_each_resource(struct wl_client *client, wl_client_for_each_resource_iterator_func_t iterator, void *user_data);
	typedef void (*wl_user_data_destroy_func_t)(void *data);
	void wl_client_set_user_data(struct wl_client *client, void *data, wl_user_data_destroy_func_t dtor);
	void *wl_client_get_user_data(struct wl_client *client);
	void wl_client_set_max_buffer_size(struct wl_client *client, size_t max_buffer_size);
	struct wl_listener {
		struct wl_list link;
		wl_notify_func_t notify;
	};
	struct wl_signal {
		struct wl_list listener_list;
	};
	void wl_signal_emit_mutable(struct wl_signal *signal, void *data);
	typedef void (*wl_resource_destroy_func_t)(struct wl_resource *resource);
	void wl_resource_post_event(struct wl_resource *resource, uint32_t opcode, ...);
	void wl_resource_post_event_array(struct wl_resource *resource, uint32_t opcode, union wl_argument *args);
	void wl_resource_queue_event(struct wl_resource *resource, uint32_t opcode, ...);
	void wl_resource_queue_event_array(struct wl_resource *resource, uint32_t opcode, union wl_argument *args);
	/* msg is a printf format string, variable args are its args. */
	void 	wl_resource_post_error(struct wl_resource *resource, uint32_t code, const char *msg, ...); // WL_PRINTF(3, 4);
	void wl_resource_post_no_memory(struct wl_resource *resource);
	struct wl_display *wl_client_get_display(struct wl_client *client);
	struct wl_resource *wl_resource_create(struct wl_client *client, const struct wl_interface *interface, int version, uint32_t id);
	void wl_resource_set_implementation(struct wl_resource *resource, const void *implementation, void *data, wl_resource_destroy_func_t destroy);
	void wl_resource_set_dispatcher(struct wl_resource *resource, wl_dispatcher_func_t dispatcher, const void *implementation, void *data, wl_resource_destroy_func_t destroy);
	void wl_resource_destroy(struct wl_resource *resource);
	uint32_t wl_resource_get_id(struct wl_resource *resource);
	struct wl_list *	wl_resource_get_link(struct wl_resource *resource);
	struct wl_resource *wl_resource_from_link(struct wl_list *resource);
	struct wl_resource *wl_resource_find_for_client(struct wl_list *list, struct wl_client *client);
	struct wl_client *wl_resource_get_client(struct wl_resource *resource);
	void wl_resource_set_user_data(struct wl_resource *resource, void *data);
	void *wl_resource_get_user_data(struct wl_resource *resource);
	int wl_resource_get_version(struct wl_resource *resource);
	void wl_resource_set_destructor(struct wl_resource *resource, wl_resource_destroy_func_t destroy);
	int wl_resource_instance_of(struct wl_resource *resource, const struct wl_interface *interface, const void *implementation);
	const char *wl_resource_get_class(struct wl_resource *resource);
	void wl_resource_add_destroy_listener(struct wl_resource *resource, struct wl_listener *listener);
	struct wl_listener *wl_resource_get_destroy_listener(struct wl_resource *resource, wl_notify_func_t notify);
	struct wl_shm_buffer *wl_shm_buffer_get(struct wl_resource *resource);
	void wl_shm_buffer_begin_access(struct wl_shm_buffer *buffer);
	void wl_shm_buffer_end_access(struct wl_shm_buffer *buffer);
	void *wl_shm_buffer_get_data(struct wl_shm_buffer *buffer);
	int32_t wl_shm_buffer_get_stride(struct wl_shm_buffer *buffer);
	uint32_t wl_shm_buffer_get_format(struct wl_shm_buffer *buffer);
	int32_t wl_shm_buffer_get_width(struct wl_shm_buffer *buffer);
	int32_t wl_shm_buffer_get_height(struct wl_shm_buffer *buffer);
	struct wl_shm_pool *wl_shm_buffer_ref_pool(struct wl_shm_buffer *buffer);
	void wl_shm_pool_unref(struct wl_shm_pool *pool);
	int wl_display_init_shm(struct wl_display *display);
	uint32_t *	wl_display_add_shm_format(struct wl_display *display, uint32_t format);
	// deprecated
	struct wl_shm_buffer *wl_shm_buffer_create(struct wl_client *client, uint32_t id, int32_t width, int32_t height, int32_t stride, uint32_t format);
	void wl_log_set_handler_server(wl_log_func_t handler);
	enum wl_protocol_logger_type {
		WL_PROTOCOL_LOGGER_REQUEST,
		WL_PROTOCOL_LOGGER_EVENT,
	};
	struct wl_protocol_logger_message {
		struct wl_resource *resource;
		int message_opcode;
		const struct wl_message *message;
		int arguments_count;
		const union wl_argument *arguments;
	};
	typedef void (*wl_protocol_logger_func_t)(void *user_data, enum wl_protocol_logger_type direction, const struct wl_protocol_logger_message *message);
	struct wl_protocol_logger *wl_display_add_protocol_logger(struct wl_display *display, wl_protocol_logger_func_t, void *user_data);
	void wl_protocol_logger_destroy(struct wl_protocol_logger *logger);	
]]

--[[@param f integer]]
mod.wl_fixed_to_double = function(f) return f / 256 end
--[[@param d number]]
mod.wl_fixed_from_double = function(d) return math.floor(d * 256) end
--[[@param f integer]]
mod.wl_fixed_to_int = function(f) return bit.rshift(f, 8) end
--[[@param i integer]]
mod.wl_fixed_from_int = function(i) return i * 256 end

local dl = ffi.load("wayland-server")

--[[@param type string]]
--[[@param member string]]
mod.wl_container_of = function(ptr, type, member)
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	return ffi.cast(type .. "*", ffi.cast("char *", ptr) - ffi.offsetof(type, member))
end

--[[@param signal wl_signal]]
mod.wl_signal_init = function(signal)
	dl.wl_list_init(signal.listener_list)
end

--[[@param signal wl_signal]]
--[[@param listener wl_listener]]
mod.wl_signal_add = function(signal, listener)
	dl.wl_list_insert(signal.listener_list.prev, listener.link)
end

--[[TODO:
	static inline struct wl_listener *wl_signal_get(struct wl_signal *signal, wl_notify_func_t notify) {
		struct wl_listener *l;
		wl_list_for_each(l, &signal->listener_list, link)
			if (l->notify == notify) return l;
		return NULL;
	}
	static inline void wl_signal_emit(struct wl_signal *signal, void *data) {
		struct wl_listener *l, *next;
		wl_list_for_each_safe(l, next, &signal->listener_list, link) l->notify(l, data);
	}
	#define wl_client_for_each(client, list)				\
		for (client = wl_client_from_link((list)->next);	\
				 wl_client_get_link(client) != (list);			\
				 client = wl_client_from_link(wl_client_get_link(client)->next))
]]


--[[@type wayland_ffi]]
return setmetatable(mod, { __index = function(_, k) return dl[k] end })

--[[@class wayland_ffi]]

--[[@class wl_signal]]
--[[@field listener_list unknown]]

--[[@class wl_listener]]
--[[@field link unknown]]

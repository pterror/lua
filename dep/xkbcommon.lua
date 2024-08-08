local ffi = require("ffi")

ffi.cdef [[
	typedef struct FILE FILE;
	struct xkb_context;
	struct xkb_keymap;
	struct xkb_state;
	typedef uint32_t xkb_keycode_t;
	typedef uint32_t xkb_keysym_t;
	typedef uint32_t xkb_layout_index_t;
	typedef uint32_t xkb_layout_mask_t;
	typedef uint32_t xkb_level_index_t;
	typedef uint32_t xkb_mod_index_t;
	typedef uint32_t xkb_mod_mask_t;
	typedef uint32_t xkb_led_index_t;
	typedef uint32_t xkb_led_mask_t;
	struct xkb_rule_names {
		const char *rules;
		const char *model;
		const char *layout;
		const char *variant;
		const char *options;
	};
	int xkb_keysym_get_name(xkb_keysym_t keysym, char *buffer, size_t size);
	enum xkb_keysym_flags {
		XKB_KEYSYM_NO_FLAGS = 0,
		XKB_KEYSYM_CASE_INSENSITIVE = (1 << 0)
	};
	xkb_keysym_t xkb_keysym_from_name(const char *name, enum xkb_keysym_flags flags);
	int xkb_keysym_to_utf8(xkb_keysym_t keysym, char *buffer, size_t size);
	uint32_t xkb_keysym_to_utf32(xkb_keysym_t keysym);
	xkb_keysym_t xkb_utf32_to_keysym(uint32_t ucs);
	xkb_keysym_t xkb_keysym_to_upper(xkb_keysym_t ks);
	xkb_keysym_t xkb_keysym_to_lower(xkb_keysym_t ks);
	enum xkb_context_flags {
		XKB_CONTEXT_NO_FLAGS = 0,
		XKB_CONTEXT_NO_DEFAULT_INCLUDES = (1 << 0),
		XKB_CONTEXT_NO_ENVIRONMENT_NAMES = (1 << 1),
		XKB_CONTEXT_NO_SECURE_GETENV = (1 << 2)
	};
	struct xkb_context *xkb_context_new(enum xkb_context_flags flags);
	struct xkb_context *xkb_context_ref(struct xkb_context *context);
	void xkb_context_unref(struct xkb_context *context);
	void xkb_context_set_user_data(struct xkb_context *context, void *user_data);
	void *xkb_context_get_user_data(struct xkb_context *context);
	int xkb_context_include_path_append(struct xkb_context *context, const char *path);
	int xkb_context_include_path_append_default(struct xkb_context *context);
	int xkb_context_include_path_reset_defaults(struct xkb_context *context);
	void xkb_context_include_path_clear(struct xkb_context *context);
	unsigned int xkb_context_num_include_paths(struct xkb_context *context);
	const char *xkb_context_include_path_get(struct xkb_context *context, unsigned int index);
	enum xkb_log_level {
		XKB_LOG_LEVEL_CRITICAL = 10,
		XKB_LOG_LEVEL_ERROR = 20,
		XKB_LOG_LEVEL_WARNING = 30,
		XKB_LOG_LEVEL_INFO = 40,
		XKB_LOG_LEVEL_DEBUG = 50,
	};
	void xkb_context_set_log_level(struct xkb_context *context, enum xkb_log_level level);
	enum xkb_log_level xkb_context_get_log_level(struct xkb_context *context);
	void xkb_context_set_log_verbosity(struct xkb_context *context, int verbosity);
	int xkb_context_get_log_verbosity(struct xkb_context *context);
	void xkb_context_set_log_fn(struct xkb_context *context,
	void (*log_fn)(struct xkb_context *context, enum xkb_log_level level, const char *format, va_list args));
	enum xkb_keymap_compile_flags {
		XKB_KEYMAP_COMPILE_NO_FLAGS = 0,
	};
	struct xkb_keymap *xkb_keymap_new_from_names(struct xkb_context *context,
	const struct xkb_rule_names *names, enum xkb_keymap_compile_flags flags);
	enum xkb_keymap_format {
		XKB_KEYMAP_FORMAT_TEXT_V1 = 1,
	};
	struct xkb_keymap *xkb_keymap_new_from_file(struct xkb_context *context, FILE *file, enum xkb_keymap_format format, enum xkb_keymap_compile_flags flags);
	struct xkb_keymap *xkb_keymap_new_from_string(struct xkb_context *context, const char *string, enum xkb_keymap_format format, enum xkb_keymap_compile_flags flags);
	struct xkb_keymap *xkb_keymap_new_from_buffer(struct xkb_context *context, const char *buffer, size_t length, enum xkb_keymap_format format, enum xkb_keymap_compile_flags flags);
	struct xkb_keymap *xkb_keymap_ref(struct xkb_keymap *keymap);
	void xkb_keymap_unref(struct xkb_keymap *keymap);
	// #define XKB_KEYMAP_USE_ORIGINAL_FORMAT ((enum xkb_keymap_format) -1)
	char *xkb_keymap_get_as_string(struct xkb_keymap *keymap, enum xkb_keymap_format format);
	xkb_keycode_t xkb_keymap_min_keycode(struct xkb_keymap *keymap);
	xkb_keycode_t xkb_keymap_max_keycode(struct xkb_keymap *keymap);
	typedef void (*xkb_keymap_key_iter_t)(struct xkb_keymap *keymap, xkb_keycode_t key, void *data);
	void xkb_keymap_key_for_each(struct xkb_keymap *keymap, xkb_keymap_key_iter_t iter, void *data);
	const char *xkb_keymap_key_get_name(struct xkb_keymap *keymap, xkb_keycode_t key);
	xkb_keycode_t xkb_keymap_key_by_name(struct xkb_keymap *keymap, const char *name);
	xkb_mod_index_t xkb_keymap_num_mods(struct xkb_keymap *keymap);
	const char *xkb_keymap_mod_get_name(struct xkb_keymap *keymap, xkb_mod_index_t idx);
	xkb_mod_index_t xkb_keymap_mod_get_index(struct xkb_keymap *keymap, const char *name);
	xkb_layout_index_t xkb_keymap_num_layouts(struct xkb_keymap *keymap);
	const char *xkb_keymap_layout_get_name(struct xkb_keymap *keymap, xkb_layout_index_t idx);
	xkb_layout_index_t xkb_keymap_layout_get_index(struct xkb_keymap *keymap, const char *name);
	xkb_led_index_t xkb_keymap_num_leds(struct xkb_keymap *keymap);
	const char *xkb_keymap_led_get_name(struct xkb_keymap *keymap, xkb_led_index_t idx);
	xkb_led_index_t xkb_keymap_led_get_index(struct xkb_keymap *keymap, const char *name);
	xkb_layout_index_t xkb_keymap_num_layouts_for_key(struct xkb_keymap *keymap, xkb_keycode_t key);
	xkb_level_index_t xkb_keymap_num_levels_for_key(struct xkb_keymap *keymap, xkb_keycode_t key, xkb_layout_index_t layout);
	size_t xkb_keymap_key_get_mods_for_level(struct xkb_keymap *keymap, xkb_keycode_t key, xkb_layout_index_t layout, xkb_level_index_t level, xkb_mod_mask_t *masks_out, size_t masks_size);
	int xkb_keymap_key_get_syms_by_level(struct xkb_keymap *keymap, xkb_keycode_t key, xkb_layout_index_t layout, xkb_level_index_t level, const xkb_keysym_t **syms_out);
	int xkb_keymap_key_repeats(struct xkb_keymap *keymap, xkb_keycode_t key);
	struct xkb_state *xkb_state_new(struct xkb_keymap *keymap);
	struct xkb_state *xkb_state_ref(struct xkb_state *state);
	void xkb_state_unref(struct xkb_state *state);
	struct xkb_keymap * xkb_state_get_keymap(struct xkb_state *state);
	enum xkb_key_direction {
		XKB_KEY_UP,
		XKB_KEY_DOWN,
	};
	enum xkb_state_component {
		XKB_STATE_MODS_DEPRESSED = (1 << 0),
		XKB_STATE_MODS_LATCHED = (1 << 1),
		XKB_STATE_MODS_LOCKED = (1 << 2),
		XKB_STATE_MODS_EFFECTIVE = (1 << 3),
		XKB_STATE_LAYOUT_DEPRESSED = (1 << 4),
		XKB_STATE_LAYOUT_LATCHED = (1 << 5),
		XKB_STATE_LAYOUT_LOCKED = (1 << 6),
		XKB_STATE_LAYOUT_EFFECTIVE = (1 << 7),
		XKB_STATE_LEDS = (1 << 8),
	};
	enum xkb_state_component xkb_state_update_key(struct xkb_state *state, xkb_keycode_t key, enum xkb_key_direction direction);
	enum xkb_state_component xkb_state_update_mask(struct xkb_state *state, xkb_mod_mask_t depressed_mods, xkb_mod_mask_t latched_mods, xkb_mod_mask_t locked_mods, xkb_layout_index_t depressed_layout, xkb_layout_index_t latched_layout, xkb_layout_index_t locked_layout);
	int xkb_state_key_get_syms(struct xkb_state *state, xkb_keycode_t key, const xkb_keysym_t **syms_out);
	int xkb_state_key_get_utf8(struct xkb_state *state, xkb_keycode_t key, char *buffer, size_t size);
	uint32_t xkb_state_key_get_utf32(struct xkb_state *state, xkb_keycode_t key);
	xkb_keysym_t xkb_state_key_get_one_sym(struct xkb_state *state, xkb_keycode_t key);
	xkb_layout_index_t xkb_state_key_get_layout(struct xkb_state *state, xkb_keycode_t key);
	xkb_level_index_t xkb_state_key_get_level(struct xkb_state *state, xkb_keycode_t key, xkb_layout_index_t layout);
	enum xkb_state_match {
		XKB_STATE_MATCH_ANY = (1 << 0),
		XKB_STATE_MATCH_ALL = (1 << 1),
		XKB_STATE_MATCH_NON_EXCLUSIVE = (1 << 16)
	};
	xkb_mod_mask_t xkb_state_serialize_mods(struct xkb_state *state, enum xkb_state_component components);
	xkb_layout_index_t xkb_state_serialize_layout(struct xkb_state *state, enum xkb_state_component components);
	int xkb_state_mod_name_is_active(struct xkb_state *state, const char *name, enum xkb_state_component type);
	int xkb_state_mod_names_are_active(struct xkb_state *state, enum xkb_state_component type, enum xkb_state_match match, ...);
	int xkb_state_mod_index_is_active(struct xkb_state *state, xkb_mod_index_t idx, enum xkb_state_component type);
	int xkb_state_mod_indices_are_active(struct xkb_state *state, enum xkb_state_component type, enum xkb_state_match match, ...);
	enum xkb_consumed_mode {
		XKB_CONSUMED_MODE_XKB,
		XKB_CONSUMED_MODE_GTK
	};
	xkb_mod_mask_t xkb_state_key_get_consumed_mods2(struct xkb_state *state, xkb_keycode_t key, enum xkb_consumed_mode mode);
	xkb_mod_mask_t xkb_state_key_get_consumed_mods(struct xkb_state *state, xkb_keycode_t key);
	int xkb_state_mod_index_is_consumed2(struct xkb_state *state, xkb_keycode_t key, xkb_mod_index_t idx, enum xkb_consumed_mode mode);
	int xkb_state_mod_index_is_consumed(struct xkb_state *state, xkb_keycode_t key, xkb_mod_index_t idx);
	xkb_mod_mask_t xkb_state_mod_mask_remove_consumed(struct xkb_state *state, xkb_keycode_t key, xkb_mod_mask_t mask);
	int xkb_state_layout_name_is_active(struct xkb_state *state, const char *name, enum xkb_state_component type);
	int xkb_state_layout_index_is_active(struct xkb_state *state, xkb_layout_index_t idx, enum xkb_state_component type);
	int xkb_state_led_name_is_active(struct xkb_state *state, const char *name);
	int xkb_state_led_index_is_active(struct xkb_state *state, xkb_led_index_t idx);
]]

return ffi.load("xkbcommon")

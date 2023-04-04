local xlib = require("dep.xlib")
local ffi = require("ffi")
require("dep.xft")
local xft_supported, xft = pcall(require, "dep.xft")

local mod = {}

-- TODO: cleanup when closed

--[[@enum textbar_dock_side]]
mod.dock_side = { top = 0, bottom = 1 }

--[[@class textbar]]
local textbar = {}
textbar.__index = textbar

ffi.cdef [[int getpid(); int gethostname(char *name, size_t len);]]
local getpid = ffi.C.getpid
local gethostname
do
	local buf = ffi.new("char[256]")
	local c = ffi.os == "Windows" and ffi.load("Ws2_32") or ffi.C
	gethostname = function ()
		c.gethostname(buf, 256)
		return ffi.string(buf)
	end
end

-- TODO: consider foreground parameter

--[[@param display? xlib_display]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param background? integer 0xrrggbb]] --[[@param font? string]] --[[@param dock_side? textbar_dock_side]]
textbar.new = function (self, display, x, y, width, height, background, font, dock_side)
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	display = display or xlib.display:new() --[[@type xlib_display]]
	local screen = display.c[0].screens[display.c[0].default_screen]
	local window = display:create_simple_window(
		screen.root, x, y, width, height, 0, 0, 0
	)
	local gc = display:create_gc(window, 0, nil)
	display:copy_gc(screen.default_gc, bit.bnot(0ULL), gc)
	local background_pixel = display:alloc_color_x(screen.cmap, background or 0) or 0
	display:set_background(gc, background_pixel)
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	local atom = function (atom) return display:intern_atom(atom) end --[[@return xlib_atom_c]]
	do
		local class_hints = xlib.alloc_class_hint()
		class_hints.res_name = "textbar"
		class_hints.res_class = "textbar"
		display:set_class_hint(window, class_hints)
		xlib.free(class_hints)
		local hints = xlib.alloc_size_hints()
		hints[0].flags = bit.bor(xlib.size_flags.p_position, xlib.size_flags.p_size, xlib.size_flags.p_min_size, xlib.size_flags.p_max_size)
		hints[0].x = x
		hints[0].y = y
		hints[0].base_width = width
		hints[0].base_height = height
		hints[0].min_width = width
		hints[0].min_height = height
		hints[0].max_width = width
		hints[0].max_height = height
		display:set_wm_normal_hints(window, hints)
		xlib.free(hints)
		local text_prop = ffi.new("XTextProperty[1]") --[[@type ptr_c<xlib_text_property_c>]]
		text_prop[0].encoding = atom("STRING")
		text_prop[0].format = 8
		local s = "textbar"
		text_prop[0].value = s
		text_prop[0].nitems = #s
		display:set_wm_name(window, text_prop)
		s = gethostname()
		text_prop[0].encoding = atom("UTF8_STRING") --[[not guaranteed to be supported]]
		text_prop[0].value = s
		text_prop[0].nitems = #s
		display:set_wm_client_machine(window, text_prop)
	end
	display:change_property(
		window, atom("_NET_WM_WINDOW_TYPE"), atom("ATOM"), 32, xlib.property_mode.replace,
		ffi.cast("void *", ffi.new("Atom[1]", atom("_NET_WM_WINDOW_TYPE_DOCK"))), 1
	)
	display:change_property(
		window, atom("_NET_WM_STATE"), atom("ATOM"), 32, xlib.property_mode.replace,
		ffi.cast("void *", ffi.new("Atom[2]", atom("_NET_WM_STATE_ABOVE"), atom("_NET_WM_STATE_STICKY"))), 2
	)
	display:change_property(
		window, atom("_NET_WM_DESKTOP"), atom("CARDINAL"), 32, xlib.property_mode.replace,
		ffi.cast("void *", ffi.new("unsigned long[1]", 0xffffffff)), 1
	)
	display:change_property(
		window, atom("_NET_WM_PID"), atom("CARDINAL"), 32, xlib.property_mode.replace,
		ffi.cast("void *", ffi.new("unsigned long[1]", getpid())), 1
	)
	if dock_side then
		local top = dock_side == mod.dock_side.top
		display:change_property( -- TODO: make sure it's the right screen?
			window, atom("_NET_WM_STRUT"), atom("CARDINAL"), 32, xlib.property_mode.replace,
			ffi.cast("void *", ffi.new("unsigned long[4]", 0, 0, (top and height or 0), (top and 0 or height))), 4
		)
		display:change_property(
			window, atom("_NET_WM_STRUT_PARTIAL"), atom("CARDINAL"), 32, xlib.property_mode.replace,
			ffi.cast("void *", ffi.new("unsigned long[12]",
				0, 0, (top and height or 0), (top and 0 or height),
				0, 0, 0, 0, (top and x or 0), (top and x + width - 1 or 0), (top and 0 or x), (top and 0 or x + width - 1)
			)), 12
		)
	end
	display:map_window(window)
	local line_height = height
	local xft_
	local xfont
	font = font or "-*-fixed-*-*-*-*-*-*-*-*-*-*-*-*"
	if xft_supported then
		local font_ = xft.font_open_xlfd(display.c, display.c[0].default_screen, font) or
			xft.font_open_name(display.c, display.c[0].default_screen, font) or
			error("textbar: cannot load font " .. font) or {}
		xft_ = { --[[@class textbar_xft]]
			color = nil, --[[@type ptr_c<xft_color_c>]]
			font = font_,
			draw = xft.draw_create(display.c, window, screen.root_visual, screen.cmap),
			y_offset = bit.rshift(line_height + xft.text_extents_utf8(display.c, font_, "X").y, 1),
		}
	else
		local font_set = display:create_font_set({ "-*-fixed-*-*-*-*-*-*-*-*-*-*-*-*" }).font_set or
			error("textbar: cannot load font " .. font) or {}
		local ascent = 0
		local descent = 0
		local fonts = xlib.fonts_of_font_set(font_set)
		for i = 0, fonts.nfonts - 1 do
			local font_struct = fonts.font_structs[0][i][0]
			ascent = math.max(ascent, font_struct.ascent)
			descent = math.max(descent, font_struct.descent)
		end
		xfont = { --[[@class textbar_xfont]]
			set = font_set,
			font = nil,
			--[[@diagnostic disable-next-line: param-type-mismatch]]
			y_offset = bit.rshift(line_height + ascent, 1),
		}
	end
	return setmetatable({ --[[@class textbar]]
		-- TODO: make line height configurable
		display = display,
		window = window,
		--[[TODO: it might need to be on the other screen]]
		screen = screen,
		gc = gc,
		xfont = xfont,
		xft_ = xft_,
		x = x, y = y, width = width, height = height,
		cx = 0, cy = 0,
		background_pixel = background_pixel,
		--[[WARN: may cause leak if you keep loading xbms]]
		xbm_cache = {}, --[[@type table<string, { bitmap: xlib_pixmap_c; width: integer; height: integer; x_hot: integer; y_hot: integer; }>]]
		color_cache = { [background] = background_pixel }, --[[@type table<integer, integer>]]
	}, self)
end
--[[@param display xlib_display]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param background? integer 0xrrggbb]] --[[@param font? string]] --[[@param dock_side? textbar_dock_side]]
mod.new = function (display, x, y, width, height, background, font, dock_side)
	return textbar:new(display, x, y, width, height, background, font, dock_side)
end

local xft_set_color
if xft_supported then
	xft_set_color = function (t, rgb) --[[@param t textbar]] --[[@param rgb integer]]
		t.xft_.color = xft.color_alloc_value(
			t.display.c, t.screen.root_visual, t.screen.cmap, ffi.new("XRenderColor[1]", { {
				red = bit.band(bit.rshift(rgb, 8), 0xff00),
				green = bit.band(rgb, 0xff00),
				blue = bit.band(bit.lshift(rgb, 8), 0xff00),
				alpha = 0xffff,
			} }))
	end
else
	xft_set_color = function () end
end

--[[@param rgb integer 0xrrggbb]]
textbar.set_color = function (self, rgb)
	local color = self.color_cache[rgb]
	if not color then
		color = self.display:alloc_color_x(self.screen.cmap, rgb) or 0
		self.color_cache[rgb] = color
	end
	self.display:set_foreground(self.gc, color)
	xft_set_color(self, rgb)
end

-- TODO: set_font

textbar.clear = function (self)
	self.cx = 0
	self.display:set_foreground(self.gc, self.background_pixel)
	self.display:fill_rectangle(self.window, self.gc, 0, 0, self.width, self.height)
	self.display:set_foreground(self.gc, self.screen.black_pixel)
end

textbar.flush = function (self) self.display:flush() end

local draw_string
local text_width
if xft_supported then
	draw_string = function (t, s) --[[@param t textbar]] --[[@param s string]]
		xft.draw_string_utf8(t.xft_.draw, t.xft_.color, t.xft_.font, t.cx, t.cy + t.xft_.y_offset, s)
	end
	text_width = function (t, s) --[[@param t textbar]] --[[@param s string]]
		return xft.text_extents_utf8(t.display.c, t.xft_.font, s).width
	end
else
	draw_string = function (t, s) --[[@param t textbar]] --[[@param s string]]
		t.display:draw_string(t.window, t.gc, t.cx, t.cy + t.xfont.y_offset, s)
	end
	text_width = function (t, s) --[[@param t textbar]] --[[@param s string]]
		return xlib.mb_text_extents(t.xfont.set, s).logical.width
	end
end

--[[@param text string]]
textbar.write = function (self, text)
	draw_string(self, text)
	self.cx = self.cx + text_width(self, text)
end

textbar.read_xbm = function (self, path)
	local ret = self.xbm_cache[path]
	if ret then return ret end
	--[[@diagnostic disable-next-line: cast-local-type]]
	ret = self.display:read_bitmap_file(self.window, path)
	self.xbm_cache[path] = ret
	return ret -- FIXME: should not be unknown
end

--[[@param image { bitmap: xlib_pixmap_c; width: integer; height: integer; x_hot: integer; y_hot: integer; }]]
textbar.draw = function (self, image)
	self.display:copy_plane(
		image.bitmap, self.window, self.gc, 0, 0, image.width, image.height, self.cx, bit.rshift(self.height - image.height, 1), 1
	)
	self.cx = self.cx + image.width
end

return mod

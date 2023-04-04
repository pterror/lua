local ffi = require("ffi")

local mod = {}

--[[@type xft_ffi]]
local xft_ffi = ffi.load("Xft")

ffi.cdef [[
	// redeclaration in case x11 isn't loaded beforehand
	typedef bool Bool;
	typedef struct _Display Display;
	typedef struct _Visual Visual;
	typedef uint64_t Drawable;
	typedef uint64_t Colormap;
	typedef struct _FcCharSet FcCharSet;
	typedef struct _FcPattern FcPattern;
	typedef struct _FcResult FcResult;
	// all unconfirmed
	typedef uint64_t Picture;
	typedef int FcEndian; // enum
	typedef uint8_t FcChar8;
	typedef uint16_t FcChar16;
	typedef uint32_t FcChar32;
	typedef unsigned int FT_UInt;

	typedef struct _XftFont {
		int ascent;
		int descent;
		int height;
		int max_advance_width;
		FcCharSet *charset;
		FcPattern *pattern;
	} XftFont;

	typedef struct _XftFontInfo XftFontInfo;

	typedef struct {
		unsigned short red;
		unsigned short green;
		unsigned short blue;
		unsigned short alpha;
	} XRenderColor;

	typedef struct _XGlyphInfo {
		unsigned short  width;
		unsigned short  height;
		short	    x;
		short	    y;
		short	    xOff;
		short	    yOff;
	} XGlyphInfo;

	typedef struct _XftColor {
		unsigned long pixel;
		XRenderColor color;
	} XftColor;

	typedef struct _XftDraw XftDraw;

	typedef struct _XftCharSpec {
		FcChar32 ucs4;
		short x;
		short y;
	} XftCharSpec;

	typedef struct _XftCharFontSpec {
		XftFont *font;
		FcChar32 ucs4;
		short x;
		short y;
	} XftCharFontSpec;

	typedef struct _XftGlyphSpec {
		FT_UInt glyph;
		short x;
		short y;
	} XftGlyphSpec;

	typedef struct _XftGlyphFontSpec {
		XftFont *font;
		FT_UInt glyph;
		short x;
		short y;
	} XftGlyphFontSpec;

	XftFont *XftFontOpen(Display *dpy, int screen, ...);
	XftFont *XftFontOpenName(Display *dpy, int screen, const unsigned char *name);
	XftFont *XftFontOpenXlfd(Display *dpy, int screen, const unsigned char *xlfd);
	FcPattern *XftFontMatch(Display *dpy, int screen, FcPattern *pattern, FcResult *result);
	void XftTextExtents8(Display *dpy, XftFont *font, const FcChar8 *string, int len, XGlyphInfo *extents);
	void XftTextExtents16(Display *dpy, XftFont *font, const FcChar16 *string, int len, XGlyphInfo *extents);
	void XftTextExtents32(Display *dpy, XftFont *font, const FcChar32 *string, int len, XGlyphInfo *extents);
	void XftTextExtentsUtf8(Display *dpy, XftFont *font, const FcChar8 *string, int len, XGlyphInfo *extents);
	void XftTextExtentsUtf16(Display *dpy, XftFont *font, const FcChar8 *string, FcEndian endian, int len, XGlyphInfo *extents);
	void XftGlyphExtents(Display *dpy, XftFont *font, const FT_UInt *glyphs, int nglyphs, XGlyphInfo *extents);
	XftDraw *XftDrawCreate(Display *dpy, Drawable drawable, Visual *visual, Colormap colormap);
	XftDraw *XftDrawCreateBitmap(Display *dpy, Pixmap bitmap);
	XftDraw *XftDrawCreateAlpha(Display *dpy, Pixmap pixmap, int depth);
	void XftDrawChange(XftDraw *draw, Drawable drawable);
	Display *XftDrawDisplay(XftDraw *draw);
	Drawable XftDrawDrawable(XftDraw *draw);
	Colormap XftDrawColormap(XftDraw *draw);
	Visual *XftDrawVisual(XftDraw *draw);
	Picture XftDrawPicture(XftDraw *draw);
	Picture XftDrawSrcPicture(XftDraw *draw, XftColor *color);
	void XftDrawDestroy(XftDraw *draw);
	void XftDrawString8(XftDraw *d, XftColor *color, XftFont *font, int x, int y, const FcChar8 *string, int len);
	void XftDrawString16(XftDraw *d, XftColor *color, XftFont *font, int x, int y, const FcChar16 *string, int len);
	void XftDrawString32(XftDraw *d, XftColor *color, XftFont *font, int x, int y, const FcChar32 *string, int len);
	void XftDrawStringUtf8(XftDraw *d, XftColor *color, XftFont *font, int x, int y, const FcChar8 *string, int len);
	void XftDrawStringUtf16(XftDraw *d, XftColor *color, XftFont *font, int x, int y, const FcChar8 *string, int len);
	void XftDrawRect(XftDraw *d, XftColor *color, int x, int y, unsigned int width, unsigned int height);
	Bool XftColorAllocName(Display *dpy, const Visual *visual, Colormap cmap, const char *name, XftColor *result);
	Bool XftColorAllocValue(Display *dpy, Visual *visual, Colormap cmap, const XRenderColor *color, XftColor *result);
	void XftColorFree (Display *dpy, Visual *visual, Colormap cmap, XftColor *color);
]]

--[[redeclarations]]

--[[@class xlib_screen_c]]
--[[@class xlib_display_c]]
--[[@class xlib_drawable_c]]
--[[@class xlib_pixmap_c]]
--[[@class xlib_colormap_c]]
--[[@class xlib_visual_c]]
--[[@class xrender_color_c]]
--[[@class xrender_picture_c]]
--[[@class fc_char_set_c]]
--[[@class fc_pattern_c]]
--[[@class fc_result_c]]
--[[@class fc_endian_c]]
--[[@class fc_char_c: integer]]
--[[@class fc_char8_c: integer]]
--[[@class fc_char16_c: integer]]
--[[@class fc_char32_c: integer]]
--[[@class fc_char64_c: integer]]
--[[@class ft_uint_c: integer]]

--[[@class xrender_glyph_info_c]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field xOff integer]]
--[[@field yOff integer]]

--[[@class xft_font_c]]
--[[@field ascent integer]]
--[[@field descent integer]]
--[[@field height integer]]
--[[@field max_advance_width integer]]
--[[@field charset ptr_c<fc_char_set_c>]]
--[[@field pattern ptr_c<fc_pattern_c>]]

--[[@class xft_font_info_c]]

--[[@class xft_color_c]]
--[[@field pixel integer]]
--[[@field color xrender_color_c]]

--[[@class xft_draw_c]]

--[[@class xft_char_spec_c]]
--[[@field ucs4 fc_char32_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xft_char_font_spec_c]]
--[[@field font xft_font_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xft_glyph_spec_c]]
--[[@field glyph ft_uint_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xft_glyph_font_spec_c]]
--[[@field font xft_font_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xft_ffi]]
--[[@field XftFontOpen fun(dpy: ptr_c<xlib_display_c>, screen: integer, ...): ptr_c<xft_font_c>]]
--[[@field XftFontOpenName fun(dpy: ptr_c<xlib_display_c>, screen: integer, name: string): ptr_c<xft_font_c>]]
--[[@field XftFontOpenXlfd fun(dpy: ptr_c<xlib_display_c>, screen: integer, xlfd: string): ptr_c<xft_font_c>]]
--[[@field XftFontMatch fun(dpy: ptr_c<xlib_display_c>, screen: integer, pattern: ptr_c<fc_pattern_c>, result: ptr_c<fc_result_c>): ptr_c<fc_pattern_c>]]
--[[@field XftTextExtents8 fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, string: string, len: integer, extents: xrender_glyph_info_c)]]
--[[@field XftTextExtents16 fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, string: ptr_c<fc_char16_c>, len: integer, extents: xrender_glyph_info_c)]]
--[[@field XftTextExtents32 fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, string: ptr_c<fc_char32_c>, len: integer, extents: xrender_glyph_info_c)]]
--[[@field XftTextExtentsUtf8 fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, string: string, len: integer, extents: xrender_glyph_info_c)]]
--[[@field XftTextExtentsUtf16 fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, string: string, endian: fc_endian_c, len: integer, extents: xrender_glyph_info_c)]]
--[[@field XftGlyphExtents fun(dpy: ptr_c<xlib_display_c>, font: ptr_c<xft_font_c>, glyphs: ptr_c<ft_uint_c>, nglyphs: integer, extents: xrender_glyph_info_c)]]
--[[@field XftDrawCreate fun(dpy: ptr_c<xlib_display_c>, drawable: xlib_drawable_c, visual: ptr_c<xlib_visual_c>, colormap: xlib_colormap_c): ptr_c<xft_draw_c>]]
--[[@field XftDrawCreateBitmap fun(dpy: ptr_c<xlib_display_c>, bitmap: xlib_pixmap_c): ptr_c<xft_draw_c>]]
--[[@field XftDrawCreateAlpha fun(dpy: ptr_c<xlib_display_c>, pixmap: xlib_pixmap_c, depth: integer): ptr_c<xft_draw_c>]]
--[[@field XftDrawChange fun(draw: ptr_c<xft_draw_c>, drawable: xlib_drawable_c)]]
--[[@field XftDrawDisplay fun(draw: ptr_c<xft_draw_c>): ptr_c<xlib_display_c>]]
--[[@field XftDrawDrawable fun(draw: ptr_c<xft_draw_c>): ptr_c<xlib_drawable_c>]]
--[[@field XftDrawColormap fun(draw: ptr_c<xft_draw_c>): ptr_c<xlib_colormap_c>]]
--[[@field XftDrawVisual fun(draw: ptr_c<xft_draw_c>): ptr_c<xlib_visual_c>]]
--[[@field XftDrawPicture fun(draw: ptr_c<xft_draw_c>): ptr_c<xrender_picture_c>]]
--[[@field XftDrawSrcPicture fun(draw: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>): ptr_c<xrender_picture_c>]]
--[[@field XftDrawDestroy fun(draw: ptr_c<xft_draw_c>)]]
--[[@field XftDrawString8 fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, font: ptr_c<xft_font_c>, x: integer, y: integer, string: string, len: integer)]]
--[[@field XftDrawString16 fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, font: ptr_c<xft_font_c>, x: integer, y: integer, string: ptr_c<fc_char16_c>, len: integer)]]
--[[@field XftDrawString32 fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, font: ptr_c<xft_font_c>, x: integer, y: integer, string: ptr_c<fc_char32_c>, len: integer)]]
--[[@field XftDrawStringUtf8 fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, font: ptr_c<xft_font_c>, x: integer, y: integer, string: string, len: integer)]]
--[[@field XftDrawStringUtf16 fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, font: ptr_c<xft_font_c>, x: integer, y: integer, string: string, len: integer)]]
--[[@field XftDrawRect fun(d: ptr_c<xft_draw_c>, color: ptr_c<xft_color_c>, x: integer, y: integer, width: integer, height: integer)]]
--[[@field XftColorAllocName fun(dpy: ptr_c<xlib_display_c>, visual: ptr_c<xlib_visual_c>, cmap: xlib_colormap_c, name: string, result: ptr_c<xft_color_c>)]]
--[[@field XftColorAllocValue fun(dpy: ptr_c<xlib_display_c>, visual: ptr_c<xlib_visual_c>, cmap: xlib_colormap_c, color: ptr_c<xrender_color_c>, result: ptr_c<xft_color_c>)]]
--[[@field XftColorFree fun(dpy: ptr_c<xlib_display_c>, visual: ptr_c<xlib_visual_c>, cmap: xlib_colormap_c, color: ptr_c<xft_color_c>)]]

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param screen integer]] --[[@param ... unknown]]
mod.font_open = function (dpy, screen, ...)
	local ret = xft_ffi.XftFontOpen(dpy, screen, ...)
	return ret ~= nil and ret or nil
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param screen integer]] --[[@param name string]]
mod.font_open_name = function (dpy, screen, name)
	local ret = xft_ffi.XftFontOpenName(dpy, screen, name)
	return ret ~= nil and ret or nil
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param screen integer]] --[[@param xlfd string]]
mod.font_open_xlfd = function (dpy, screen, xlfd)
	local ret = xft_ffi.XftFontOpenXlfd(dpy, screen, xlfd)
	return ret ~= nil and ret or nil
end

--[[@return ptr_c<fc_pattern_c>]] --[[@param dpy ptr_c<xlib_display_c>]] --[[@param screen integer]] --[[@param pattern ptr_c<fc_pattern_c>]] --[[@param result ptr_c<fc_result_c>]]
mod.font_match = function (dpy, screen, pattern, result)
	return xft_ffi.XftFontMatch(dpy, screen, pattern, result)
end

local extents = ffi.new("XGlyphInfo[1]") --[[@type ptr_c<xrender_glyph_info_c>]]

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param string string]]
mod.text_extents8 = function (dpy, font, string)
	xft_ffi.XftTextExtents8(dpy, font, string, #string, extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param string ptr_c<fc_char16_c>]]
mod.text_extents16 = function (dpy, font, string)
	xft_ffi.XftTextExtents16(dpy, font, ffi.cast("const FcChar16 *", string), bit.rshift(#string, 1), extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param string ptr_c<fc_char32_c>]]
mod.text_extents32 = function (dpy, font, string)
	xft_ffi.XftTextExtents32(dpy, font, ffi.cast("const FcChar32 *", string), bit.rshift(#string, 2), extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param string string]]
mod.text_extents_utf8 = function (dpy, font, string)
	xft_ffi.XftTextExtentsUtf8(dpy, font, string, #string, extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param string string]] --[[@param endian fc_endian_c]]
mod.text_extents_utf16 = function (dpy, font, string, endian)
	xft_ffi.XftTextExtentsUtf16(dpy, font, string, endian, #string, extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param glyphs ptr_c<ft_uint_c>]] --[[@param nglyphs integer]]
mod.glyph_extents = function (dpy, font, glyphs, nglyphs)
	xft_ffi.XftGlyphExtents(dpy, font, glyphs, nglyphs, extents)
	return extents[0]
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param drawable xlib_drawable_c]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param colormap xlib_colormap_c]]
mod.draw_create = function (dpy, drawable, visual, colormap)
	return xft_ffi.XftDrawCreate(dpy, drawable, visual, colormap)
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param bitmap xlib_pixmap_c]]
mod.draw_create_bitmap = function (dpy, bitmap) return xft_ffi.XftDrawCreateBitmap(dpy, bitmap)[0] end
--[[@param dpy ptr_c<xlib_display_c>]] --[[@param pixmap xlib_pixmap_c]] --[[@param depth integer]]
mod.draw_create_alpha = function (dpy, pixmap, depth) return xft_ffi.XftDrawCreateAlpha(dpy, pixmap, depth)[0] end
--[[@param draw ptr_c<xft_draw_c>]] --[[@param drawable xlib_drawable_c]]
mod.draw_change = function (draw, drawable) return xft_ffi.XftDrawChange(draw, drawable) end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_display = function (draw) return xft_ffi.XftDrawDisplay(draw)[0] end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_drawable = function (draw) return xft_ffi.XftDrawDrawable(draw) end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_colormap = function (draw) return xft_ffi.XftDrawColormap(draw) end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_visual = function (draw) return xft_ffi.XftDrawVisual(draw)[0] end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_picture = function (draw) return xft_ffi.XftDrawPicture(draw) end
--[[@param draw ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]]
mod.draw_src_picture = function (draw, color) return xft_ffi.XftDrawSrcPicture(draw, color) end
--[[@param draw ptr_c<xft_draw_c>]]
mod.draw_destroy = function (draw) return xft_ffi.XftDrawDestroy(draw) end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string8 = function (d, color, font, x, y, string)
	return xft_ffi.XftDrawString8(d, color, font, x, y, string, #string)
end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string16 = function (d, color, font, x, y, string)
	return xft_ffi.XftDrawString16(d, color, font, x, y, ffi.cast("const FcChar16 *", string), bit.rshift(#string, 1))
end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string32 = function (d, color, font, x, y, string)
	return xft_ffi.XftDrawString32(d, color, font, x, y, ffi.cast("const FcChar32 *", string), bit.rshift(#string, 2))
end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string_utf8 = function (d, color, font, x, y, string)
	return xft_ffi.XftDrawStringUtf8(d, color, font, x, y, string, #string)
end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param font ptr_c<xft_font_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string_utf16 = function (d, color, font, x, y, string)
	return xft_ffi.XftDrawStringUtf16(d, color, font, x, y, string, #string)
end

--[[@param d ptr_c<xft_draw_c>]] --[[@param color ptr_c<xft_color_c>]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]]
mod.draw_rect = function (d, color, x, y, width, height)
	return xft_ffi.XftDrawRect(d, color, x, y, width, height)
end

local result = ffi.new("XftColor[1]") --[[@type ptr_c<xft_color_c>]]

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param cmap xlib_colormap_c]] --[[@param name string]]
mod.color_alloc_name = function (dpy, visual, cmap, name)
	xft_ffi.XftColorAllocName(dpy, visual, cmap, name, result)
	return result
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param cmap xlib_colormap_c]] --[[@param color ptr_c<xrender_color_c>]]
mod.color_alloc_value = function (dpy, visual, cmap, color)
	xft_ffi.XftColorAllocValue(dpy, visual, cmap, color, result)
	return result
end

--[[@param dpy ptr_c<xlib_display_c>]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param cmap xlib_colormap_c]] --[[@param color ptr_c<xft_color_c>]]
mod.color_free = function (dpy, visual, cmap, color)
	xft_ffi.XftColorFree(dpy, visual, cmap, color)
end

return mod

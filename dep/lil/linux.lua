local ffi = require("ffi")
-- TODO: gtk
-- not being considered: fullscreen, application id, menus, events, resources

-- figure out how sizing should work
-- should everything be placed exactly?
-- nothing?
-- should a mix be allowed?

local mod = {}

-- TODO: decide on api
-- create window?
-- position window?

ffi.cdef [[
	typedef void GtkWidget;
	typedef void GtkWindow;

	GtkWidget* gtk_window_new(void);
	void gtk_window_destroy(GtkWindow* window);

	void gtk_window_set_default_size(GtkWindow* window, int width, int height);
]]

--- @class gtk_widget_c
--- @class gtk_window_c: gtk_widget_c
--- @class gtk_c
--- @field gtk_window_new fun(): gtk_window_c
--- @field gtk_window_destroy fun(window: gtk_window_c)
--- @field gtk_window_set_default_size fun(window: gtk_window_c, width: integer, height: integer)

--- @type gtk_c
local gtk_c = ffi.load("gtk-4")

--- @class lil_linux_window
local Window = {}
mod.Window = Window
Window.__index = Window

function Window:new()
	--- @type gtk_window_c
	--- @diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
	local window_c = ffi.gc(gtk_c.gtk_window_new(), function (self_)
		gtk_c.gtk_window_destroy(self_.c)
	end)
	return setmetatable({ --- @class lil_linux_window
		c = window_c
	}, self)
end

function Window:delete()
	gtk_c.gtk_window_destroy(self.c)
end

--- @param width integer
--- @param height integer
function Window:resize(width, height)
	gtk_c.gtk_window_set_default_size(self.c, width, height)
end

-- TODO: refactor out
--- @class lil_interface

--- @param old lil_interface
--- @param new lil_interface
function Window:replace(old, new)
	-- 
end

return mod

local ffi = require("ffi")

local debug = os.getenv("DEBUG") == "1"

local mod = {}

local webview = {}
webview.__index = webview
mod.webview = webview

webview.new = function (self)
	local ret = setmetatable({}, self)
	ret:init()
	return ret
end

if jit.os == "Linux" then
	--[[https://github.com/javalikescript/webview-c/blob/master/webview-gtk.c]]
	--[[@class gtk_ffi]]
	--[[@field gtk_window_new fun(type: gtk_window_type): ptr_c<gtk_widget_c>]]
	--[[@class webkit2gtk_ffi]]
	--[[@field gtk_init_check fun(a: 0|1, b: nil): 0|1]]

	ffi.cdef [[
		typedef int gint
		typedef gint gboolean

		gboolean gtk_init_check(void)
	]]

	--[[@enum gtk_window_type]]
	local gtk_window_type = { toplevel = 0, popup = 1 }
	--[[@enum gtk_window_position]]
	local gtk_window_position = { none = 0, center = 1, mouse = 2, center_always = 3, center_on_parent = 4 }
	--[[@type gtk_ffi]]
	local gtk_ffi = ffi.load("gtk-3")
	--[[@type webkit2gtk_ffi]]
	local webkit2gtk_ffi = ffi.load("webkit2gtk-4.1")
	webview.init = function (self)
		--[[if not debug]]
		--[[g_log_set_handler("GLib", bit.bor(G_LOG_LEVEL_MASK, G_LOG_FLAG_FATAL, G_LOG_FLAG_RECURSION), noLogHandler, nil)]]
		if webkit2gtk_ffi.gtk_init_check(0, nil) == 0 then return nil, "webview/init: gtk_init_check failed" end
		local win = gtk_ffi.gtk_window_new(gtk_window_type.toplevel)
		gtk_window_set_title(win, self.title)
		if self.resizable then gtk_window_set_default_size(GTK_WINDOW(win), self.width, self.height)
		else gtk_widget_set_size_request(win, self.width, self.height) end
		gtk_window_set_resizable(GTK_WINDOW(win), self.resizable)
		gtk_window_set_position(GTK_WINDOW(win), gtk_window_position.none)
		local scroller = gtk_scrolled_window_new(nil, nil)
		gtk_container_add(GTK_CONTAINER(win), scroller)
		local m = webkit_user_content_manager_new()
		webkit_user_content_manager_register_script_message_handler(m, "external")
		g_signal_connect(m, "script-message-received::external", G_CALLBACK(external_message_received_cb), self)
		local webview = webkit_web_view_new_with_user_content_manager(m)
		--[[work around core dump?]]
		if not os.getenv("WEBVIEW_GTK_NO_SPURIOUS_REF") then g_object_ref(webview) end
		webkit_web_view_load_uri(WEBKIT_WEB_VIEW(webview), webview_check_url(self.url))
		g_signal_connect(G_OBJECT(webview), "load-changed", G_CALLBACK(webview_load_changed_cb), self)
		gtk_container_add(GTK_CONTAINER(scroller), webview)
		if debug then
			local settings = webkit_web_view_get_settings(WEBKIT_WEB_VIEW(webview))
			webkit_settings_set_enable_write_console_messages_to_stdout(settings, true)
			webkit_settings_set_enable_developer_extras(settings, true)
		else g_signal_connect(G_OBJECT(webview), "context-menu", G_CALLBACK(webview_context_menu_cb), self) end
		gtk_widget_show_all(win)
		--[[FIXME: webkit_web_view_run_javascript(WEBKIT_WEB_VIEW(webview), REGISTER_EXTERNAL_INVOKE_JS, nil, nil, nil)]]
		g_signal_connect(G_OBJECT(win), "destroy", G_CALLBACK(webview_destroy_cb), self)
	end
end

return mod

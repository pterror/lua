---@diagnostic disable: need-check-nil
-- ------------------------------------------------------------------------------------------------------------------ --
--                       lovr-ui2d: An immediate mode 2D GUI library for LOVR (https://lovr.org)                      --
--                                   Github: https://github.com/immortalx74/lovr-ui2d                                 --
-- ------------------------------------------------------------------------------------------------------------------ --

-- ------------------------------------------ Credits and acknowledgements ------------------------------------------ --
-- Bjorn Swenson (bjornbytes) - https://github.com/bjornbytes                                                         --
-- For creating the awesome LOVR framework, providing help and answering every single question!                       --
--                                                                                                                    --
-- Casey Muratori - https://caseymuratori.com/                                                                        --
-- For developing the immediate mode technique, coining the term, and creating the HandMade community.                --
--                                                                                                                    --
-- Omar Cornut - https://github.com/ocornut                                                                           --
-- For popularizing the concept with the outstanding Dear ImGui library.                                              --
--                                                                                                                    --
-- rxi - https://github.com/rxi                                                                                       --
-- For creating microui. The most tiny UI library from which lovr-ui was inspired from.                               --
-- ------------------------------------------------------------------------------------------------------------------ --

local utf8 = require("utf8")

local ui2d = {}
local framework = {}

--[[@class lovrui2d_color]]
--[[@field [1] integer red]]
--[[@field [2] integer green]]
--[[@field [3] integer blue]]

local has_text_input = false
local has_mouse = false
--[[@enum lovrui2d_mouse_state]]
local e_mouse_state = { clicked = 1, held = 2, released = 3, idle = 4 }
--[[@enum lovrui2d_slider_type]]
local e_slider_type = { int = 1, float = 2 }
local modal_window = nil
local active_window = nil
local active_widget = nil
local active_textbox = nil --[[@type table?]]
local dragged_window = nil
local repeating_key = nil
local text_input_character = nil
local begin_idx = nil
local margin = 8
local next_z = 0
local separator_thickness = 2
local begin_end_pairs = { b = 0, e = 0 }
local windows = {}
local color_themes = {}
local overriden_colors = {}
local listbox_state = {}
local caret_blink = { prev = 0, on = false }
local font = { handle = nil, w = nil, h = nil }
local dragged_window_offset = { x = 0, y = 0 }
local mouse = { x = 0, y = 0, state = e_mouse_state.idle, prev_frame = 0, this_frame = 0, wheel_x = 0, wheel_y = 0 }
local layout = { x = 0, y = 0, w = 0, h = 0, row_h = 0, total_w = 0, total_h = 0, same_line = false, same_column = false }
local texture_flags = { mipmaps = true, usage = { "sample", "render", "transfer" } }
local clamp_sampler
local active_tooltip = { text = "", x = 0, y = 0 }

local keys = {
	["right"] = { 0, 0, 0 },
	["left"] = { 0, 0, 0 },
	["backspace"] = { 0, 0, 0 },
	["delete"] = { 0, 0, 0 },
	["tab"] = { 0, 0, 0 },
	["return"] = { 0, 0, 0 },
	["kpenter"] = { 0, 0, 0 }
}

color_themes.dark =
{
	text = { 0.8, 0.8, 0.8 },
	tooltip_bg = { 0, 0, 0 },
	tooltip_border = { 0.3, 0.3, 0.3 },
	window_bg = { 0.26, 0.26, 0.26 },
	window_border = { 0, 0, 0 },
	window_titlebar = { 0.08, 0.08, 0.08 },
	window_titlebar_active = { 0, 0, 0 },
	button_bg = { 0.14, 0.14, 0.14 },
	button_bg_hover = { 0.19, 0.19, 0.19 },
	button_bg_click = { 0.12, 0.12, 0.12 },
	button_border = { 0, 0, 0 },
	check_border = { 0, 0, 0 },
	check_border_hover = { 0.5, 0.5, 0.5 },
	check_mark = { 0.3, 0.3, 1 },
	toggle_border = { 0, 0, 0 },
	toggle_border_hover = { 0.5, 0.5, 0.5 },
	toggle_handle = { 0.8, 0.8, 0.8 },
	toggle_bg_off = { 0.3, 0.3, 0.3 },
	toggle_bg_on = { 0.3, 0.3, 1 },
	radio_border = { 0, 0, 0 },
	radio_border_hover = { 0.5, 0.5, 0.5 },
	radio_mark = { 0.3, 0.3, 1 },
	slider_bg = { 0.3, 0.3, 1 },
	slider_bg_hover = { 0.38, 0.38, 1 },
	slider_thumb = { 0.2, 0.2, 1 },
	list_bg = { 0.14, 0.14, 0.14 },
	list_border = { 0, 0, 0 },
	list_selected = { 0.3, 0.3, 1 },
	list_highlight = { 0.3, 0.3, 0.3 },
	list_track = { 0.08, 0.08, 0.08 },
	list_thumb = { 0.36, 0.36, 0.36 },
	list_thumb_hover = { 0.42, 0.42, 0.42 },
	list_thumb_click = { 0.24, 0.24, 0.24 },
	list_button = { 0.8, 0.8, 0.8 },
	list_button_hover = { 1, 1, 1 },
	list_button_click = { 0.5, 0.5, 0.5 },
	textbox_bg = { 0.03, 0.03, 0.03 },
	textbox_bg_hover = { 0.11, 0.11, 0.11 },
	textbox_border = { 0.1, 0.1, 0.1 },
	textbox_border_focused = { 0.58, 0.58, 1 },
	image_button_border_highlight = { 0.5, 0.5, 0.5 },
	tab_bar_bg = { 0.1, 0.1, 0.1 },
	tab_bar_border = { 0, 0, 0 },
	tab_bar_hover = { 0.2, 0.2, 0.2 },
	tab_bar_highlight = { 0.3, 0.3, 1 },
	progress_bar_bg = { 0.2, 0.2, 0.2 },
	progress_bar_fill = { 0.3, 0.3, 1 },
	progress_bar_border = { 0, 0, 0 },
	modal_tint = { 0.3, 0.3, 0.3 },
	separator = { 0, 0, 0 }
}

color_themes.light =
{
	text = { 0.02, 0.02, 0.02 },
	tooltip_bg = { 1, 1, 1 },
	tooltip_border = { 0, 0, 0 },
	window_bg = { 0.930, 0.930, 0.930 },
	window_border = { 0.000, 0.000, 0.000 },
	window_titlebar = { 0.8, 0.8, 0.8 },
	window_titlebar_active = { 0.54, 0.54, 0.54 },
	button_bg = { 0.800, 0.800, 0.800 },
	button_bg_hover = { 0.900, 0.900, 0.900 },
	button_bg_click = { 0.120, 0.120, 0.120 },
	button_border = { 0.000, 0.000, 0.000 },
	check_border = { 0.000, 0.000, 0.000 },
	check_border_hover = { 0.760, 0.760, 0.760 },
	check_mark = { 0.000, 0.000, 0.000 },
	toggle_border = { 0, 0, 0 },
	toggle_border_hover = { 1, 1, 1 },
	toggle_handle = { 1, 1, 1 },
	toggle_bg_off = { 0.4, 0.4, 0.4 },
	toggle_bg_on = { 0.830, 0.830, 0.830 },
	radio_border = { 0.000, 0.000, 0.000 },
	radio_border_hover = { 0.760, 0.760, 0.760 },
	radio_mark = { 0.172, 0.172, 0.172 },
	slider_bg = { 0.830, 0.830, 0.830 },
	slider_bg_hover = { 0.870, 0.870, 0.870 },
	slider_thumb = { 0.700, 0.700, 0.700 },
	list_bg = { 0.9, 0.9, 0.9 },
	list_border = { 0.000, 0.000, 0.000 },
	list_selected = { 0.686, 0.687, 0.688 },
	list_highlight = { 0.808, 0.810, 0.811 },
	list_track = { 0.82, 0.82, 0.82 },
	list_thumb = { 0.65, 0.65, 0.65 },
	list_thumb_hover = { 0.72, 0.72, 0.72 },
	list_thumb_click = { 0.58, 0.58, 0.58 },
	list_button = { 0, 0, 0 },
	list_button_hover = { 0.3, 0.3, 0.3 },
	list_button_click = { 0.1, 0.1, 0.1 },
	textbox_bg = { 0.700, 0.700, 0.700 },
	textbox_bg_hover = { 0.570, 0.570, 0.570 },
	textbox_border = { 0.000, 0.000, 0.000 },
	textbox_border_focused = { 0.000, 0.000, 1.000 },
	image_button_border_highlight = { 0.500, 0.500, 0.500 },
	tab_bar_bg = { 1.000, 0.994, 0.999 },
	tab_bar_border = { 0.000, 0.000, 0.000 },
	tab_bar_hover = { 0.802, 0.797, 0.795 },
	tab_bar_highlight = { 0.151, 0.140, 1.000 },
	progress_bar_bg = { 1.000, 1.000, 1.000 },
	progress_bar_fill = { 0.830, 0.830, 1.000 },
	progress_bar_border = { 0.000, 0.000, 0.000 },
	modal_tint = { 0.15, 0.15, 0.15 },
	separator = { 0.5, 0.5, 0.5 }
}

local colors = color_themes.dark

-- -------------------------------------------------------------------------- --
--                             Framework                                      --
-- -------------------------------------------------------------------------- --

--[[@param key string]]
function framework.GetKeyDown(key)
	return lovr.system.isKeyDown(key)
end

function framework.NewSampler()
	--[[@diagnostic disable-next-line: missing-fields, assign-type-mismatch]]
	return lovr.graphics.newSampler({ wrap = "clamp" })
end

--[[@param lib_path string]]
--[[@param size? integer default=`14`]]
function framework.LoadFont(lib_path, size)
	return lovr.graphics.newFont(lib_path .. "DejaVuSansMono.ttf", size or 14, 4)
end

function framework.SetPixelDensity(handle)
	handle:setPixelDensity(1.0)
end

function framework.SetKeyRepeat()
	lovr.system.setKeyRepeat(true)
end

--[[@param btn number]]
function framework.IsMouseDown(btn)
	return lovr.system.isMouseDown(btn)
end

function framework.GetMousePosition()
	return lovr.system.getMousePosition()
end

function framework.GetWindowDimensions()
	return lovr.system.getWindowDimensions()
end

function framework.GetTime()
	return lovr.timer.getTime()
end

--[[@param w integer]]
--[[@param h integer]]
function framework.NewTexture(w, h)
	return lovr.graphics.newTexture(w, h, texture_flags)
end

--[[@param pass? lovr_pass]]
--[[@param tex? lovr_texture]]
function framework.SetCanvas(pass, tex)
	if not pass then return end
	pass:setCanvas(tex)
end

--[[@param tex lovr_texture]]
function framework.NewPass(tex)
	return lovr.graphics.newPass(tex)
end

--[[@param pass lovr_pass]]
function framework.SetFont(pass)
	pass:setFont(font.handle)
end

--[[@param pass lovr_pass]]
function framework.ResetPass(pass)
	pass:reset()
end

--[[@param win { pass: lovr_pass; }]]
function framework.ClearWindow(win)
	win.pass:setDepthTest()
	--[[@diagnostic disable-next-line: missing-parameter]]
	win.pass:setProjection(1, mat4():orthographic(win.pass:getDimensions()))
	win.pass:setColor(colors.window_bg)
	win.pass:fill()
end

--[[@param pass lovr_pass]]
--[[@param color lovrui2d_color]]
function framework.SetColor(pass, color)
	pass:setColor(color)
end

--[[@param pass lovr_pass]]
--[[@param x number should be integer]]
--[[@param y number should be integer]]
--[[@param w number should be integer]]
--[[@param h number should be integer]]
--[[@param type lovr_draw_style]]
function framework.DrawRect(pass, x, y, w, h, type)
	pass:plane(x, y, 0, w, h, 0, 0, 0, 0, type)
end

--[[@param pass lovr_pass]]
--[[@param x integer]]
--[[@param y integer]]
--[[@param radius number]]
--[[@param type lovr_draw_style]]
function framework.DrawCircle(pass, x, y, radius, type)
	pass:circle(x, y, 0, radius, 0, 0, 0, 0, type)
end

--[[@param pass lovr_pass]]
--[[@param x integer]]
--[[@param y integer]]
--[[@param radius number]]
--[[@param type lovr_draw_style]]
--[[@param angle1 number]]
--[[@param angle2 number]]
function framework.DrawCircleHalf(pass, x, y, radius, type, angle1, angle2)
	pass:circle(x, y, 0, radius, 0, 0, 0, 0, type, angle1, angle2)
end

--[[@param pass lovr_pass]]
--[[@param x1 integer]]
--[[@param y1 integer]]
--[[@param x2 integer]]
--[[@param y2 integer]]
function framework.DrawLine(pass, x1, y1, x2, y2)
	pass:line(x1, y1, 0, x2, y2, 0)
end

--[[@param pass lovr_pass]]
--[[@param text string]]
--[[@param x number should be integer]]
--[[@param y number should be integer]]
--[[@param w number should be integer]]
--[[@param h number should be integer]]
--[[@param text_w number should be integer]]
function framework.DrawText(pass, text, x, y, w, h, text_w)
	pass:text(text, x + (w / 2), y + (h / 2), 0)
end

--[[@param pass lovr_pass]]
--[[@param tex lovr_texture]]
--[[@param x integer]]
--[[@param y integer]]
--[[@param w integer]]
--[[@param h integer]]
--[[@param sampler lovr_sampler]]
function framework.DrawImage(pass, tex, x, y, w, h, sampler)
	pass:setMaterial(tex)
	pass:setSampler(sampler)
	pass:plane(x, y, 0, w, -h)
	pass:setMaterial()
	pass:setColor(1, 1, 1)
end

--[[@param pass lovr_pass]]
function framework.SetProjection(pass)
	--[[@diagnostic disable-next-line: missing-parameter]]
	pass:setProjection(1, mat4():orthographic(pass:getDimensions()))
end

function framework.ReleaseTexture()
	-- noop
end

--[[@param pass lovr_pass]]
--[[@param tex? lovr_texture]]
function framework.SetMaterial(pass, tex)
	if tex then
		pass:setMaterial(tex)
	else
		pass:setMaterial()
	end
end

-- -------------------------------------------------------------------------- --
--                             Internals                                      --
-- -------------------------------------------------------------------------- --
--[[@param n number]]
--[[@param n_min number]]
--[[@param n_max number]]
local function Clamp(n, n_min, n_max)
	if n < n_min then
		n = n_min
	elseif n > n_max then
		n = n_max
	end

	return n
end

--[[@param str string]]
local function GetLineCount(str)
	-- https://stackoverflow.com/questions/24690910/how-to-get-lines-count-in-string/70137660#70137660
	local lines = 1
	for i = 1, #str do
		local c = str:sub(i, i)
		if c == '\n' then lines = lines + 1 end
	end

	return lines
end

--[[@param id string]]
local function WindowExists(id)
	for i, v in ipairs(windows) do
		if v.id == id then
			return true, i
		end
	end
	return false, 0
end

--[[@param win table]]
--[[@param id string]]
local function WidgetExists(win, id)
	for i, v in ipairs(win.cw) do
		if v.id == id then
			return true, i
		end
	end
	return false, 0
end

--[[@param id string]]
local function ListBoxExists(id)
	for i, v in ipairs(listbox_state) do
		if v.id == id then
			return true, i
		end
	end
	return false, 0
end

--[[@param px number]]
--[[@param py number]]
--[[@param rx number]]
--[[@param ry number]]
--[[@param rw number]]
--[[@param rh number]]
local function PointInRect(px, py, rx, ry, rw, rh)
	return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

--[[@param from_min number]]
--[[@param from_max number]]
--[[@param to_min number]]
--[[@param to_max number]]
--[[@param v number]]
local function MapRange(from_min, from_max, to_min, to_max, v)
	return (v - from_min) * (to_max - to_min) / (from_max - from_min) + to_min
end

--[[@param name string]]
local function GetLabelPart(name)
	local i = string.find(name, "##")
	if i then
		return string.sub(name, 1, i - 1)
	end
	return name
end

--[[@param t string[] ]]
local function GetLongerStringLen(t)
	local len = 0
	for _, v in ipairs(t) do
		local cur = utf8.len(v)
		if cur > len then len = cur end
	end
	return len
end

local function ResetLayout()
	layout = { x = 0, y = 0, w = 0, h = 0, row_h = 0, total_w = 0, total_h = 0, same_line = false, same_column = false }
end

--[[@param bbox { x: integer; y: integer; h: integer; w:integer; }]]
local function UpdateLayout(bbox)
	-- Update row height
	if layout.same_line then
		if bbox.h > layout.row_h then
			layout.row_h = bbox.h
		end
	elseif layout.same_column then
		if bbox.h + layout.h + margin < layout.row_h then
			layout.row_h = layout.row_h - layout.h - margin
		else
			layout.row_h = bbox.h
		end
	else
		layout.row_h = bbox.h
	end

	-- Calculate current layout w/h
	if bbox.x + bbox.w + margin > layout.total_w then
		layout.total_w = bbox.x + bbox.w + margin
	end

	if bbox.y + layout.row_h + margin > layout.total_h then
		layout.total_h = bbox.y + layout.row_h + margin
	end

	-- Update layout x/y/w/h and same_line
	layout.x = bbox.x
	layout.y = bbox.y
	layout.w = bbox.w
	layout.h = bbox.h
	layout.same_line = false
	layout.same_column = false
end

--[[@param type lovrui2d_slider_type]]
--[[@param name string]]
--[[@param v number]]
--[[@param v_min number]]
--[[@param v_max number]]
--[[@param width? integer]]
--[[@param tooltip? string]]
--[[@param num_decimals? integer default=`2`]]
local function Slider(type, name, v, v_min, v_max, width, tooltip, num_decimals)
	local text = GetLabelPart(name)
	local cur_window = windows[begin_idx]
	local text_w = font.handle:getWidth(text)

	local slider_w = 10 * font.w
	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = slider_w + margin + text_w, h = (2 * margin) + font.h }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = slider_w + margin + text_w, h = (2 * margin) + font.h }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = slider_w + margin + text_w, h = (2 * margin) + font.h }
	end

	if width and width > bbox.w then
		bbox.w = width
		slider_w = width - margin - text_w
	end

	UpdateLayout(bbox)

	local col = colors.slider_bg
	local result = false

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, slider_w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col = colors.slider_bg_hover

			if mouse.state == e_mouse_state.clicked then
				active_widget = cur_window.id .. name
			end
		end
	end

	if mouse.state == e_mouse_state.held and active_widget == cur_window.id .. name and cur_window == active_window then
		v = MapRange(bbox.x + 2, bbox.x + slider_w - 2, v_min, v_max, mouse.x - cur_window.x)
		if type == e_slider_type.float then
			v = Clamp(v, v_min, v_max)
		else
			v = Clamp(math.ceil(v), v_min, v_max)
			if v == 0 then v = 0 end
		end
	end
	if mouse.state == e_mouse_state.released and active_widget == cur_window.id .. name then
		active_widget = nil
		result = true
	end

	local text_label_rect = { x = bbox.x + slider_w + margin, y = bbox.y, w = text_w, h = bbox.h }
	local text_value_rect = { x = bbox.x, y = bbox.y, w = slider_w, h = bbox.h }
	local slider_rect = { x = bbox.x, y = bbox.y + (bbox.h / 2) - (font.h / 2), w = slider_w, h = font.h }
	local thumb_pos = MapRange(v_min, v_max, bbox.x, bbox.x + slider_w - font.h, v)
	local thumb_rect = { x = thumb_pos, y = bbox.y + (bbox.h / 2) - (font.h / 2), w = font.h, h = font.h }

	local value
	if type == e_slider_type.float then
		num_decimals = num_decimals or 2
		local str_fmt = "%." .. num_decimals .. "f"
		value = string.format(str_fmt, v)
	else
		value = v
	end
	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = slider_rect, color = col })
	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = thumb_rect, color = colors.slider_thumb })
	table.insert(windows[begin_idx].command_list,
		{ type = "text", text = text, bbox = text_label_rect, color = colors.text })
	table.insert(windows[begin_idx].command_list,
		{ type = "text", text = value, bbox = text_value_rect, color = colors.text })
	return v, result
end

--[[@param s string]]
--[[@param i number should be integer]]
--[[@param j number should be integer]]
function utf8.sub(s, i, j)
	i = utf8.offset(s, i) or 1
	local nextOffset = utf8.offset(s, j + 1)
	j = (nextOffset and nextOffset - 1) or #tostring(s)
	return string.sub(s, i, j)
end

-- -------------------------------------------------------------------------- --
--                                User                                        --
-- -------------------------------------------------------------------------- --
--[[@param key string]]
--[[@param repeating boolean]]
function ui2d.KeyPressed(key, repeating)
	if repeating then
		if key == "right" then
			repeating_key = "right"
		elseif key == "left" then
			repeating_key = "left"
		elseif key == "backspace" then
			repeating_key = "backspace"
		elseif key == "delete" then
			repeating_key = "delete"
		end
	end
end

--[[@param text string]]
function ui2d.TextInput(text)
	text_input_character = text
end

function ui2d.KeyReleased()
	repeating_key = nil
end

--[[@param x integer]]
--[[@param y integer]]
function ui2d.WheelMoved(x, y)
	mouse.wheel_x = x
	mouse.wheel_y = y
end

--[[@param size? integer default=`14` font size]]
function ui2d.Init(size)
	local info = debug.getinfo(1, "S")
	local lib_path = info.source:match("@(.*[\\/])")
	font.handle = framework.LoadFont(lib_path, size)

	framework.SetPixelDensity(font.handle)
	font.h = font.handle:getHeight()
	font.w = font.handle:getWidth("W")
	font.size = size or 14
	framework.SetKeyRepeat()

	margin = math.floor(font.h / 2)
	separator_thickness = math.floor(font.h / 7)
end

function ui2d.InputInfo()
	for i, v in pairs(keys) do
		if framework.GetKeyDown(i) then
			if v[1] == 0 then
				v[1] = 1
				v[2] = 1
				v[3] = 1 -- pressed
			else
				v[1] = 1
				v[2] = 0
				v[3] = 2 -- held
			end
		else
			if v[1] == 1 then
				v[1] = 0
				v[3] = 3 -- released
			else
				v[1] = 0
				v[1] = 0
				v[3] = 0 -- idle
			end
		end
	end

	if framework.IsMouseDown(1) then
		if mouse.prev_frame == 0 then
			mouse.prev_frame = 1
			mouse.this_frame = 1
			mouse.state = e_mouse_state.clicked
		else
			mouse.prev_frame = 1
			mouse.this_frame = 0
			mouse.state = e_mouse_state.held
		end
	else
		if mouse.prev_frame == 1 then
			mouse.state = e_mouse_state.released
			mouse.prev_frame = 0
		else
			mouse.state = e_mouse_state.idle
		end
	end

	mouse.x, mouse.y = framework.GetMousePosition()

	-- Set active window on click
	local hovers_active = false
	local hovers_any = false
	for _, v in ipairs(windows) do
		if PointInRect(mouse.x, mouse.y, v.x, v.y, v.w, v.h) then
			if v == active_window then
				hovers_active = true
			end
			hovers_any = true
			has_mouse = true
		end
	end

	if modal_window then
		active_window = modal_window
		hovers_active = false
	end

	local z = 0
	local win = nil
	if not hovers_active then
		for _, v in ipairs(windows) do
			if PointInRect(mouse.x, mouse.y, v.x, v.y, v.w, v.h) and mouse.state == e_mouse_state.clicked then
				if v.z > z then
					win = v
					z = v.z
				end
			end
		end

		if win and not modal_window then
			next_z = next_z + 0.01
			win.z = next_z
			active_window = win
		end
	end

	-- Set active to none
	if not hovers_any and mouse.state == e_mouse_state.clicked then
		active_window = nil
		has_text_input = false
	end

	-- Give back mouse
	if not hovers_any then
		has_mouse = false
	end

	-- Handle window dragging
	if active_window then
		local v = active_window
		if PointInRect(mouse.x, mouse.y, v.x, v.y, v.w, (2 * margin) + font.h) and mouse.state == e_mouse_state.clicked then
			dragged_window = active_window
			dragged_window_offset.x = mouse.x - active_window.x
			dragged_window_offset.y = mouse.y - active_window.y
		end

		if dragged_window then
			if mouse.state == e_mouse_state.held then
				local mx         = mouse.x
				local my         = mouse.y
				local w, h       = framework.GetWindowDimensions()
				mx               = Clamp(mx, 10, w - 10)
				my               = Clamp(my, 10, h - 10)
				dragged_window.x = mx - dragged_window_offset.x
				dragged_window.y = my - dragged_window_offset.y
			end
		end
	end

	if mouse.state == e_mouse_state.released then
		dragged_window = nil
	end

	local now = framework.GetTime()
	if now > caret_blink.prev + 0.4 then
		caret_blink.on = true
	end

	if now > caret_blink.prev + 0.8 then
		caret_blink.on = false
		caret_blink.prev = now
	end
end

--[[@param name string]]
--[[@param x integer]]
--[[@param y integer]]
--[[@param is_modal? boolean default=`false`]]
function ui2d.Begin(name, x, y, is_modal)
	local exists, idx = WindowExists(name) -- TODO: Can't currently change window title at runtime

	if not exists then
		next_z = next_z + 0.01
		local window = {
			id = name,
			title = GetLabelPart(name),
			x = x,
			y = y,
			z = next_z,
			w = 0,
			h = 0,
			command_list = {},
			texture = nil,
			texture_w = 0,
			texture_h = 0,
			pass = nil,
			is_hovered = false,
			is_modal = is_modal or false,
			was_called_this_frame = true,
			cw = {}
		}
		table.insert(windows, window)

		if is_modal then
			modal_window = window
		end
	end
	layout.y = (2 * margin) + font.h

	if idx == 0 then
		begin_idx = #windows
	else
		begin_idx = idx
	end

	if idx > 0 then
		windows[idx].was_called_this_frame = true
	end

	begin_end_pairs.b = begin_end_pairs.b + 1
end

--[[@param main_pass lovr_pass]]
function ui2d.End(main_pass)
	local cur_window = windows[begin_idx]
	cur_window.w = layout.total_w
	cur_window.h = layout.total_h
	assert(cur_window.w > 0, "Begin/End block without widgets!")

	-- Cache texture
	if cur_window.texture then
		if cur_window.texture_w ~= cur_window.w or cur_window.texture_h ~= cur_window.h then
			cur_window.texture:release()
			cur_window.texture_w = cur_window.w
			cur_window.texture_h = cur_window.h
			cur_window.texture = framework.NewTexture(cur_window.w, cur_window.h)
			framework.SetCanvas(cur_window.pass, cur_window.texture)
		end
	else
		cur_window.texture = framework.NewTexture(cur_window.w, cur_window.h)
		cur_window.texture_w = cur_window.w
		cur_window.texture_h = cur_window.h
		cur_window.pass = framework.NewPass(cur_window.texture)
	end

	framework.SetCanvas(nil, cur_window.texture)
	framework.ResetPass(cur_window.pass)
	framework.SetFont(cur_window.pass)
	framework.ClearWindow(cur_window)

	-- Title bar and border
	local title_col = colors.window_titlebar
	if cur_window == active_window then
		title_col = colors.window_titlebar_active
	end
	table.insert(windows[begin_idx].command_list,
		{ type = "rect_fill", bbox = { x = 0, y = 0, w = cur_window.w, h = (2 * margin) + font.h }, color = title_col })

	local txt = cur_window.title
	local title_w = utf8.len(txt) * font.w
	if title_w > cur_window.w - (2 * margin) then -- Truncate title
		--[[@type integer]]
		--[[@diagnostic disable-next-line: assign-type-mismatch]]
		local num_chars = ((cur_window.w - (2 * margin)) / font.w) - 3
		txt = string.sub(txt, 1, num_chars) .. "..."
		title_w = utf8.len(txt) * font.w
	end

	table.insert(windows[begin_idx].command_list,
		{
			type = "text",
			text = txt,
			bbox = { x = margin, y = 0, w = title_w, h = (2 * margin) + font.h },
			color = colors
					.text
		})

	table.insert(windows[begin_idx].command_list,
		{ type = "rect_wire", bbox = { x = 0, y = 0, w = cur_window.w, h = cur_window.h }, color = colors.window_border })

	-- Do draw commands
	for i, v in ipairs(cur_window.command_list) do
		if v.type == "rect_fill" then
			if v.is_separator then
				framework.SetColor(cur_window.pass, v.color)
				framework.DrawRect(cur_window.pass, v.bbox.x + (cur_window.w / 2), v.bbox.y, cur_window.w - (2 * margin),
					separator_thickness, "fill")
			else
				framework.SetColor(cur_window.pass, v.color)
				framework.DrawRect(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w, v.bbox.h,
					"fill")
			end
		elseif v.type == "rect_wire" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawRect(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w, v.bbox.h,
				"line")
		elseif v.type == "circle_wire" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawCircle(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w / 2, "line")
		elseif v.type == "circle_fill" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawCircle(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w / 3, "fill")
		elseif v.type == "circle_wire_half" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawCircleHalf(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w / 2,
				"line", v.angle1, v.angle2)
		elseif v.type == "circle_fill_half" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawCircleHalf(cur_window.pass, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w / 2,
				"fill", v.angle1, v.angle2)
		elseif v.type == "line" then
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawLine(cur_window.pass, v.x1, v.y1, v.x2, v.y2)
		elseif v.type == "text" then
			framework.SetColor(cur_window.pass, v.color)
			--[[@type integer]]
			--[[@diagnostic disable-next-line: assign-type-mismatch]]
			local text_w = font.handle:getWidth(v.text)
			framework.DrawText(cur_window.pass, v.text, v.bbox.x, v.bbox.y, v.bbox.w, v.bbox.h, text_w)
		elseif v.type == "image" then
			-- NOTE Temp fix. Had to do negative vertical scale. Otherwise image gets flipped?
			framework.SetColor(cur_window.pass, v.color)
			framework.DrawImage(cur_window.pass, v.texture, v.bbox.x + (v.bbox.w / 2), v.bbox.y + (v.bbox.h / 2), v.bbox.w,
				v.bbox.h, clamp_sampler)
		end
	end

	ResetLayout()
	begin_end_pairs.e = begin_end_pairs.e + 1
end

function ui2d.HasMouse()
	return has_mouse
end

--[[@param name string]]
--[[@param x integer]]
--[[@param y integer]]
function ui2d.SetWindowPosition(name, x, y)
	local exists, idx = WindowExists(name)
	if exists then
		windows[idx].x = x
		windows[idx].y = y
		return true
	end

	return false
end

--[[@param name string]]
function ui2d.GetWindowPosition(name)
	local exists, idx = WindowExists(name)
	if exists then
		return windows[idx].x, windows[idx].y
	end

	return nil
end

--[[@param name string]]
function ui2d.GetWindowSize(name)
	local exists, idx = WindowExists(name)
	if exists then
		return windows[idx].w, windows[idx].h
	end

	return nil
end

--[[@param theme "light"|"dark"|table<string,lovrui2d_color>]]
--[[@param copy_from? "light"|"dark"]]
function ui2d.SetColorTheme(theme, copy_from)
	if type(theme) == "string" then
		colors = color_themes[theme]
	elseif type(theme) == "table" then
		copy_from = copy_from or "dark"
		for i, v in pairs(color_themes[copy_from]) do
			if theme[i] == nil then
				theme[i] = v
			end
		end
		colors = theme
	end
end

function ui2d.GetColorTheme()
	for i, v in pairs(color_themes) do
		if v == colors then
			return i
		end
	end
end

--[[@param col_name string]]
--[[@param color lovrui2d_color]]
function ui2d.OverrideColor(col_name, color)
	if not overriden_colors[col_name] then
		local old_color = colors[col_name]
		overriden_colors[col_name] = old_color
		colors[col_name] = color
	end
end

--[[@param col_name string]]
function ui2d.ResetColor(col_name)
	if overriden_colors[col_name] then
		colors[col_name] = overriden_colors[col_name]
		overriden_colors[col_name] = nil
	end
end

--[[@param size integer]]
function ui2d.SetFontSize(size)
	local info = debug.getinfo(1, "S")

	clamp_sampler = framework.NewSampler()
	local lib_path = info.source:match("@(.*[\\/])")
	font.handle = framework.LoadFont(lib_path, size)

	framework.SetPixelDensity(font.handle)
	font.h = font.handle:getHeight()
	font.w = font.handle:getWidth("W")
	font.size = size

	margin = math.floor(font.h / 2)
	separator_thickness = math.floor(font.h / 7)
end

function ui2d.GetFontSize()
	return font.size
end

function ui2d.HasTextInput()
	return has_text_input
end

function ui2d.IsModalOpen()
	return modal_window
end

function ui2d.EndModalWindow()
	modal_window = nil
end

function ui2d.SameLine()
	layout.same_line = true
end

function ui2d.SameColumn()
	layout.same_column = true
end

--[[@param name string]]
--[[@param width? integer]]
--[[@param height? integer]]
--[[@param tooltip? string]]
function ui2d.Button(name, width, height, tooltip)
	local text = GetLabelPart(name)
	local cur_window = windows[begin_idx]
	local text_w = utf8.len(text) * font.w
	local num_lines = GetLineCount(text)

	local bbox = {}
	if layout.same_line then
		bbox = {
			x = layout.x + layout.w + margin,
			y = layout.y,
			w = (2 * margin) + text_w,
			h = (2 * margin) +
					(num_lines * font.h)
		}
	elseif layout.same_column then
		bbox = {
			x = layout.x,
			y = layout.y + layout.h + margin,
			w = (2 * margin) + text_w,
			h = (2 * margin) +
					(num_lines * font.h)
		}
	else
		bbox = {
			x = margin,
			y = layout.y + layout.row_h + margin,
			w = (2 * margin) + text_w,
			h = (2 * margin) +
					(num_lines * font.h)
		}
	end

	if width and type(width) == "number" and width > bbox.w then
		bbox.w = width
	end
	if height and type(height) == "number" and height > bbox.h then
		bbox.h = height
	end

	UpdateLayout(bbox)

	local result = false
	local col = colors.button_bg

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col = colors.button_bg_hover
			if mouse.state == e_mouse_state.clicked then
				result = true
			end
			if mouse.state == e_mouse_state.held then
				col = colors.button_bg_click
			end
		end
	end

	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = bbox, color = col })
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = bbox, color = colors.button_border })
	table.insert(windows[begin_idx].command_list, { type = "text", text = text, bbox = bbox, color = colors.text })

	return result
end

--[[@param name string]]
--[[@param v integer]]
--[[@param v_min integer]]
--[[@param v_max integer]]
--[[@param width? integer]]
--[[@param tooltip? string]]
function ui2d.SliderInt(name, v, v_min, v_max, width, tooltip)
	return Slider(e_slider_type.int, name, v, v_min, v_max, width, tooltip)
end

--[[@param name string]]
--[[@param v number]]
--[[@param v_min number]]
--[[@param v_max number]]
--[[@param width? integer]]
--[[@param tooltip? string]]
--[[@param num_decimals? integer default=`2`]]
function ui2d.SliderFloat(name, v, v_min, v_max, width, tooltip, num_decimals)
	return Slider(e_slider_type.float, name, v, v_min, v_max, width, tooltip, num_decimals)
end

--[[@param progress number]]
--[[@param width? integer default=`300`]]
--[[@param tooltip? string]]
function ui2d.ProgressBar(progress, width, tooltip)
	local cur_window = windows[begin_idx]
	if width and width >= (2 * margin) + (4 * font.w) then
		width = width
	else
		width = 300
	end

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = width, h = (2 * margin) + font.h }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h, w = width, h = (2 * margin) + font.h }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = width, h = (2 * margin) + font.h }
	end

	UpdateLayout(bbox)

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
		end
	end

	progress = Clamp(progress, 0, 100)
	local fill_w = math.floor((width * progress) / 100)
	local str = progress .. "%"

	table.insert(windows[begin_idx].command_list,
		{ type = "rect_fill", bbox = { x = bbox.x, y = bbox.y, w = fill_w, h = bbox.h }, color = colors.progress_bar_fill })
	table.insert(windows[begin_idx].command_list,
		{
			type = "rect_fill",
			bbox = { x = bbox.x + fill_w, y = bbox.y, w = bbox.w - fill_w, h = bbox.h },
			color = colors
					.progress_bar_bg
		})
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = bbox, color = colors.progress_bar_border })
	table.insert(windows[begin_idx].command_list, { type = "text", text = str, bbox = bbox, color = colors.text })
end

function ui2d.Separator()
	local bbox = {}
	if layout.same_line or layout.same_column then
		return
	else
		bbox = { x = 0, y = layout.y + layout.row_h + margin, w = 0, h = 0 }
	end

	UpdateLayout(bbox)

	table.insert(windows[begin_idx].command_list,
		{ is_separator = true, type = "rect_fill", bbox = bbox, color = colors.separator })
end

--[[@param texture lovr_texture]]
--[[@param width? integer]]
--[[@param height? integer]]
--[[@param text? string]]
--[[@param tooltip? string]]
function ui2d.ImageButton(texture, width, height, text, tooltip)
	local cur_window = windows[begin_idx]
	--[[@diagnostic disable-next-line: cast-local-type]]
	width = width or texture:getWidth()
	--[[@diagnostic disable-next-line: cast-local-type]]
	height = height or texture:getHeight()

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = width, h = height }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = width, height = height }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = width, h = height }
	end

	local text_w

	if text then
		text_w = font.handle:getWidth(text)
		font.h = font.handle:getHeight()

		if font.h > bbox.h then
			bbox.h = font.h
		end
		bbox.w = bbox.w + (2 * margin) + text_w
	end

	UpdateLayout(bbox)

	local result = false
	local col = 1

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			table.insert(windows[begin_idx].command_list,
				{ type = "rect_wire", bbox = bbox, color = colors.image_button_border_highlight })

			if mouse.state == e_mouse_state.clicked then
				result = true
			end
			if mouse.state == e_mouse_state.held then
				col = 0.7
			end
		end
	end

	local original_w = texture:getWidth()
	local original_h = texture:getHeight()

	if text then
		table.insert(windows[begin_idx].command_list,
			{
				type = "image",
				bbox = { x = bbox.x, y = bbox.y + ((bbox.h - height) / 2), w = width, h = height },
				texture = texture,
				image_w = original_w,
				image_h = original_h,
				color = { col, col, col }
			})
		table.insert(windows[begin_idx].command_list,
			{
				type = "text",
				text = text,
				bbox = { x = bbox.x + width, y = bbox.y, w = text_w + (2 * margin), h = bbox.h },
				color =
						colors.text
			})
	else
		table.insert(windows[begin_idx].command_list,
			{ type = "image", bbox = bbox, texture = texture, image_w = original_w, image_h = original_h, color = { col, col, col } })
	end

	return result
end

--[[@param width integer]]
--[[@param height integer]]
function ui2d.Dummy(width, height)
	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = width, h = height }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = width, h = height }
	end

	UpdateLayout(bbox)
end

--[[@param name string]]
--[[@param tabs string[] ]]
--[[@param idx integer]]
--[[@param tooltip? string]]
function ui2d.TabBar(name, tabs, idx, tooltip)
	local cur_window = windows[begin_idx]
	local bbox = {}

	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = 0, h = (2 * margin) + font.h }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = 0, h = (2 * margin) + font.h }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = 0, h = (2 * margin) + font.h }
	end

	local result = false
	local col = colors.tab_bar_bg
	local x_off = bbox.x

	for i, v in ipairs(tabs) do
		--[[@type integer]]
		--[[@diagnostic disable-next-line: assign-type-mismatch]]
		local text_w = font.handle:getWidth(v)
		local tab_w = text_w + (2 * margin)
		bbox.w = bbox.w + tab_w

		if not modal_window or (modal_window and modal_window == cur_window) then
			if PointInRect(mouse.x, mouse.y, x_off + cur_window.x, bbox.y + cur_window.y, tab_w, bbox.h) and cur_window == active_window then
				if tooltip then
					active_tooltip.text = tooltip
					active_tooltip.x = mouse.x
					active_tooltip.y = mouse.y
				end
				col = colors.tab_bar_hover
				if mouse.state == e_mouse_state.clicked and cur_window.id .. name then
					idx = i
					result = true
				end
			else
				col = colors.tab_bar_bg
			end
		end

		local tab_rect = { x = x_off, y = bbox.y, w = tab_w, h = bbox.h }
		table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = tab_rect, color = col })
		table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = tab_rect, color = colors.tab_bar_border })
		table.insert(windows[begin_idx].command_list, { type = "text", text = v, bbox = tab_rect, color = colors.text })

		if idx == i then
			local highlight_thickness = math.floor(font.h / 4)
			table.insert(windows[begin_idx].command_list,
				{
					type = "rect_fill",
					bbox = { x = tab_rect.x + 2, y = tab_rect.y + tab_rect.h - (highlight_thickness), w = tab_rect.w - 4, h = highlight_thickness },
					color = colors.tab_bar_highlight
				})
		end
		x_off = x_off + tab_w
	end

	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = bbox, color = colors.tab_bar_border })
	UpdateLayout(bbox)

	return result, idx
end

--[[@param text string]]
--[[@param compact? boolean]]
function ui2d.Label(text, compact)
	local text_w = font.handle:getWidth(text)
	local num_lines = GetLineCount(text)

	local mrg = (2 * margin)
	if compact then
		mrg = 0
	end

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = text_w, h = mrg + (num_lines * font.h) }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = text_w, h = mrg + (num_lines * font.h) }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = text_w, h = mrg + (num_lines * font.h) }
	end

	UpdateLayout(bbox)

	table.insert(windows[begin_idx].command_list, { type = "text", text = text, bbox = bbox, color = colors.text })
end

--[[@param text string]]
--[[@param checked boolean]]
--[[@param tooltip? string]]
function ui2d.CheckBox(text, checked, tooltip)
	local cur_window = windows[begin_idx]
	local text_w = font.handle:getWidth(text)

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	end

	UpdateLayout(bbox)

	local result = false
	local col = colors.check_border

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col = colors.check_border_hover
			if mouse.state == e_mouse_state.clicked then
				result = true
			end
		end
	end

	local check_rect = { x = bbox.x, y = bbox.y + margin, w = font.h, h = font.h }
	local text_rect = { x = bbox.x + font.h + margin, y = bbox.y, w = text_w + margin, h = bbox.h }
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = check_rect, color = col })
	table.insert(windows[begin_idx].command_list, { type = "text", text = text, bbox = text_rect, color = colors.text })

	if checked and type(checked) == "boolean" then
		table.insert(windows[begin_idx].command_list,
			{ type = "text", text = "✔", bbox = check_rect, color = colors.check_mark })
	end

	return result
end

--[[@param text string]]
--[[@param checked boolean]]
--[[@param tooltip? string]]
function ui2d.ToggleButton(text, checked, tooltip)
	local cur_window = windows[begin_idx]
	local text_w = font.handle:getWidth(text)

	local bbox = {}
	if layout.same_line then
		bbox = {
			x = layout.x + layout.w + margin,
			y = layout.y,
			w = (2 * font.h) + margin + text_w,
			h = (2 * margin) +
					font.h
		}
	elseif layout.same_column then
		bbox = {
			x = layout.x,
			y = layout.y + layout.h + margin,
			w = (2 * font.h) + margin + text_w,
			h = (2 * margin) +
					font.h
		}
	else
		bbox = {
			x = margin,
			y = layout.y + layout.row_h + margin,
			w = (2 * font.h) + margin + text_w,
			h = (2 * margin) +
					font.h
		}
	end

	UpdateLayout(bbox)

	local result = false
	local col_border = colors.toggle_border

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col_border = colors.toggle_border_hover
			if mouse.state == e_mouse_state.clicked then
				result = true
			end
		end
	end

	local half_left = { x = bbox.x, y = bbox.y + margin, w = font.h, h = font.h }
	local half_right = { x = bbox.x + font.h, y = bbox.y + margin, w = font.h, h = font.h }
	local middle = { x = bbox.x + (font.h / 2), y = bbox.y + margin, w = font.h, h = font.h }
	local text_rect = { x = bbox.x + (2 * font.h) + margin, y = bbox.y, w = text_w + margin, h = bbox.h }

	table.insert(windows[begin_idx].command_list, { type = "text", text = text, bbox = text_rect, color = colors.text })

	if checked and type(checked) == "boolean" then
		table.insert(windows[begin_idx].command_list,
			{
				type = "circle_fill_half",
				bbox = half_left,
				color = colors.toggle_bg_on,
				angle1 = math.pi / 2,
				angle2 = math.pi *
						1.5
			})
		table.insert(windows[begin_idx].command_list,
			{
				type = "circle_fill_half",
				bbox = half_right,
				color = colors.toggle_bg_on,
				angle1 = -math.pi / 2,
				angle2 = math
						.pi / 2
			})
		table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = middle, color = colors.toggle_bg_on })
		table.insert(windows[begin_idx].command_list,
			{ type = "circle_fill", bbox = half_right, color = colors.toggle_handle })
	else
		table.insert(windows[begin_idx].command_list,
			{
				type = "circle_fill_half",
				bbox = half_left,
				color = colors.toggle_bg_off,
				angle1 = math.pi / 2,
				angle2 = math
						.pi * 1.5
			})
		table.insert(windows[begin_idx].command_list,
			{
				type = "circle_fill_half",
				bbox = half_right,
				color = colors.toggle_bg_off,
				angle1 = -math.pi / 2,
				angle2 = math
						.pi / 2
			})
		table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = middle, color = colors.toggle_bg_off })
		table.insert(windows[begin_idx].command_list,
			{ type = "circle_fill", bbox = half_left, color = colors.toggle_handle })
	end

	table.insert(windows[begin_idx].command_list,
		{ type = "circle_wire_half", bbox = half_left, color = col_border, angle1 = math.pi / 2, angle2 = math.pi * 1.5 })
	table.insert(windows[begin_idx].command_list,
		{ type = "circle_wire_half", bbox = half_right, color = col_border, angle1 = -math.pi / 2, angle2 = math.pi / 2 })
	table.insert(windows[begin_idx].command_list,
		{
			type = "line",
			x1 = bbox.x + (font.h / 2),
			y1 = bbox.y + margin,
			x2 = bbox.x + (font.h * 1.5),
			y2 = bbox.y + margin,
			color =
					col_border
		})
	table.insert(windows[begin_idx].command_list,
		{
			type = "line",
			x1 = bbox.x + (font.h / 2),
			y1 = bbox.y + margin + font.h,
			x2 = bbox.x + (font.h * 1.5),
			y2 = bbox
					.y + margin + font.h,
			color = col_border
		})
	return result
end

--[[@param text string]]
--[[@param checked boolean]]
--[[@param tooltip? string]]
function ui2d.RadioButton(text, checked, tooltip)
	local cur_window = windows[begin_idx]
	local text_w = font.handle:getWidth(text)

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = font.h + margin + text_w, h = (2 * margin) + font.h }
	end

	UpdateLayout(bbox)

	local result = false
	local col = colors.radio_border

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col = colors.radio_border_hover

			if mouse.state == e_mouse_state.clicked then
				result = true
			end
		end
	end

	local check_rect = { x = bbox.x, y = bbox.y + margin, w = font.h, h = font.h }
	local text_rect = { x = bbox.x + font.h + margin, y = bbox.y, w = text_w + margin, h = bbox.h }
	table.insert(windows[begin_idx].command_list, { type = "circle_wire", bbox = check_rect, color = col })
	table.insert(windows[begin_idx].command_list, { type = "text", text = text, bbox = text_rect, color = colors.text })

	if checked and type(checked) == "boolean" then
		table.insert(windows[begin_idx].command_list, { type = "circle_fill", bbox = check_rect, color = colors.radio_mark })
	end

	return result
end

--[[@param name string]]
--[[@param num_visible_chars integer]]
--[[@param text string]]
--[[@param tooltip? string]]
function ui2d.TextBox(name, num_visible_chars, text, tooltip)
	local cur_window = windows[begin_idx]
	local label = GetLabelPart(name)
	local label_w = font.handle:getWidth(label)

	local bbox = {}
	if layout.same_line then
		bbox = {
			x = layout.x + layout.w + margin,
			y = layout.y,
			w = (4 * margin) + (num_visible_chars * font.w) + label_w,
			h = (2 * margin) +
					font.h
		}
	elseif layout.same_column then
		bbox = {
			x = layout.x,
			y = layout.y + layout.h + margin,
			w = (4 * margin) + (num_visible_chars * font.w) + label_w,
			h = (2 * margin) +
					font.h
		}
	else
		bbox = {
			x = margin,
			y = layout.y + layout.row_h + margin,
			w = (4 * margin) + (num_visible_chars * font.w) + label_w,
			h = (2 * margin) +
					font.h
		}
	end

	UpdateLayout(bbox)

	local scroll = 0
	if active_textbox and active_textbox.id == cur_window.id .. name then
		scroll = active_textbox.scroll
	end

	local text_rect = { x = bbox.x, y = bbox.y, w = (2 * margin) + (num_visible_chars * font.w), h = bbox.h }
	local visible_text = nil
	if utf8.len(text) > num_visible_chars then
		visible_text = utf8.sub(text, scroll + 1, scroll + num_visible_chars)
	else
		visible_text = text
	end
	local label_rect = { x = text_rect.x + text_rect.w + margin, y = bbox.y, w = label_w, h = bbox.h }
	local char_rect = { x = text_rect.x + margin, y = text_rect.y, w = (utf8.len(visible_text) * font.w), h = text_rect.h }

	-- Text editing
	local caret_rect = nil
	if active_widget == cur_window.id .. name then
		if text_input_character then
			local p = active_textbox.caret + active_textbox.scroll
			local part1 = utf8.sub(text, 1, p)
			local part2 = utf8.sub(text, p + 1, utf8.len(text))
			text = part1 .. text_input_character .. part2
			active_textbox.caret = active_textbox.caret + 1
			if active_textbox.caret > num_visible_chars then
				active_textbox.scroll = active_textbox.scroll + 1
			end
		end

		if keys["backspace"][3] == 1 or repeating_key == "backspace" then
			if active_textbox.caret > 0 then
				local p = active_textbox.caret + active_textbox.scroll
				local part1 = utf8.sub(text, 1, p - 1)
				local part2 = utf8.sub(text, p + 1, utf8.len(text))
				text = part1 .. part2

				local max_scroll = utf8.len(text) - num_visible_chars
				if active_textbox.scroll < max_scroll or utf8.len(text) < num_visible_chars then
					active_textbox.caret = active_textbox.caret - 1
				end
			end
		end

		if keys["delete"][3] == 1 or repeating_key == "delete" then
			if active_textbox.caret < num_visible_chars and active_textbox.caret < utf8.len(text) then
				local p = active_textbox.caret + active_textbox.scroll
				local part1 = utf8.sub(text, 1, p)
				local part2 = utf8.sub(text, p + 2, utf8.len(text))
				text = part1 .. part2

				local max_scroll = utf8.len(text) - num_visible_chars
				if active_textbox.scroll >= max_scroll and utf8.len(text) > num_visible_chars then
					active_textbox.caret = active_textbox.caret + 1
				end
			end
		end

		if keys["left"][3] == 1 or repeating_key == "left" then
			if active_textbox.caret == 0 then
				if active_textbox.scroll > 0 then
					active_textbox.scroll = active_textbox.scroll - 1
				end
			end
			active_textbox.caret = active_textbox.caret - 1
		end

		if keys["right"][3] == 1 or repeating_key == "right" then
			local full_length = utf8.len(text)
			local visible_length = utf8.len(visible_text)
			if active_textbox.caret == num_visible_chars and full_length > num_visible_chars and active_textbox.scroll < (full_length - visible_length) then
				active_textbox.scroll = active_textbox.scroll + 1
			end
			if active_textbox.caret < full_length then
				active_textbox.caret = active_textbox.caret + 1
			end
		end

		local max_scroll = utf8.len(text) - num_visible_chars
		if max_scroll < 0 then max_scroll = 0 end
		active_textbox.scroll = Clamp(active_textbox.scroll, 0, max_scroll)
		scroll = active_textbox.scroll
		active_textbox.caret = Clamp(active_textbox.caret, 0, num_visible_chars)
		caret_rect = { x = char_rect.x + (active_textbox.caret * font.w), y = char_rect.y + margin, w = 2, h = font.h }
	end

	local col1 = colors.textbox_bg
	local col2 = colors.textbox_border

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, text_rect.x + cur_window.x, text_rect.y + cur_window.y, text_rect.w, text_rect.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			col1 = colors.textbox_bg_hover

			if mouse.state == e_mouse_state.clicked then
				has_text_input = true
				local pos = math.floor((mouse.x - cur_window.x - text_rect.x) / font.w)
				if pos > utf8.len(text) then
					pos = utf8.len(text)
				end

				if active_widget ~= cur_window.id .. name then
					active_textbox = { id = cur_window.id .. name, caret = pos }
					active_textbox.scroll = 0
					active_widget = cur_window.id .. name
				else
					active_textbox.caret = pos
				end
			end
		else
			if mouse.state == e_mouse_state.clicked then
				if active_widget == cur_window.id .. name then -- Deactivate self
					has_text_input = false
					active_textbox = nil
					active_widget = nil
					return text, true
				end
			end
		end

		if active_widget == cur_window.id .. name then
			if keys["tab"][3] == 1 or keys["return"][3] == 1 or keys["kpenter"][3] == 1 then -- Deactivate self
				has_text_input = false
				active_textbox = nil
				active_widget = nil
				return text, true
			end
		end
	end

	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = text_rect, color = col1 })
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = text_rect, color = col2 })
	table.insert(windows[begin_idx].command_list,
		{ type = "text", text = visible_text, bbox = char_rect, color = colors.text })
	table.insert(windows[begin_idx].command_list, { type = "text", text = label, bbox = label_rect, color = colors.text })

	if caret_rect and caret_blink.on then
		table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = caret_rect, color = colors.text })
	end

	return text, false
end

--[[@param name string]]
--[[@param idx integer]]
function ui2d.ListBoxSetSelected(name, idx)
	local exists, lst_idx = ListBoxExists(name)
	if exists then
		if type(idx) == "table" then
			listbox_state[lst_idx].selection = {}
			for i, v in ipairs(idx) do
				table.insert(listbox_state[lst_idx].selection, v)
			end
		else
			listbox_state[lst_idx].selected_idx = idx
		end
	end
end

--[[@param name string]]
--[[@param num_visible_rows integer]]
--[[@param num_visible_chars integer]]
--[[@param collection unknown[] ]]
--[[@param selected? number|string]]
--[[@param multi_select? boolean]]
--[[@param tooltip? string]]
function ui2d.ListBox(name, num_visible_rows, num_visible_chars, collection, selected, multi_select, tooltip)
	local cur_window = windows[begin_idx]
	local exists, lst_idx = ListBoxExists(cur_window.id .. name)

	if not exists then
		local selected_idx = 0
		if type(selected) == "number" then
			selected_idx = selected
		elseif type(selected) == "string" then
			for i = 1, #collection do
				if selected == collection[i] then
					selected_idx = i
					break
				end
			end
		end
		local lb = { id = cur_window.id .. name, selected_idx = selected_idx, scroll_x = 0, scroll_y = 0, selection = {} }
		if selected_idx > 0 then
			table.insert(lb.selection, selected_idx)
		end
		table.insert(listbox_state, lb)
	end

	if lst_idx == 0 then
		lst_idx = #listbox_state
	end

	--[[@type number]]
	local sbt = font.h -- scrollbar thickness
	local bbox = {}
	if layout.same_line then
		bbox = {
			x = layout.x + layout.w + margin,
			y = layout.y,
			w = (2 * margin) + (num_visible_chars * font.w) + sbt,
			h = (num_visible_rows * font.h) +
					sbt
		}
	elseif layout.same_column then
		bbox = {
			x = layout.x,
			y = layout.y + layout.h + margin,
			w = (2 * margin) + (num_visible_chars * font.w) + sbt,
			h = (num_visible_rows * font.h) +
					sbt
		}
	else
		bbox = {
			x = margin,
			y = layout.y + layout.row_h + margin,
			w = (2 * margin) + (num_visible_chars * font.w) + sbt,
			h = (num_visible_rows * font.h) +
					sbt
		}
	end

	UpdateLayout(bbox)

	local sb_vertical = { x = bbox.x + bbox.w - sbt, y = bbox.y + sbt, w = sbt, h = bbox.h - (3 * sbt) }
	local sb_horizontal = { x = bbox.x + sbt, y = bbox.y + bbox.h - sbt, w = bbox.w - (3 * sbt), h = sbt }
	local sb_button_top = { x = bbox.x + bbox.w - sbt, y = bbox.y, w = sbt, h = sbt }
	local sb_button_bottom = { x = bbox.x + bbox.w - sbt, y = bbox.y + bbox.h - (2 * sbt), w = sbt, h = sbt }
	local sb_button_left = { x = bbox.x, y = bbox.y + bbox.h - sbt, w = sbt, h = sbt }
	local sb_button_right = { x = bbox.x + bbox.w - (2 * sbt), y = bbox.y + bbox.h - sbt, w = sbt, h = sbt }

	local max_total_chars_x = GetLongerStringLen(collection)
	local highlight_idx = nil
	local result = false

	-- Input for buttons and selection
	local t_btn_col = colors.list_button
	local b_btn_col = colors.list_button
	local l_btn_col = colors.list_button
	local r_btn_col = colors.list_button
	if not modal_window or (modal_window and modal_window == cur_window) then
		if cur_window == active_window then
			if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) then -- whole listbox
				if tooltip then
					active_tooltip.text = tooltip
					active_tooltip.x = mouse.x
					active_tooltip.y = mouse.y
				end
				listbox_state[lst_idx].scroll_y = listbox_state[lst_idx].scroll_y - mouse.wheel_y
				listbox_state[lst_idx].scroll_x = listbox_state[lst_idx].scroll_x - mouse.wheel_x
			end

			if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w - sbt, bbox.h - sbt) and #collection > 0 then -- content area
				highlight_idx = math.floor((mouse.y - cur_window.y - bbox.y) / (font.h)) + 1
				highlight_idx = Clamp(highlight_idx, 1, #collection)

				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].selected_idx = highlight_idx + listbox_state[lst_idx].scroll_y
					result = true
					if multi_select then
						if framework.GetKeyDown("lctrl") then
							local exists_ = false
							local idx = 0
							for i, v in ipairs(listbox_state[lst_idx].selection) do
								if v == listbox_state[lst_idx].selected_idx then
									idx = i
									exists_ = true
									break
								end
							end
							if not exists_ then
								table.insert(listbox_state[lst_idx].selection, listbox_state[lst_idx].selected_idx)
							else
								table.remove(listbox_state[lst_idx].selection, idx)
							end
						else
							listbox_state[lst_idx].selection = {}
							table.insert(listbox_state[lst_idx].selection, listbox_state[lst_idx].selected_idx)
						end
					end
				end
			elseif PointInRect(mouse.x, mouse.y, sb_vertical.x + cur_window.x, sb_vertical.y + cur_window.y, sbt, sb_vertical.h) then    -- v_scrollbar
			elseif PointInRect(mouse.x, mouse.y, sb_horizontal.x + cur_window.x, sb_horizontal.y + cur_window.y, sb_horizontal.w, sbt) then -- h_scrollbar
			elseif PointInRect(mouse.x, mouse.y, sb_button_top.x + cur_window.x, sb_button_top.y + cur_window.y, sb_button_top.w, sbt) then -- button top
				t_btn_col = colors.list_button_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].scroll_y = listbox_state[lst_idx].scroll_y - 1
					t_btn_col = colors.list_button_click
				end
			elseif PointInRect(mouse.x, mouse.y, sb_button_bottom.x + cur_window.x, sb_button_bottom.y + cur_window.y, sb_button_bottom.w, sbt) then -- button bottom
				b_btn_col = colors.list_button_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].scroll_y = listbox_state[lst_idx].scroll_y + 1
					b_btn_col = colors.list_button_click
				end
			elseif PointInRect(mouse.x, mouse.y, sb_button_left.x + cur_window.x, sb_button_left.y + cur_window.y, sb_button_left.w, sbt) then -- button left
				l_btn_col = colors.list_button_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].scroll_x = listbox_state[lst_idx].scroll_x - 1
					l_btn_col = colors.list_button_click
				end
			elseif PointInRect(mouse.x, mouse.y, sb_button_right.x + cur_window.x, sb_button_right.y + cur_window.y, sb_button_right.w, sbt) then -- button right
				r_btn_col = colors.list_button_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].scroll_x = listbox_state[lst_idx].scroll_x + 1
					r_btn_col = colors.list_button_click
				end
			end
		end
	end

	-- Draw scrollbars	
	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = bbox, color = colors.list_bg })
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = bbox, color = colors.list_border })
	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = sb_vertical, color = colors.list_track })
	table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = sb_horizontal, color = colors.list_track })
	table.insert(windows[begin_idx].command_list, { type = "text", text = "△", bbox = sb_button_top, color = t_btn_col })
	table.insert(windows[begin_idx].command_list, { type = "text", text = "▽", bbox = sb_button_bottom, color = b_btn_col })
	table.insert(windows[begin_idx].command_list, { type = "text", text = "◁", bbox = sb_button_left, color = l_btn_col })
	table.insert(windows[begin_idx].command_list, { type = "text", text = "▷", bbox = sb_button_right, color = r_btn_col })

	local max_scroll_y = 0
	if #collection > num_visible_rows then
		max_scroll_y = #collection - num_visible_rows
	end
	local max_scroll_x = max_total_chars_x - num_visible_chars - 1
	if max_scroll_x < 0 then
		max_scroll_x = 0
	end

	listbox_state[lst_idx].scroll_y = Clamp(listbox_state[lst_idx].scroll_y, 0, max_scroll_y)
	listbox_state[lst_idx].scroll_x = Clamp(listbox_state[lst_idx].scroll_x, 0, max_scroll_x)

	local scroll_y = listbox_state[lst_idx].scroll_y
	local scroll_x = listbox_state[lst_idx].scroll_x
	local first = scroll_y + 1
	local last = scroll_y + num_visible_rows
	if #collection < num_visible_rows then
		last = #collection
	end

	-- Input for thumbs
	if not modal_window or (modal_window and modal_window == cur_window) then
		-- thumb vertical
		if max_scroll_y > 0 then
			local v_thumb_height = sb_vertical.h * (num_visible_rows / #collection)
			local max_dist = sb_vertical.h - v_thumb_height
			local scroll_distance = MapRange(0, max_scroll_y, 0, max_dist, scroll_y)
			local thumb_vertical = { x = bbox.x + bbox.w - sbt, y = bbox.y + sbt + scroll_distance, w = sbt, h = v_thumb_height }

			local col = colors.list_thumb
			if PointInRect(mouse.x, mouse.y, thumb_vertical.x + cur_window.x, thumb_vertical.y + cur_window.y, sbt, thumb_vertical.h) then
				col = colors.list_thumb_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].mouse_start_y = mouse.y
					listbox_state[lst_idx].old_scroll_y = listbox_state[lst_idx].scroll_y
				end
			end

			if mouse.state == e_mouse_state.held and listbox_state[lst_idx].mouse_start_y then
				col = colors.list_thumb_click
				local pixel_steps = max_scroll_y / font.h
				local diff = mouse.y - listbox_state[lst_idx].mouse_start_y
				listbox_state[lst_idx].scroll_y = math.floor(diff / pixel_steps) + listbox_state[lst_idx].old_scroll_y
			end

			if mouse.state == e_mouse_state.released and listbox_state[lst_idx].mouse_start_y then
				listbox_state[lst_idx].mouse_start_y = nil
				listbox_state[lst_idx].old_scroll_y = nil
			end

			table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = thumb_vertical, color = col })
		end

		-- thumb horizontal
		if max_scroll_x > 0 then
			local h_thumb_width = sb_horizontal.w * (num_visible_chars / max_total_chars_x)
			local max_dist = sb_horizontal.w - h_thumb_width
			local scroll_distance = MapRange(0, max_scroll_x, 0, max_dist, scroll_x)
			local thumb_horizontal = {
				x = bbox.x + sbt + scroll_distance,
				y = bbox.y + bbox.h - sbt,
				w = h_thumb_width,
				h =
						sbt
			}

			local col = colors.list_thumb
			if PointInRect(mouse.x, mouse.y, thumb_horizontal.x + cur_window.x, thumb_horizontal.y + cur_window.y, thumb_horizontal.w, sbt) then
				col = colors.list_thumb_hover
				if mouse.state == e_mouse_state.clicked then
					listbox_state[lst_idx].mouse_start_x = mouse.x
					listbox_state[lst_idx].old_scroll_x = listbox_state[lst_idx].scroll_x
				end
			end

			if mouse.state == e_mouse_state.held and listbox_state[lst_idx].mouse_start_x then
				col = colors.list_thumb_click
				local pixel_steps = max_scroll_x / font.h
				local diff = mouse.x - listbox_state[lst_idx].mouse_start_x
				listbox_state[lst_idx].scroll_x = math.floor(diff / pixel_steps) + listbox_state[lst_idx].old_scroll_x
			end

			if mouse.state == e_mouse_state.released and listbox_state[lst_idx].mouse_start_x then
				listbox_state[lst_idx].mouse_start_x = nil
				listbox_state[lst_idx].old_scroll_x = nil
			end

			table.insert(windows[begin_idx].command_list, { type = "rect_fill", bbox = thumb_horizontal, color = col })
		end
	end

	-- Draw selected rect
	if multi_select then
		for i, v in ipairs(listbox_state[lst_idx].selection) do
			local sel_idx = v
			if sel_idx >= first and sel_idx <= last then
				local selected_rect = { x = bbox.x, y = bbox.y + (sel_idx - scroll_y - 1) * font.h, w = bbox.w - sbt, h = font.h }
				table.insert(windows[begin_idx].command_list,
					{ type = "rect_fill", bbox = selected_rect, color = colors.list_selected })
			end
		end
	else
		local sel_idx = listbox_state[lst_idx].selected_idx
		if sel_idx >= first and sel_idx <= last then
			local selected_rect = { x = bbox.x, y = bbox.y + (sel_idx - scroll_y - 1) * font.h, w = bbox.w - sbt, h = font.h }
			table.insert(windows[begin_idx].command_list,
				{ type = "rect_fill", bbox = selected_rect, color = colors.list_selected })
		end
	end

	-- Draw highlight rect
	if highlight_idx then
		local highlight_rect = { x = bbox.x, y = bbox.y + ((highlight_idx - 1) * font.h), w = bbox.w - sbt, h = font.h }
		table.insert(windows[begin_idx].command_list,
			{ type = "rect_fill", bbox = highlight_rect, color = colors.list_highlight })
	end

	-- Draw entries
	local y_offset = bbox.y
	for i = first, last do
		local final_str = nil
		local cur = collection[i]
		local cur_len = utf8.len(cur)

		if cur_len - scroll_x > num_visible_chars + 1 then
			final_str = utf8.sub(cur, scroll_x + 1, num_visible_chars + scroll_x + 1)
		else
			if scroll_x < cur_len then
				final_str = utf8.sub(cur, scroll_x + 1, cur_len)
			else
				final_str = nil
			end
		end

		if final_str then
			local final_len = utf8.len(final_str)
			local item_w = final_len * font.w
			table.insert(windows[begin_idx].command_list,
				{
					type = "text",
					text = final_str,
					bbox = { x = bbox.x, y = y_offset, w = item_w + margin, h = font.h },
					color =
							colors.text
				})
		end
		y_offset = y_offset + font.h
	end

	if #collection > 0 then
		listbox_state[lst_idx].selected_idx = Clamp(listbox_state[lst_idx].selected_idx, 0, #collection)
	end
	local t = {}
	if multi_select then
		t = listbox_state[lst_idx].selection
	end
	return result, listbox_state[lst_idx].selected_idx, t
end

--[[@param name string]]
--[[@param width integer]]
--[[@param height integer]]
--[[@param tooltip? string]]
function ui2d.CustomWidget(name, width, height, tooltip)
	local cur_window = windows[begin_idx]
	local exists, idx = WidgetExists(cur_window, cur_window.id .. name)

	if not exists then
		local new_widget = {}
		new_widget.id = cur_window.id .. name
		new_widget.width = width
		new_widget.height = height
		new_widget.texture = framework.NewTexture(width, height)
		new_widget.pass = framework.NewPass(new_widget.texture)
		framework.SetProjection(new_widget.pass)
		table.insert(cur_window.cw, new_widget)
		idx = #cur_window.cw
	else
		if cur_window.cw[idx].width ~= width or cur_window.cw[idx].height ~= height then
			cur_window.cw[idx].width = width
			cur_window.cw[idx].height = height
			framework.ReleaseTexture()
			cur_window.cw[idx].texture = framework.NewTexture(width, height)
			framework.SetCanvas(cur_window.cw[idx].pass, cur_window.cw[idx].texture)
		end
	end

	local bbox = {}
	if layout.same_line then
		bbox = { x = layout.x + layout.w + margin, y = layout.y, w = width, h = height }
	elseif layout.same_column then
		bbox = { x = layout.x, y = layout.y + layout.h + margin, w = width, h = height }
	else
		bbox = { x = margin, y = layout.y + layout.row_h + margin, w = width, h = height }
	end

	UpdateLayout(bbox)

	local clicked = false
	local held = false
	local released = false
	local hovered = false
	local wheelx, wheely = 0, 0

	if not modal_window or (modal_window and modal_window == cur_window) then
		if PointInRect(mouse.x, mouse.y, bbox.x + cur_window.x, bbox.y + cur_window.y, bbox.w, bbox.h) and cur_window == active_window then
			if tooltip then
				active_tooltip.text = tooltip
				active_tooltip.x = mouse.x
				active_tooltip.y = mouse.y
			end
			hovered = true
			wheelx, wheely = mouse.wheel_x, mouse.wheel_y

			if mouse.state == e_mouse_state.clicked then
				clicked = true
				active_widget = cur_window.cw[idx]
			end
		end

		if mouse.state == e_mouse_state.held and cur_window == active_window and active_widget == cur_window.cw[idx] then
			held = true
		end
		if mouse.state == e_mouse_state.released and cur_window == active_window and active_widget == cur_window.cw[idx] then
			released = true
			active_widget = nil
		end
	end

	cur_window.cw[idx].bbox = bbox
	table.insert(windows[begin_idx].command_list, { type = "rect_wire", bbox = bbox, color = colors.button_border })
	framework.ResetPass(cur_window.cw[idx].pass)
	framework.SetProjection(cur_window.cw[idx].pass)
	return cur_window.cw[idx].pass, clicked, held, released, hovered, mouse.x - cur_window.x - bbox.x,
			mouse.y - cur_window.y - bbox.y, wheelx, wheely
end

--[[@param main_pass lovr_pass]]
function ui2d.RenderFrame(main_pass)
	assert(begin_end_pairs.b == begin_end_pairs.e,
		"Begin/End pairs don't match! Begin calls: " .. begin_end_pairs.b .. " - End calls: " .. begin_end_pairs.e)
	begin_end_pairs.b = 0
	begin_end_pairs.e = 0
	table.sort(windows, function(a, b) return a.z > b.z end)
	framework.SetCanvas()

	local count = #windows
	for i = count, 1, -1 do
		local win = windows[i]

		if win.was_called_this_frame then
			framework.SetColor(main_pass, { 1, 1, 1 })
			if modal_window and win ~= modal_window then
				framework.SetColor(main_pass, colors.modal_tint)
			end
			framework.SetMaterial(main_pass, win.texture)
			framework.DrawRect(main_pass, win.x + (win.w / 2), win.y + (win.h / 2), win.w, -win.h, "fill") --NOTE flip Y fix
			framework.SetMaterial(main_pass)
			for j, k in ipairs(windows[i].cw) do
				framework.SetColor(win.pass, { 1, 1, 1 })
				framework.SetMaterial(win.pass, k.texture)
				framework.DrawRect(win.pass, k.bbox.x + (k.bbox.w / 2), k.bbox.y + (k.bbox.h / 2), k.bbox.w, -k.bbox.h, "fill")
				framework.SetMaterial(win.pass)
				framework.SetColor(win.pass, { 1, 1, 1 })
			end
			if i == 1 and active_tooltip.text ~= "" then -- Draw tooltip
				local num_lines = GetLineCount(active_tooltip.text)
				local text_w = font.handle:getWidth(active_tooltip.text)
				local rect_x = active_tooltip.x + (text_w / 2) + font.h
				local rect_w = text_w + (2 * margin)
				local rect_h = (num_lines * font.h) + (2 * margin)
				local rect_y = active_tooltip.y - (rect_h / 2)
				local text_y = 0

				local text_x = active_tooltip.x + font.h
				text_y = rect_y - margin

				local width = lovr.system.getWindowDimensions()
				if mouse.x > width - rect_w - margin then
					rect_x = active_tooltip.x - (text_w / 2) - font.h
					text_x = active_tooltip.x - font.h - text_w
				end

				if mouse.y < rect_h then
					rect_y = active_tooltip.y + (rect_h / 2)
					text_y = active_tooltip.y + (font.h / 2)
				end

				framework.SetColor(main_pass, colors.tooltip_bg)
				framework.DrawRect(main_pass, rect_x, rect_y, rect_w, rect_h, "fill")
				framework.SetColor(main_pass, colors.tooltip_border)
				framework.DrawRect(main_pass, rect_x, rect_y, rect_w, rect_h, "line")

				framework.SetColor(main_pass, colors.text)
				framework.SetFont(main_pass)
				framework.DrawText(main_pass, active_tooltip.text, text_x, text_y, text_w, font.h, text_w)
				active_tooltip.text = ""
			end
		else
			table.remove(windows, i)
		end
	end

	mouse.wheel_x = 0
	mouse.wheel_y = 0

	text_input_character = nil
	local passes = {}

	for _, v in ipairs(windows) do
		v.command_list = nil
		v.command_list = {}
		v.was_called_this_frame = false

		for _, k in ipairs(v.cw) do
			table.insert(passes, k.pass)
		end
		table.insert(passes, v.pass)
	end

	return passes
end

return ui2d

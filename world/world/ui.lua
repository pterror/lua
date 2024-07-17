local mod = {}

--[[@param parts string[] ]]
local join_with_blank = function(parts) return table.concat(parts, "") end
--[[@param parts string[] ]]
local join_with_space = function(parts) return table.concat(parts, " ") end
--[[@param parts string[] ]]
local join_with_newline = function(parts) return table.concat(parts, "\n") end
--[[@param parts string[] ]]
local bullet_points = function(parts)
	if #parts == 0 then return "" end
	return " - " .. table.concat(parts, "\n - ")
end
--[[@param parts string[] ]]
local numbered_points = function(parts)
	local transformed_parts = {}
	local pad_len = #tostring(#parts) + 1
	for i = 1, #parts do
		local i_s = tostring(i)
		transformed_parts[i] = (" "):rep(pad_len - #i_s) .. i_s .. ". " .. parts[i]
	end
	return table.concat(transformed_parts, "\n")
end

mod.plain_text = {}
local plain_text_ui = mod.plain_text
plain_text_ui.container = join_with_newline
plain_text_ui.paragraph = join_with_space
plain_text_ui.phrase = join_with_blank
plain_text_ui.list = bullet_points
plain_text_ui.numbered_list = numbered_points
plain_text_ui.sentence = join_with_blank
plain_text_ui.color = join_with_blank
plain_text_ui.background_color = join_with_blank

--[[ansi support for 8/16/256 colors can come later, quantization is hard]]
mod.ansi = {}
local ansi_ui = mod.ansi
ansi_ui.container = join_with_newline
ansi_ui.paragraph = join_with_space
ansi_ui.phrase = join_with_blank
ansi_ui.list = bullet_points
ansi_ui.numbered_list = numbered_points
ansi_ui.sentence = join_with_blank
local truecolor_foreground_colorspace_processor = {}
truecolor_foreground_colorspace_processor.rgb = function(t)
	return "\x1b[38;2;" ..
			math.floor(t.red or 0) .. ";" .. math.floor(t.green or 0) .. ";" .. math.floor(t.blue or 0) .. "m"
end
ansi_ui.color = function(table)
	local text = join_with_blank(table)
	local processor = truecolor_foreground_colorspace_processor[table.space]
	if processor and table.color then
		--[[TODO: keep a stack of formatting info, when an inner `color` ends the outer `color` (and background_color) should still apply]]
		text = processor(table.color) .. text .. "\x1b[0m"
	end
	return text
end
local truecolor_background_colorspace_processor = {}
truecolor_background_colorspace_processor.rgb = function(t)
	return "\x1b[48;2;" ..
			math.floor(t.red or 0) .. ";" .. math.floor(t.green or 0) .. ";" .. math.floor(t.blue or 0) .. "m"
end
ansi_ui.background_color = function(table)
	local text = join_with_blank(table)
	local processor = truecolor_background_colorspace_processor[table.space]
	if processor and table.color then
		text = processor(table.color) .. text .. "\x1b[0m"
	end
	return text
end

--[[needs http and/or ws server to actually work since it needs to connect to the lua process]]
local add_html_list_items = function(parts, acc)
	local offset = #acc
	for i = 1, #parts do
		acc[i + offset] = "<li>" .. parts[i] .. "</li>"
	end
end
mod.html = {}
local html_ui = mod.html
html_ui.container = function(parts) return "<div>" .. table.concat(parts, "\n") .. "</div>" end
html_ui.paragraph = function(parts) return "<p>" .. table.concat(parts, " ") .. "</p>" end
html_ui.phrase = join_with_blank
html_ui.list = function(parts)
	local transformed_parts = { "<ul>" }
	add_html_list_items(parts, transformed_parts)
	transformed_parts[#transformed_parts + 1] = "</ul>"
	return table.concat(transformed_parts, "\n")
end
html_ui.numbered_list = function(parts)
	local transformed_parts = { "<ol>" }
	add_html_list_items(parts, transformed_parts)
	transformed_parts[#transformed_parts + 1] = "</ol>"
	return table.concat(transformed_parts, "\n")
end
html_ui.sentence = join_with_blank
local css_colorspace_processor = {}
local css_colorspace_alpha = function(alpha)
	if not alpha or alpha == 1 then return "" end
	return " / " .. alpha
end
css_colorspace_processor.rgb = function(t)
	return "rgb(" ..
			(t.red or 0) .. " " .. (t.green or 0) .. " " .. (t.blue or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.lch = function(t)
	return "lch(" ..
			(t.lightness or 0) .. " " .. (t.chroma or 0) .. " " .. (t.hue or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.lab = function(t)
	return "lab(" ..
			(t.lightness or 0) .. " " .. (t.a or 0) .. " " .. (t.b or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.oklch = function(t)
	return "oklch(" ..
			(t.lightness or 0) .. " " .. (t.chroma or 0) .. " " .. (t.hue or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.oklab = function(t)
	return "oklab(" ..
			(t.lightness or 0) .. " " .. (t.a or 0) .. " " .. (t.b or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.hsl = function(t)
	return "hwb(" ..
			(t.hue or 0) .. " " .. (t.saturation or 0) .. " " .. (t.lightness or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
css_colorspace_processor.hwb = function(t)
	return "hwb(" ..
			(t.hue or 0) .. " " .. (t.whiteness or 0) .. " " .. (t.blackness or 0) .. css_colorspace_alpha(t.alpha) .. ")"
end
html_ui.color = function(table)
	local text = join_with_blank(table)
	local processor = css_colorspace_processor[table.space]
	if processor and table.color then
		text = "<span style=\"color: " .. processor(table.color) .. "\">" .. text .. "</span>"
	end
	return text
end
html_ui.background_color = function(table)
	local text = join_with_blank(table)
	local processor = css_colorspace_processor[table.space]
	if processor and table.color then
		text = "<span style=\"background-color: " .. processor(table.color) .. "\">" .. text .. "</span>"
	end
	return text
end

return mod

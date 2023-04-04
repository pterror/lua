local element = require("dep.tinytui").element
local write = io.write
local rep = string.rep

local mod = {}

local frame_styles = {}
mod.frame_styles = frame_styles
frame_styles.ascii = {
	{ "+", "-", "+" },
	{ "|", nil, "|" },
	{ "+", "-", "+" },
}
frame_styles.normal = {
	{ "┌", "─", "┐" },
	{ "│", nil, "│" },
	{ "└", "─", "┘" },
}
frame_styles.curved = {
	{ "╭", "─", "╮" },
	{ "│", nil, "│" },
	{ "╰", "─", "╯" },
}
frame_styles.bold = {
	{ "┏", "━", "┓" },
	{ "┃", nil, "┃" },
	{ "┗", "━", "┛" },
}
frame_styles.double = {
	{ "╔", "═", "╗" },
	{ "║", nil, "║" },
	{ "╚", "═", "╝" },
}
-- TODO: merging frames

--- @class frame: element
local frame = element:new()
mod.frame = frame
--- @type { [1]: { [1]: string, [2]: string, [3]: string }, [2]: { [1]: string, [2]: nil, [3]: string }, [3]: { [1]: string, [2]: string, [3]: string } }
frame.characters = frame_styles.normal
--- @param cursor cursor
frame.render = function (self, cursor)
	local chars = self.characters
	local left = self.x
	local right = self.x + self.width - 1
	cursor:move(self.x, self.y)
	write(chars[1][1], rep(chars[1][2], self.width - 2), chars[1][3])
	local left_border = chars[2][1]
	local right_border = chars[2][3]
	for y = self.y + 1, self.y + self.height - 2 do
		cursor:move(left, y)
		write(left_border)
		cursor:move(right, y)
		write(right_border)
	end
	cursor:move(self.x, self.y + self.height - 1)
	write(chars[3][1], rep(chars[3][2], self.width - 2), chars[3][3])
end

--- @class progress_bar: element
local progress_bar = element:new()
mod.frameprogress_bar = progress_bar
progress_bar.characters = {
	{ "+", "-", "+" },
	{ "|", nil, "|" },
	{ "+", "-", "+" },
}

return mod

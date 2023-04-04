--[[
Copyright (c) 2020 Phil Leblanc

Permission is hereby granted, free of charge, to any person 
obtaining a copy of this software and associated documentation 
files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, 
publish, distribute, sublicense, and/or sell copies of the Software, 
and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be 
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

--[[
plterm - Pure Lua ANSI Terminal functions - unix only
https://github.com/philanc/plterm - License: MIT

This module assumes that 
	- the terminal supports the common ANSI sequences,
	- the current tty encoding is UTF-8,
	- the unix command "stty" is available (it is used to save 
		and restore the tty mode and set the tty in raw mode).

Module functions:

clear()     -- clear screen
cleareol()  -- clear to end of line
golc(l, c)  -- move the cursor to line l, column c
up(n)
down(n)
right(n)
left(n)     -- move the cursor by n positions (default to 1)
color(f, b, m)
						-- change the color used to write characters
		(foreground color, background color, modifier)
		see term.colors
hide()
show()      -- hide or show the cursor
save()
restore()   -- save and restore the position of the cursor
reset()     -- reset the terminal (colors, cursor position)

input()     -- input iterator (coroutine-based)
								return a "next key" function that can be iteratively
								called to read a key (UTF8 sequences and escape 
								sequences returned by function keys are parsed)
rawinput()  -- same, but UTF8 and escape sequences are not parsed.
getcurpos() -- return the current position of the cursor
getscrlc()  -- return the dimensions of the screen
								(number of lines and columns)
keyname()   -- return a printable name for any key
		- key names in term.keys for function keys,
		- control characters are represented as "^A"
		- the character itself for other keys

tty mode management functions

setrawmode()       -- set the terminal in raw mode
setsanemode()      -- set the terminal in a default "sane mode"
savemode()         -- get the current mode as a string
restoremode(mode)  -- restore a mode saved by savemode()

License: BSD
https://github.com/philanc/plterm

-- just in case, a good ref on ANSI esc sequences:
https://en.wikipedia.org/wiki/ANSI_escape_code
(in the text, "CSI" is "<esc>[")
]]

-- copied from: https://github.com/philanc/plterm/commit/10980b8db506f0a4e858935820637d20226322b2

local ffi = require("ffi")

local lshift = bit.lshift; local rshift = bit.rshift; local bor = bit.bor; local band = bit.band; local bnot = bit.bnot
local byte = string.byte; local char = string.char
local write = io.write; local read = io.read; local flush = io.flush
local yield = coroutine.yield

--[[write arguments to stdout, then flush.]]
local outf = function (...) write(...); flush() end

-- following definitions (from term.clear to term.restore) are
-- based on public domain code by Luiz Henrique de Figueiredo
-- http://lua-users.org/lists/lua-l/2009-12/msg00942.html

local mod = { -- the plterm module
	out = write,
	outf = outf,
	clear = function () write("\027[2J") end,
	cleareol = function () write("\027[K") end,
	golc = function (l, c) write("\027[",l,";",c,"H") end,
	up = function (n) write("\027[",n or 1,"A") end,
	down = function (n) write("\027[",n or 1,"B") end,
	right = function (n) write("\027[",n or 1,"C") end,
	left = function (n) write("\027[",n or 1,"D") end,
	color = function (f, b, m)
		if m then write("\027[",f,";",b,";",m,"m")
		elseif b then write("\027[",f,";",b,"m")
		else write("\027[",f,"m") end
	end,
	hide = function () write("\027[?25l") end, --[[hide cursor]]
	show = function () write("\027[?25h") end, --[[show cursor]]
	save = function () write("\027[s") end, --[[save cursor position]]
	restore = function () write("\027[u") end, --[[restore cursor position]]
	reset = function () write("\027c") end, --[[clear terminal and reset default colors]]
	enteraltscreen = function () write("\x1b[?1049h\x1b[22;0;0t") end, --[[enter alternate screen]]
	exitaltscreen = function () write("\x1b[?1049l\x1b[23;0;0t") end, --[[exit alternate screen]]
}

mod.colors = {
	default = 0,
	-- foreground colors
	black = 30, red = 31, green = 32, yellow = 33,
	blue = 34, magenta = 35, cyan = 36, white = 37,
	-- backgroud colors
	bgblack = 40, bgred = 41, bggreen = 42, bgyellow = 43,
	bgblue = 44, bgmagenta = 45, bgcyan = 46, bgwhite = 47,
	-- attributes
	reset = 0, normal= 0, bright= 1, bold = 1, reverse = 7,
}

-- key input

mod.keys = {
	unknown = 0x10000, esc = 0x1b, del = 0x7f,
	kf1 = 0xffff, kf2 = 0xfffe, kf3 = 0xfffd, kf4 = 0xfffc, kf5 = 0xfffb, kf6 = 0xfffa,
	kf7 = 0xfff9, kf8 = 0xfff8, kf9 = 0xfff7, kf10 = 0xfff6, kf11 = 0xfff5, kf12 = 0xfff4,
	kins  = 0xfff3, kdel  = 0xfff2, khome = 0xfff1, kend  = 0xfff0, kpgup = 0xffef, kpgdn = 0xffee,
	kup   = 0xffed, kdown = 0xffec, kleft = 0xffeb, kright = 0xffea,
}
mod.keys_rev = {}
for k, v in pairs(mod.keys) do mod.keys_rev[v] = k end

local keys = mod.keys; local keys_rev = mod.keys_rev

-- special chars (for parsing esc sequences)
local ESC = 27; local LETO = 79; local LBR = 91; local TIL = 126  -- esc, O, [, ~

-- return true if c is the code of a digit or `;`
local isdigitsc = function (c) return (c >= 48 and c < 58) or c == 59 end

-- ansi sequence lookup table
local seq = {
	["[A"] = keys.kup,
	["[B"] = keys.kdown,
	["[C"] = keys.kright,
	["[D"] = keys.kleft,

	["[2~"] = keys.kins,
	["[3~"] = keys.kdel,
	["[5~"] = keys.kpgup,
	["[6~"] = keys.kpgdn,
	["[7~"] = keys.khome,  -- rxvt
	["[8~"] = keys.kend,   -- rxvt
	["[1~"] = keys.khome,  -- linux
	["[4~"] = keys.kend,   -- linux
	["[11~"] = keys.kf1,
	["[12~"] = keys.kf2,
	["[13~"] = keys.kf3,
	["[14~"] = keys.kf4,
	["[15~"] = keys.kf5,
	["[17~"] = keys.kf6,
	["[18~"] = keys.kf7,
	["[19~"] = keys.kf8,
	["[20~"] = keys.kf9,
	["[21~"] = keys.kf10,
	["[23~"] = keys.kf11,
	["[24~"] = keys.kf12,

	["OP"] = keys.kf1,   -- xterm
	["OQ"] = keys.kf2,   -- xterm
	["OR"] = keys.kf3,   -- xterm
	["OS"] = keys.kf4,   -- xterm
	["[H"] = keys.khome, -- xterm
	["[F"] = keys.kend,  -- xterm

	["[[A"] = keys.kf1,  -- linux
	["[[B"] = keys.kf2,  -- linux
	["[[C"] = keys.kf3,  -- linux
	["[[D"] = keys.kf4,  -- linux
	["[[E"] = keys.kf5,  -- linux

	["OH"] = keys.khome, -- vte
	["OF"] = keys.kend,  -- vte

}

local getcode = function () return byte(read(1)) end

mod.input = function ()
	-- return a "read next key" function that can be used in a loop
	-- the "next" function blocks until a key is read
	-- it returns ascii or unicode code for all regular keys, 
	-- or a key code for special keys (see term.keys)
	return coroutine.wrap(function()
		local c, c1, c2, ci, s, u
		while true do
		c = getcode()
		::restart::
		if band(c, 0xc0) == 0xc0 then
			-- utf8 sequence start
			if band(c, 0x20) == 0 then -- 2-byte seq
				u = band(c, 0x1f)
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				yield(u)
				goto continue
			elseif band(c, 0xf0) == 0xe0 then -- 3-byte seq
				u = band(c, 0x0f)
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				yield(u)
				goto continue
			else -- assume it is a 4-byte seq
				u = band(c, 0x07)
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				u = bor(lshift(u, 6), band(getcode(), 0x3f))
				yield(u)
				goto continue
			end
		end -- end utf8 sequence. continue with c.
		if c ~= ESC then -- not an esc sequence, yield c
			yield(c)
			goto continue
		end
		c1 = getcode()
		if c1 == ESC then -- esc esc [ ... sequence
			yield(ESC)
			-- here c still contains ESC, read a new c1
			c1 = getcode() -- and carry on ...
		end
		if c1 ~= LBR and c1 ~= LETO then -- not a valid seq
			-- c1 maybe the beginning of an utf8 seq...
			yield(c); c = c1; goto restart
		end
		c2 = getcode()
		s = char(c1, c2)
		if c2 == LBR then -- esc[[x sequences (F1-F5 in linux console)
			s = s .. char(getcode())
		end
		if seq[s] then
			yield(seq[s])
			goto continue
		end
		if not isdigitsc(c2) then
			yield(c); yield(c1); yield(c2)
			goto continue
		end
		while true do -- read until tilde "~"
			ci = getcode()
			s = s .. char(ci)
			if ci == TIL then
				if seq[s] then
					yield(seq[s])
					goto continue
				else
					-- valid but unknown sequence
					-- ignore it
					yield(keys.unknown)
					goto continue
				end
			end
			if not isdigitsc(ci) then
				-- not a valid seq. 
				-- return all the chars
				yield(ESC)
				for i = 1, #s do yield(byte(s, i)) end
				goto continue
			end
		end
		::continue::
		end
	end)
end

mod.rawinput = function ()
	-- return a "read next key" function that can be used in a loop
	-- the "next" function blocks until a key is read
	-- it returns ascii code for all keys
	-- (this function assume the tty is already in raw mode)
	return coroutine.wrap(function()
		local c
		while true do
			c = getcode()
			yield(c)
		end
	end)
end

mod.getcurpos = function ()
	-- return current cursor position (line, column as integers)
	outf("\027[6n") -- report cursor position. answer: esc[n;mR
	local i = 0
	local c = nil
	local s = ""
	c = getcode()
	if c ~= ESC then return nil end
	c = getcode()
	if c ~= LBR then return nil end
	while true do
		i = i + 1
		if i > 8 then return nil end
		c = getcode()
		if c == byte("R") then break end
		s = s .. char(c)
	end
	-- here s should be n;m
	local n, m = s:match("(%d+);(%d+)")
	if not n then return nil end
	return tonumber(n), tonumber(m)
end

mod.getscrlc = function ()
	-- return current screen dimensions (line, coloumn as integers)
	mod.save()
	mod.down(999)
	mod.right(999)
	local l, c = mod.getcurpos()
	mod.restore()
	return l, c
end

mod.keyname = function (c)
	local rev = keys_rev[c]
	if rev then return rev end
	if c < 32 then return "^" .. char(c+64) end
	-- FIXME: wrong directionlmao
	-- copied from above
		if c <= 0x7f then return char(c)
		elseif c <= 0x7ff then return char(bor(0xc0, rshift(c, 6)), band(c, 0x3f))
		elseif c <= 0xffff then return char(bor(0xe0, rshift(c, 12)), bor(0x80, band(rshift(c, 6), 0x3f)), band(c, 0x3f))
		else return char(bor(0xf0, rshift(c, 18)), bor(0x80, band(rshift(c, 12), 0x3f)), bor(0x80, band(rshift(c, 6), 0x3f)), band(c, 0x3f)) end
end

if ffi.os == "Linux" then
	ffi.cdef [[
		typedef unsigned char cc_t;
		typedef unsigned int speed_t;
		typedef unsigned int tcflag_t;
		// https://elixir.bootlin.com/glibc/latest/source/bits/termios.h
		struct termios {
			tcflag_t c_iflag;
			tcflag_t c_oflag;
			tcflag_t c_cflag;
			tcflag_t c_lflag;
			cc_t c_line;
			cc_t c_cc[32];
			speed_t __ispeed, __ospeed;
		};

		int tcgetattr(int fd, struct termios *termios_p);
		int tcsetattr(int fd, int optional_actions, const struct termios *termios_p);
	]]
	-- glibc bits: https://elixir.bootlin.com/glibc/latest/source/bits/termios.h#L110
	-- linux-specific bits: https://elixir.bootlin.com/linux/latest/source/include/uapi/asm-generic/termbits.h#L60
	local VMIN = 16; local VTIME = 17
	local ib = {} local ob = {}; local cb = {}; local lb = {}
	local im = {}; local om = {}; local cm = {}; local lm = {}
	-- input modes
	ib.IGNBRK, ib.BRKINT, ib.IGNPAR, ib.PARMRK, ib.INPCK, ib.ISTRIP, ib.INLCR, ib.IGNCR, ib.ICRNL, ib.IXANY = 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x800
	im.MIGNBRK, im.MBRKINT, im.MIGNPAR, im.MPARMRK, im.MINPCK, im.MISTRIP, im.MINLCR, im.MIGNCR, im.MICRNL, im.MIXANY = bnot(ib.IGNBRK), bnot(ib.BRKINT), bnot(ib.IGNPAR), bnot(ib.PARMRK), bnot(ib.INPCK), bnot(ib.ISTRIP), bnot(ib.INLCR), bnot(ib.IGNCR), bnot(ib.ICRNL), bnot(ib.IXANY)
	-- linux bits
	ib.IUCLC, ib.IXON, ib.IXOFF, ib.IMAXBEL, ib.IUTF8 = 0x200, 0x400, 0x1000, 0x2000, 0x4000
	im.MIUCLC, im.MIXON, im.MIXOFF, im.MIMAXBEL, im.MIUTF8 = bnot(ib.IUCLC), bnot(ib.IXON), bnot(ib.IXOFF), bnot(ib.IMAXBEL), bnot(ib.IUTF8)
	-- output modes (linux specific probably)
	ob.OPOST, ob.OLCUC, ob.ONLCR, ob.OCRNL, ob.ONOCR, ob.ONLRET, ob.OFILL, ob.OFDEL = 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80
	om.MOPOST, om.MOLCUC, om.MONLCR, om.MOCRNL, om.MONOCR, om.MONLRET, om.MOFILL, om.MOFDEL = bnot(ob.OPOST), bnot(ob.OLCUC), bnot(ob.ONLCR), bnot(ob.OCRNL), bnot(ob.ONOCR), bnot(ob.ONLRET), bnot(ob.OFILL), bnot(ob.OFDEL)
	-- delays (also output modes)
	ob.NL0, ob.NL1 = 0, 0x100
	om.MNL = bnot(bor(ob.NL0, ob.NL1)) -- aka NLDLY
	ob.CR0, ob.CR1, ob.CR2, ob.CR3 = 0, 0x200, 0x400, 0x600
	om.MCR = bnot(bor(ob.CR0, ob.CR1, ob.CR2, ob.CR3))
	ob.TAB0, ob.TAB1, ob.TAB2, ob.TAB3 = 0, 0x800, 0x1000, 0x1800
	om.MTAB = bnot(bor(ob.TAB0, ob.TAB1, ob.TAB2, ob.TAB3))
	ob.TABS, om.MTABS = ob.TAB3, om.MTAB
	ob.BS0, ob.BS1 = 0, 0x2000
	om.MBS = bnot(bor(ob.BS0, ob.BS1))
	ob.VT0, ob.VT1 = 0, 0x4000
	om.MVT = bnot(bor(ob.VT0, ob.VT1))
	ob.FF0, ob.FF1 = 0, 0x8000
	om.MFF = bnot(bor(ob.FF0, ob.FF1))
	-- local modes (all redefined by linux)
	lb.ECHO, lb.ECHOE, lb.ECHOK, lb.ECHONL, lb.ECHOCTL, lb.ECHOPRT, lb.ECHOKE = 0x8, 0x10, 0x20, 0x40, 0x200, 0x400, 0x800
	lm.MECHO, lm.MECHOE, lm.MECHOK, lm.MECHONL, lm.MECHOCTL, lm.MECHOPRT, lm.MECHOKE = bnot(lb.ECHO), bnot(lb.ECHOE), bnot(lb.ECHOK), bnot(lb.ECHONL), bnot(lb.ECHOCTL), bnot(lb.ECHOPRT), bnot(lb.ECHOKE)
	lb.ISIG, lb.ICANON, lb.TOSTOP, lb.IEXTEN, lb.FLUSHO, lb.EXTPROC = 0x1, 0x2, 0x100, 0x1000, 0x8000, 0x10000
	lm.MISIG, lm.MICANON, lm.MTOSTOP, lm.MIEXTEN, lm.MFLUSHO, lm.MEXTPROC = bnot(lb.ISIG), bnot(lb.ICANON), bnot(lb.TOSTOP), bnot(lb.IEXTEN), bnot(lb.FLUSHO), bnot(lb.EXTPROC)
	lb.XCASE, lb.NOFLSH = 0x4, 0x80
	lm.MXCASE, lm.MNOFLSH = bnot(lb.XCASE), bnot(lb.NOFLSH)
	local sane_imask = band(
		im.MIGNBRK, im.MBRKINT, im.MINLCR, im.MIGNCR, im.MICRNL, im.MIXANY,
		im.MIMAXBEL, im.MIXOFF, im.MIUTF8, im.MIUCLC
	)
	local sane_omask = band(
		om.MOLCUC, om.MOCRNL, om.MOPOST, om.MOFILL, om.MONLCR, om.MONOCR, om.MONLRET, om.MOFDEL,
		om.MNL, om.MCR, om.MTAB, om.MBS, om.MVT, om.MFF
	)
	local sane_lmask = band(
		lm.MXCASE, lm.MICANON, lm.MIEXTEN,
		lm.MECHO, lm.MECHOE, lm.MECHOK, lm.MECHOKE, lm.MECHOCTL, lm.MECHOPRT, lm.MECHONL,
		lm.MNOFLSH, lm.MISIG, lm.MTOSTOP, lm.MEXTPROC, lm.MFLUSHO
	)
	local sane_ibits = bor(ib.BRKINT, ib.ICRNL, ib.IMAXBEL)
	local sane_obits = bor(
		ob.OPOST, ob.ONLCR,
		ob.NL0, ob.CR0, ob.TAB0, ob.BS0, ob.VT0, ob.FF0
	)
	local sane_lbits = bor(
		lb.ECHO, lb.ECHOE, lb.ECHOK, lb.ECHOKE, lb.ECHOCTL,
		lb.ICANON, lb.IEXTEN, lb.ISIG
	)
	-- -ignbrk -brkint -ignpar -parmrk -inpck -istrip
	-- -inlcr -igncr -icrnl -ixon -ixoff -icanon -opost -isig
	-- -iuclc -ixany -imaxbel -xcase
	local raw_imask = band(
		im.MIGNBRK, im.MBRKINT, im.MIGNPAR, im.MPARMRK, im.MINPCK, im.MISTRIP,
		im.MINLCR, im.MIGNCR, im.MICRNL, im.MIXON, im.MIXOFF, im.MIUCLC, im.MIXANY, im.MIMAXBEL
	)
	local raw_omask = om.MOPOST
	local raw_lmask = band(lm.MICANON, lm.MISIG, lm.MXCASE)
	local raw_ibits = 0
	local raw_obits = 0
	local raw_lbits = 0
	--[[@class fd_c]]
	--[[@class termios_c]]
	--[[@field c_iflag integer]]
	--[[@field c_oflag integer]]
	--[[@field c_cflag integer]]
	--[[@field c_lflag integer]]
	--[[@field c_line integer]]
	--[[@field c_cc integer[] ]]
	--[[@field __ispeed integer]]
	--[[@field __ospeed integer]]
	--[[@class plterm_termios_c]]
	--[[@field tcgetattr fun(fd: fd_c, termios_p: { [0]: termios_c })]]
	--[[@field tcsetattr fun(fd: fd_c, optional_actions: integer, termios_p: { [0]: termios_c })]]
	--[[@type plterm_termios_c]]
	local termios = ffi.C
	--[[@type fun(): { [0]: termios_c }]]
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	local struct_termios = ffi.typeof("struct termios[1]")
	--[[@type fd_c]]
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	local stdin_fd = 0
	mod.setrawmode = function ()
		local mode = struct_termios()
		termios.tcgetattr(stdin_fd, mode)
		mode[0].c_iflag = bor(band(mode[0].c_iflag, raw_imask), raw_ibits)
		mode[0].c_oflag = bor(band(mode[0].c_oflag, raw_omask), raw_obits)
		mode[0].c_lflag = bor(band(mode[0].c_lflag, raw_lmask, lm.MECHO), raw_lbits)
		mode[0].c_cc[VMIN] = 1
		mode[0].c_cc[VTIME] = 0
		termios.tcsetattr(stdin_fd, 0 --[[TCSANOW]], mode)
	end
	mod.setsanemode = function ()
		local mode = struct_termios()
		termios.tcgetattr(stdin_fd, mode)
		mode[0].c_iflag = bor(band(mode[0].c_iflag, sane_imask), sane_ibits)
		mode[0].c_oflag = bor(band(mode[0].c_oflag, sane_omask), sane_obits)
		mode[0].c_lflag = bor(band(mode[0].c_lflag, sane_lmask), sane_lbits)
		-- TODO: all special characters to their default values
		termios.tcsetattr(stdin_fd, 0 --[[TCSANOW]], mode)
	end
	mod.savemode = function ()
		local mode = struct_termios()
		termios.tcgetattr(stdin_fd, mode)
		return mode
	end
	mod.restoremode = function (mode)
		termios.tcsetattr(stdin_fd, 0 --[[TCSANOW]], mode)
	end
end

return mod

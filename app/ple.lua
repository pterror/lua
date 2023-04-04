#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[
Copyright (c) 2016 Phil Leblanc

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

--[[  ple - a Pure Lua Editor
https://github.com/philanc/ple - License: MIT

editor actions:  see table editor.action
key bindings:  see table editor.bindings

configuration:
The editor can be customized with a Lua file loaded at initialization.
The configuration file is looked for in sequence at the following locations:
	- the file which pathname is in the environment variable PLE_INIT
	- ./ple_init.lua
	- ~/.config/ple/ple_init.lua
The first file found, if any, is loaded.
]]

-- https://github.com/philanc/ple/commit/f30a416c0ae81356cd136c74b4e5967db5e06b17
-- FIXME: e.killeol and e.test are missing

-- some local definitions (used by the module term and/or by the editor

local utf8 = require("dep.utf8")
local ulen = utf8.len; local uoff = utf8.offset; local uchar = utf8.char; local ucodes = utf8.codes
local format = string.format; local char = string.char; local rep = string.rep; local gmatch = string.gmatch
local sub = string.sub
local max = math.max

local pad = function (s, w) -- pad a string to fit width w
	if #s >= w then return sub(s, 1, w) else return s .. rep(" ", w-#s) end
end

--[[split s into a list of lines]]
local lines = function (s)
	local lt = {}
	s = s .. "\n"
	for l in gmatch(s, "(.-)\r?\n") do table.insert(lt, l) end
	return lt
end

--[[read file with filename `fn` as a list of lines]]
local readfile = function (fn)
	local fh, errm = io.open(fn)
	if not fh then return nil, errm end
	local ll = {}
	for l in fh:lines() do
		if not ulen(l) then
			return nil, "File error: invalid UTF8 sequence"
		end
		table.insert(ll, l)
	end
	fh:close()
	-- ensure the list has at least an empty line
	if #ll == 0 then table.insert(ll, "") end
	return ll
end

--[[check whether file `fn` exists and can be read. return `true` or `nil`]]
local fileexists = function (fn)
	if not fn then return nil end
	local fh = io.open(fn)
	if not fh then return nil end
	fh:close()
	return true
end

local term = require("dep.plterm") -- WARN: unix only
local buffer = require("dep.plbuffer")

-- EDITOR

-- some local definitions

local go = term.golc; local cleareol = term.cleareol; local color = term.color; local out = term.out
local outf = term.outf; local colors = term.colors; local keys = term.keys
local flush = io.flush

-- global objects and constants

local MAX = buffer.MAX

local tabln = 8
local EOT = "~"   -- used to indicate that we are past the end of text
local NDC = uchar(0xfffd) -- indicates a non-displayable character
local EOL = uchar(0xbb)   -- (Right-pointing Double Angle Quotation Mark)
			-- indicates that the line is longer than what is displayed

-- editor is the global editor object
--[[@diagnostic disable-next-line: lowercase-global]]
editor = {
	quit = false, -- set editor.quit to true to quit editor_loop()
	nextk = term.input(), -- the "read next key" function
	keyname = term.keyname, -- return the displayable name of a key
	buflist = {},  -- list of buffers
	bufindex = 0,  -- index of current buffer
}

-- buf is the current buffer
-- this is the same object as editor.buflist[editor.bufindex]
editor.buf = {}

-- style functions

editor.style = {
	normal = function () color(colors.normal) end,
	status = function () color(colors.red, colors.bold) end,
	msg = function () color(colors.normal); color(colors.green) end,
	sel = function () color(colors.magenta, colors.bold) end,
	bckg = function () color(colors.black, colors.bgyellow) end,
}
local style = editor.style

-- dialog functions

editor.msg = function (m)
	-- display a message m on last screen line
	m = pad(m, editor.scrc)
	go(editor.scrl, 1); cleareol(); style.msg()
	out(m); style.normal(); flush()
end

editor.readstr = function (prompt)
	-- display prompt, read a string on the last screen line
	-- [read only utf8 printable chars - no tab or other control-chars]
	-- [ no edition except bksp ]
	-- if ^G then return nil
	local s = ""
	editor.msg(prompt)
	while true do
		-- display s
		go(editor.scrl, ulen(prompt)+1)cleareol(); outf(s)
		local k = editor.nextk()
		-- ignore ctrl-chars and function keys
		if k == 8 or k == keys.del then -- backspace
			if ulen(s) > 0 then
				s = sub(s, 1, uoff(s, -1) - 1)
			end
		elseif k == 13 then return s  -- return
		elseif k == 7 then return nil -- ^G - abort
		elseif (k >= 32 and k < 0xffea) or (k > 0xffff) then
			s = s .. uchar(k)
		else -- ignore all other keys
		end
	end
end

editor.readchar = function (prompt, charpat)
	-- display prompt on the last screen line, read a char
	-- if ^G then return nil
	-- return the key as a char only if it matches charpat
	-- ignore all non printable ascii keys and non matching chars
	editor.msg(prompt)
	editor.redisplay(editor.buf) -- ensure cursor stays in buf
	while true do
		local k = editor.nextk()
		if k == 7 then return nil end -- ^G - abort
--~     if (k < 127) then
--~       local ch = char(k)
--~       if ch:match(charpat) then return ch end
--~     end

		local ch = uchar(k)
		if ch:match(charpat) then return ch end
		-- ignore all other keys
	end
end --readkey

editor.status = function (m)
	-- display a status string on top screen line
	m = pad(m, editor.scrc)
	go(1, 1); cleareol(); style.status()
	out(m); style.normal(); flush()
end

local dbgs = ""
editor.dbg = function (s) dbgs = s or "" end


editor.statusline = function ()
	local s = format("cur=%d,%d ", editor.buf.ci, editor.buf.cj)
	if editor.buf.si then s = s .. format("sel=%d,%d ", editor.buf.si, editor.buf.sj) end
	return s .. format(
		"[%s] (%s) %s -- Help: ^X^H -- %s",
		editor.buf.filename or "unnamed",
		editor.buf.unsaved and "*" or "",
		editor.tabspaces and "SP" or "TAB",
		dbgs
	)
end

-- screen display functions  (boxes, line display)

local boxnew = function (x, y, l, c)
	-- a box is a rectangular area on the screen
	-- defined by top left corner (`x`, `y`)
	-- and number of lines and columns (`l`, `c`)
	-- `clrl` is a full row of spaces used to clear box content
	return { x = x, y = y, l = l, c = c, clrl = rep(" ", c) }
end

local boxfill = function (b, ch, stylefn)
	local filler = rep(ch, b.c)
	stylefn()
	for i = 1, b.l do go(b.x+i-1, b.y); out(filler) end
	style.normal() -- back to normal style
	flush()
end

-- line display

local ccrepr = function (b, j)
	-- return display representation of unicode char with code b
	-- at line offset j (j is used for tabs)
	if b == 9 then return rep(" ", tabln - j % tabln)
	elseif b < 32 then return NDC
	else return uchar(b) end
end

local boxline = function (b, hs, bl, l, insel, jon, joff)
	-- display line l at the bl-th line of box b,
	-- with horizontal scroll hs
	-- if s is too long for the box, return the
	-- index of the first undisplayed char in l
	-- insel: true if line start is in the selection
	-- jon: if defined and not insel, position of beg of selection
	-- joff: if defined, position of end of selection
	assert(ulen(l), "invalid UTF8 sequence")
	local bc = b.c
	local cc = 0 --curent col in box
	-- clear line (don't use cleareol - box maybe smaller than screen)
	go(b.x+bl-1, b.y); out(b.clrl)
	go(b.x+bl-1, b.y)
	if insel then style.sel() end
	local j = 0
	for _, uc in ucodes(l) do
		-- j = char position in line, p = byte position in string
		j = j + 1
		if (not insel) and j == jon then
			style.sel(); insel=true
		end
		if insel and j == joff then
			style.normal()
		end
		local chs = ccrepr(uc, cc)
		cc = cc + ulen(chs)
		if cc >= bc + hs then
			go(b.x+bl-1, b.y+b.c-1)
			outf(EOL)
			style.normal()
			return j -- index of first undisplayed char in s
		end
		if cc > hs then out(chs) end
	end
	style.normal()
end --boxline

------------------------------------------------------------------------
-- screen redisplay functions


local adjcursor = function (buf)
	-- adjust the screen cursor so that it matches with
	-- the buffer cursor (buf.ci, buf.cj)
	--
	-- first, adjust buf.li
	local bl = buf.box.l
	if buf.ci < buf.li or buf.ci >= buf.li+bl then
		-- cursor has moved out of box.
		-- set li so that ci is in the middle of the box
		--   replaced "//" with floor() - thx to Thijs Schreijer
		buf.li = max(1, math.floor(buf.ci-bl/2))
		buf.chgd = true
	end
	local cx = buf.ci - buf.li + 1
	local cy = 1 -- box column index, ignoring horizontal scroll
--~   local cy = 0 -- box column index, ignoring horizontal scroll
	local col = buf.box.c
	local l = buf.ll[buf.ci]
	local cj = 1
	for p,c in ucodes(l) do
		if cj == buf.cj then break end
		cj = cj + 1
		if c == 9 then
			cy = cy + (tabln - (cy-1) % tabln)
		else
			cy = cy + 1
		end
	end
	-- determine actual hs
	local hs = 0 -- horizontal scroll
	local cys = cy -- actual box column index
	while true do
		if cys >= col then
			cys = cys - 40
			hs = hs + 40
		else
			break
		end
	end
	if hs ~= buf.hs then
		buf.chgd = true
		buf.hs = hs
	end
	if buf.chgd then return end -- (li or hs or content change)
	-- here, assume that cursor will move within the box
	editor.status(editor.statusline())
	go(buf.box.x + cx - 1, buf.box.y + cys - 1)
	flush()
end -- adjcursor


local displaylines = function (buf)
	-- display buffer lines starting at index buf.li
	-- in list of lines buf.ll
	local box = buf.box; local ll = buf.ll; local li = buf.li; local hs = buf.hs
	local ci = buf.ci; local cj = buf.cj; local si = buf.si; local sj = buf.sj
	local bi, bj, ei, ej -- beginning and end of selection
	local sel = false; local insel = false; local jon = -1; local joff = -1
	if si then -- set beginning and end of selection
		sel = true
		if si < ci then bi=si; bj=sj; ei=ci; ej=cj
		elseif si > ci then bi=ci; bj=cj; ei=si; ej=sj
		elseif sj < cj then bi=si; bj=sj; ei=ci; ej=cj
		elseif sj >= cj then bi=ci; bj=cj; ei=si; ej=sj
		end
	end
	for i = 1, box.l do
		local lx = li + i - 1
		if sel then
			insel, jon, joff = false, -1, -1
			if lx > bi and lx < ei then insel=true
			elseif lx == bi and lx == ei then jon=bj; joff=ej
			elseif lx == bi then jon=bj
			elseif lx == ei then joff=ej; insel=true
			end
		end
		local l = ll[lx] or EOT
		boxline(box, hs, i, l, insel, jon, joff)
	end
	flush()
end

local redisplay = function (buf)
	-- adjust cursor and repaint buffer lines if needed
	adjcursor(buf)
	if buf.chgd or buf.si then
		displaylines(buf)
		buf.chgd = false
		adjcursor(buf)
	end
	buf.chgd = false
end --redisplay


editor.fullredisplay = function ()
	-- complete repaint of the screen
	-- performed initially, or when a new buffer is displayed, or
	-- when requested by the user (^L command) because the
	-- screen is garbled or the screensize has changed (xterm, ...)
	--
	editor.scrl, editor.scrc = term.getscrlc()
	-- [TMP!! editor.scrbox is a bckgnd box with a pattern to
	-- visually check that edition does not overflow buf box
	-- (this is for future multiple windows, including side by side)]
	editor.scrbox = boxnew(1, 1, editor.scrl, editor.scrc)
--~   -- debug layout
--~   boxfill(editor.scrbox, " ", style.bckg)
--~   buf.box = boxnew(2, 2, editor.scrl-3, editor.scrc-2)
	--
	-- regular layout
	boxfill(editor.scrbox, " ", style.normal)
	editor.buf.box = boxnew(2, 1, editor.scrl-2, editor.scrc)
	editor.buf.chgd = true
	redisplay(editor.buf)
end

editor.redisplay = redisplay

-- BUFFER AND CURSOR MANIPULATION
-- missing?!

-- EDITOR ACTIONS

editor.actions = {}
local e = editor.actions

local msg = editor.msg; local readstr = editor.readstr; local readchar = editor.readchar

e.cancel = function (b)
	-- do nothing. cancel selection if any
	b.si, b.sj = nil, nil
	b.chgd = true
end

e.redisplay = editor.fullredisplay

e.gohome = function (b) b:movecur(0, -MAX) end
e.goend = function (b) b:movecur(0, MAX) end
e.gobot = function (b) b:setcur(1, 1) end
e.goeot = function (b) b:setcur(MAX, MAX) end
e.goup = function (b) b:movecur(-1, 0) end
e.godown = function (b) b:movecur(1, 0) end

e.goright = function (b)
	return b:ateot()
		or b:ateol() and b:movecur(1, -MAX)
		or b:movecur(0, 1)
end

e.goleft = function (b)
	return b:atbot()
		or b:atbol() and b:movecur(-1, MAX)
		or b:movecur(0, -1)
end

local wordchar = function (u) -- used by nexword, prevword
	-- return true if u is the code of a non-space char
	return (u and u ~= 32 and u ~= 9)
end

e.nextword = function (b)
	local inw1 = wordchar(b:curcode())
	local inw2, u
	while true do
		e.goright(b)
		if b:ateol() then break end
		u = b:curcode()
		if not u then e.goright(b); break end
		inw2 = wordchar(u)
		if (not inw1) and inw2 then break end
		inw1 = inw2
	end
end

e.prevword = function (b)
	e.goleft(b)
	local inw1 = wordchar(b:curcode())
	local inw2
	local u
	while true do
		if b:ateol() then break end
		e.goleft(b)
		if b:atbol() then break end
		u = b:curcode()
		if not u then break end
		inw2 = wordchar(u)
		if inw1 and not inw2 then e.goright(b); break end
		inw1 = inw2
	end
end

e.pgdn = function (b)
	b:setcur(b.ci + b.box.l - 2, b.cj)
end

e.pgup = function (b)
	b:setcur(b.ci - b.box.l - 2, b.cj)
end

e.del = function (b)
	-- if selection, delete it. else, delete char
	if b.si then return e.wipe(b, true) end -- do not keep in wipe list
	if b:ateot() then return false end
	local ci, cj = b:getcur()
	if b:ateol() then return b:bufdel(ci+1, 0) end
	return b:bufdel(ci, cj+1)
end

e.bksp = function (b)
	return e.goleft(b) and e.del(b)
end

e.insch = function (b, k)
	-- insert char with code k
	-- (don't remove. used by editor loop)
	return b:bufins(uchar(k))
end

e.tab = function (b)
	local tn = editor.tabspaces
	if not tn then -- insert a tab char
		return b:bufins(char(9))
	end
	local _, cj = b:getcur()
	--- @type integer
	--- @diagnostic disable-next-line: assign-type-mismatch
	local n = tn - ((cj) % tn)
	return b:bufins(rep(char(32), n))
end


e.insert = function (b, x)
	-- insert x at cursor
	-- x can be a string or a list of lines (a table)
	-- if x is a string, it may contain newlines ("\n")
	local r, errm = b:bufins((type(x) == "string") and lines(x) or x)
	if not r then msg(errm); return nil, errm end
	return true
end

e.nl = function (b)
	-- equivalent to e.insert("\n")
	return b:bufins({"", ""})
end

e.searchpattern = function (b, pat, plain)
	-- forward search a lua or plain text pattern pat, starting at cursor.
	-- pattern is searched one line at a time
	-- if plain is true, pat is a plain text pattern. special
	-- pattern chars are ignored.
	-- in a lua pattern, `^` and `$` represent the beginning and end of line
	-- a pattern cannot contain `\n`
	-- if the pattern is found, cursor is moved at the beginning of
	-- the pattern and the function return true. else, the cursor
	-- is not moved and the function returns false.

	local oci, ocj = b:getcur() -- save the original cursor position
	e.goright(b)
	while true do
		local l = b:getline()
		local ci, cj = b:getcur()
		local j = l:find(pat, uoff(l, cj), plain)
		if j then --found
			-- convert byte position into char index
			cj = ulen(l, 1, j)
			b:setcur(nil, cj)
			return true
		end -- found
		if b:atlast() then break end
		e.gohome(b); e.godown(b)
	end
	-- not found
	b:setcur(oci, ocj) -- restore cursor position
	return false
end

e.searchagain = function (b, actfn)
	-- search editor.pat. If found, execute actfn
	-- default action is to display a message "found!")
	-- on success, return the result of actfn() or true.
	-- (note: search does NOT ignore case)

	if not editor.pat then
		msg("no string to search")
		return nil
	end
	local r = e.searchpattern(b, editor.pat, editor.searchplain)
	if r then
		if actfn then
			return actfn()
		else
			msg("found!")
			return true
		end
	else
		msg("not found")
	end
end

e.search = function (b)
	editor.pat = readstr("Search: ")
	if not editor.pat then
		msg("aborted.")
		return
	end
	return e.searchagain(b)
end

e.replaceagain = function (b)
	local replall = false -- true if user selected "replace (a)ll"
	local n = 0 -- number of replaced instances
	local replatcur = function ()
		-- replace at cursor
		-- (called only when editor.pat is found at cursor)
		-- (pat and patrepl are plain text, unescaped)
		n = n + 1  --one more replaced instance
		local ci, cj = b:getcur()
		return b:bufdel(ci, cj + #editor.pat)
			and b:bufins(editor.patrepl)
	end
	local replfn = function ()
		-- this function is called each time editor.pat is found
		-- return true to continue, nil/false to stop
		if replall then
			return replatcur()
		else
			local ch = readchar( -- ask what to do
				"replace? (q)uit (y)es (n)o (a)ll (^G) ",
				"[anqy]")
			if not ch then return nil end
			if ch == "a" then -- replace all
				replall = true
				return replatcur()
			elseif ch == "y" then -- replace
				return replatcur()
			elseif ch == "n" then -- continue
				return true
			else -- assume q (quit)
				return nil
			end
		end
	end
	while e.searchagain(b, replfn) do end
	msg(format("replaced %d instance(s)", n))
end

e.replace = function (b)
	editor.pat = readstr("Search: ")
	if not editor.pat then
		msg("aborted.")
		return
	end
	editor.patrepl = readstr("Replace with: ")
	if not editor.patrepl then
		msg("aborted.")
		return
	end
	return e.replaceagain(b)
end

e.mark = function (b)
	b.si, b.sj = b.ci, b.cj
	msg("Mark set.")
	b.chgd = true
end

e.exch_mark = function (b)
	if b.si then
		b.si, b.ci = b.ci, b.si
		b.sj, b.cj = b.cj, b.sj
	end
end

e.wipe = function (b, nokeep)
	-- wipe selection, or kill current line if no selection
	-- if nokeep is true, deleted text is not kept in the kill list
	-- (default false)
	if not b.si then
		msg("No selection.")
		if b:atlast() then -- add an empty line at end
			e.goeot(b); e.nl(b); e.goup(b)
		end
		e.gohome(b)
		local xi, xj
		xi, xj = b.ci+1, 0
		if not nokeep then editor.kll = b:getlines(xi, xj) end
		b:bufdel(xi, xj)
		return
	end
	-- make sure cursor is at beg of selection
	if b:markbeforecur() then e.exch_mark(b) end
	local si, sj = b:getsel()
	if not nokeep then editor.kll = b:getlines(si, sj) end
	b:bufdel(si, sj)
	b.si = nil
end


e.yank = function (b)
	if not editor.kll or #editor.kll == 0 then
		msg("nothing to yank!"); return
	end
	return b:bufins(editor.kll)
end

e.undo = function (b)
	if b.ualtop == 0 then msg("nothing to undo!"); return end
	b:op_undo(b.ual[b.ualtop])
	b.ualtop = b.ualtop - 1
end

e.redo = function (b)
	if b.ualtop == #b.ual then msg("nothing to redo!"); return end
	b.ualtop = b.ualtop + 1
	b:op_redo(b.ual[b.ualtop])
end

e.exiteditor = function (b)
	local anyunsaved = false
	for i, bx in ipairs(editor.buflist) do
		-- tmp buffers: if name starts with `*`,
		-- buffer is not considered as unsaved
		if bx.filename and not bx.filename:match("^%*") then
			anyunsaved = anyunsaved or bx.unsaved
		end
	end
	if anyunsaved then
		local ch = readchar(
			"Some buffers not saved. Quit? ", "[YNQynq\r\n]")
		if ch ~= "y" and ch ~= "Y" then
			msg("aborted.")
			return
		end
	end
	editor.quit = true
	msg("exiting.")
end


e.newbuffer = function (b, fname, ll)
	ll = ll or { "" } -- default is a buffer with one empty line
	fname = fname or editor.readstr("Buffer name: ")
	-- try to find the buffer if it already exists
	for i, bx in ipairs(editor.buflist) do
		if bx.filename == fname then
			editor.buf = bx; editor.bufindex = i
			editor.fullredisplay(--[[bx]])
			return bx
		end
	end
	-- buffer doesn't exist. create it.
	local bx = buffer.new(ll)
	bx.actions = editor.edit_actions
	bx.filename = fname
	-- insert just after the current buffer
	local bi = editor.bufindex + 1
	table.insert(editor.buflist, bi, bx)
	editor.bufindex = bi
	editor.buf = bx
	editor.fullredisplay()
	return bx
end

e.nextbuffer = function (b)
	-- switch to next buffer
	local bln = #editor.buflist
	editor.bufindex = editor.bufindex % bln + 1
	editor.buf = editor.buflist[editor.bufindex]
	editor.fullredisplay()
end

e.prevbuffer = function (b)
	-- switch to previous buffer
	local bln = #editor.buflist
	-- if bufindex>1, the "previous" buffer index should be bufindex-1
	-- if bufindex==1, the "previous" buffer index should be bln
	editor.bufindex = (editor.bufindex - 2) % bln + 1
	editor.buf = editor.buflist[editor.bufindex]
	editor.fullredisplay()
end

e.outbuffer = function (b)
	-- switch to *OUT* buffer.
	-- if already in OUT buffer, switch back to previous buffer
	if b.filename == "*OUT*" then return e.prevbuffer(b) end
	return e.newbuffer(b, "*OUT*")
end --outbuffer

e.findfile = function (b, fname)
	fname = fname or editor.readstr("Open file: ")
	if not fname then editor.msg""; return end
	local ll, errmsg = readfile(fname)
	if not ll then editor.msg(errmsg); return end
	e.newbuffer(b, fname, ll)
end

e.writefile = function (b, fname)
	fname = fname or editor.readstr("Write to file: ")
	if not fname then editor.msg("Aborted."); return end
	local file, errmsg = io.open(fname, "w")
	if not file then editor.msg(errmsg); return end
	for i = 1, #b.ll do file:write(b.ll[i], "\n") end
	file:close()
	b.filename = fname
	b.unsaved = false
	editor.msg(fname .. " saved.")
end

e.savefile = function (b)
	e.writefile(b, b.filename)
end

e.gotoline = function (b, lineno)
	-- prompt for a line number, go there
	-- if lineno is provided, don't prompt.
	lineno = lineno or tonumber(editor.readstr("line number: "))
	if not lineno then
		msg("invalid line number.")
	else
		return b:setcur(lineno, 0)
	end
end

e.help = function (b)
	for i, bx in ipairs(editor.buflist) do
		if bx.filename == "*HELP*" then
			editor.buf = bx
			editor.bufindex = i
			editor.fullredisplay(--[[bx]])
			return
		end
	end -- help buffer not found, then build it.
	return e.newbuffer(b, "*HELP*", lines(editor.helptext))
end

e.prefix_ctlx = function (b)
	-- process ^X prefix
	local k = editor.nextk()
	local kname = "^X-" .. editor.keyname(k)
	local act = editor.bindings_ctlx[k]
	if not act then
		msg(kname .. " not bound.")
		return false
	end
	msg(kname)
	return act(b)
end

-- useful functions for extensions (see usage examples in ple_init.lua)

e.getcur = function (b)
	-- return the cursor position in the buffer b and the number
	-- of lines in the buffer
	-- eg.:  ci, cj, ln = e.getcur(b)
	-- ci is the line index and cj the column index
	-- ci is in the range [1, ln]
	-- cj is in the range [0, line length]
	-- cj == 0 when the cursor is at the beginning of the line
	--  (ie. before the first char)
	return b.ci, b.cj, #b.ll
end

e.setcur = function (b, ci, cj)
	-- move the cursor to position ci, cj (see above)
	b:setcur(ci, cj)
end

e.getline = function (b, i)
	-- return the i-th line of the buffer b (as a string)
	-- if i is not provided, the current line is returned.
	i = i or b.ci
	return b.ll[i]
end

editor.helptext = [[

*HELP*      -- back to the previous buffer: ^X^P

Cursor movement
	Arrows, PageUp, PageDown, Home, End
	^A, ^E    go to beginning, end of line
	^B, ^F    go backward, forward
	^N, ^P    go to next line, previous line
	^K, ^J    go to next word, previous word
	^U, ^V    page up, page down
	^X<    go to beginning of buffer
	^X>     go to end of buffer
	^S    forward search (plain text, case sensitive)
	^R    search again (string previously entered with ^S)
	^X^G    prompt for a line number, go there

Edition
	^D, Delete  delete character at cursor
	^H, bcksp  delete previous character
	^space, ^@  mark  (set beginning of selection)
	^W    wipe (cut selection or cut line if no selection)
	^Y    yank (paste)
	^X5    replace
	^X7    replace again (with same strings)

Files, buffers
	^X^F    prompt for a filename, read the file in a new buffer
	^X^W    prompt for a filename, write the current buffer
	^X^S    save the current buffer
	^X^B    switch to a named buffer or create a new buffer
	^X^N    switch to the next buffer
	^X^P    switch to the previous buffer

Misc.
	^X^C    exit the editor
	^G    abort the current command
	^Z    undo
	^X^Z    redo
	^L    redisplay the screen (useful if the screen was
			garbled  or its dimensions changed)
	F1, ^X^H  this help text

]]

------------------------------------------------------------------------
-- bindings

editor.bindings = { -- actions binding for text edition
	[0] = e.mark,    -- ^@
	[1] = e.gohome,    -- ^A
	[2] = e.goleft,    -- ^B
	--[3]    -- ^C
	[4] = e.del,    -- ^D
	[5] = e.goend,    -- ^E
	[6] = e.goright,  -- ^F
	[7] = e.cancel,    -- ^G
	[8] = e.bksp,    -- ^H
	[9] = e.tab,    -- ^I
	[10] = e.prevword,  -- ^J
	[11] = e.nextword,  -- ^K
	[12] = e.redisplay,  -- ^L
	[13] = e.nl,    -- ^M (return)
	[14] = e.godown,  -- ^N
	[15] = e.outbuffer,    -- ^O
	[16] = e.goup,    -- ^P
	-- [17] =   -- ^Q
	[18] = e.searchagain,  -- ^R
	[19] = e.search,  -- ^S
	[20] = e.test,    -- ^T
	[21] = e.pgup,    -- ^U
	[22] = e.pgdn,    -- ^V
	[23] = e.wipe,    -- ^W
	[24] = e.prefix_ctlx,  -- ^X (prefix - see below)
	[25] = e.yank,    -- ^Y
	[26] = e.undo,    -- ^Z
	--[27] -- ESC is not used - confusion with function key sequences
	--
	[keys.kpgup]  = e.pgup,
	[keys.kpgdn]  = e.pgdn,
	[keys.khome]  = e.gohome,
	[keys.kend]   = e.goend,
	[keys.kdel]   = e.del,
	[keys.del]    = e.bksp,
	[keys.kright] = e.goright,
	[keys.kleft]  = e.goleft,
	[keys.kup]    = e.goup,
	[keys.kdown]  = e.godown,
	[keys.kf1]    = e.help,
}--editor.bindings

editor.bindings_ctlx = {  -- ^X<key>
	[2] = e.newbuffer,  -- ^X^B
	[3] = e.exiteditor,  -- ^X^C
	[6] = e.findfile,  -- ^X^F
	[7] = e.gotoline,  -- ^X^G
	[8] = e.help,    -- ^X^H
	[11] = e.killeol,  -- ^X^K
	[14] = e.nextbuffer,  -- ^X^N
	[16] = e.prevbuffer,  -- ^X^P
	[19] = e.savefile,  -- ^X^S
	[23] = e.writefile,  -- ^X^W
	[24] = e.exch_mark,  -- ^X^X
	[26] = e.redo,    -- ^X^Z
	[53] = e.replace,  -- ^X 5 -%
	[55] = e.replaceagain,  -- ^X 7 -&
	[60] = e.gobot,    -- ^X <
	[62] = e.goeot,    -- ^X >
}--editor.bindings_ctlx

local editor_loadinitfile = function ()
	-- function to be executed before entering the editor loop
	-- could be used to load a configuration/initialization file
	local initfile = os.getenv("PLE_INIT")
	if fileexists(initfile) then
		return assert(loadfile(initfile))()
	end
	initfile = "./ple_init.lua"
	if fileexists(initfile) then
		return assert(loadfile(initfile))()
	end
	local homedir = os.getenv("HOME") or "~"
	initfile = homedir .. "/.config/ple/ple_init.lua"
	if fileexists(initfile) then
		return assert(loadfile(initfile))()
	end
	return nil
end


local editor_loop = function (ll, fname)
	editor.initmsg = "Help: F1 or ^X^H"
	editor_loadinitfile()
	style.normal()
	e.newbuffer(nil, fname, ll)
		-- 1st arg is current buffer (unused for newbuffer, so nil)
	msg(editor.initmsg)
	redisplay(editor.buf) -- adjust cursor to beginning of buffer
	while not editor.quit do
		local k = editor.nextk()
		local kname = editor.keyname(k)
		-- try to find an action bound to the key
		-- first in buffer action table
		-- then in the default editor table
		local act = editor.buf.bindings
			and editor.buf.bindings[k]
			or editor.bindings[k]
		if act then
			msg(kname)
			editor.lastresult = act(editor.buf)
		elseif (k >= 32) and (k > 0xffff or k < 0xffea) then
			editor.lastresult = e.insch(editor.buf, k)
		else
			editor.msg(kname .. " not bound")
		end
		redisplay(editor.buf)
	end
end

local main = function ()
	-- process argument
	local ll, fname
	if arg[1] then
		local err
		ll, err = readfile(arg[1]) -- load file as a list of lines
		if not ll then print(err); os.exit(1) end
		fname = arg[1]
	else
		ll = { "" }
		fname = "unnamed"
	end
	-- set term in raw mode
	local prevmode, e2, m = term.savemode()
	if not prevmode then print(prevmode, e2, m); os.exit() end
	term.setrawmode()
	term.enteraltscreen()
	-- run the application in a protected call so we can properly reset
	-- the tty mode and display a traceback in case of error
	local ok, msg2 = xpcall(editor_loop, debug.traceback, ll, fname)
	term.exitaltscreen()
	style.normal()
	term.restoremode(prevmode)
	if not ok then -- display traceback in case of error
		print(msg2)
		os.exit(1)
	end
end

main()

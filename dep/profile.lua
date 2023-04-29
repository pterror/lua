--[[
MIT License

Copyright (c) 2021 2dengine

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local clock = os.clock

local mod = {}

local labeled = {}
local defined = {}
local tcalled = {}
local telapsed = {}
local ncalls = {}
local internal = {}

--[[internal]]
--[[@param event string]] --[[@param line integer]] --[[@param info? table]]
mod.hooker = function (event, line, info)
	info = info or debug.getinfo(2, "fnS")
	local f = info.func
	if internal[f] or info.what ~= "Lua" then return end
	if info.name then labeled[f] = info.name end
	if not defined[f] then
		defined[f] = info.short_src..":"..info.linedefined
		ncalls[f] = 0
		telapsed[f] = 0
	end
	if tcalled[f] then
		local dt = clock() - tcalled[f]
		telapsed[f] = telapsed[f] + dt
		tcalled[f] = nil
	end
	if event == "tail call" then
		local prev = debug.getinfo(3, "fnS")
		mod.hooker("return", line, prev)
		mod.hooker("call", line, info)
	elseif event == "call" then
		tcalled[f] = clock()
	else
		ncalls[f] = ncalls[f] + 1
	end
end

--[[@param clock_ fun(): integer]]
mod.setclock = function (clock_)
	assert(type(clock_) == "function", "clock must be a function")
	clock = clock_
end

mod.start = function ()
	if rawget(_G, "jit") then jit.off(); jit.flush() end
	debug.sethook(mod.hooker, "cr")
end

mod.stop = function ()
	debug.sethook()
	for f in pairs(tcalled) do
		local dt = clock() - tcalled[f]
		telapsed[f] = telapsed[f] + dt
		tcalled[f] = nil
	end
	local lookup = {}
	for f, d in pairs(defined) do
		local id = (labeled[f] or "?") .. d
		local f2 = lookup[id]
		if f2 then
			ncalls[f2] = ncalls[f2] + (ncalls[f] or 0)
			telapsed[f2] = telapsed[f2] + (telapsed[f] or 0)
			defined[f], labeled[f] = nil, nil
			ncalls[f], telapsed[f] = nil, nil
		else
			lookup[id] = f
		end
	end
	collectgarbage("collect")
end

mod.reset = function ()
	for f in pairs(ncalls) do
		ncalls[f] = 0
	end
	for f in pairs(telapsed) do
		telapsed[f] = 0
	end
	for f in pairs(tcalled) do
		tcalled[f] = nil
	end
	collectgarbage("collect")
end

--[[internal]]
--[[@param a function]]
--[[@param b function]]
mod.comp = function (a, b)
	local dt = telapsed[b] - telapsed[a]
	if dt == 0 then
		return ncalls[b] < ncalls[a]
	end
	return dt < 0
end

--- Iterates all functions that have been called since the profile was started.
-- @tparam[opt] number limit Maximum number of rows
mod.query = function (limit)
	local t = {}
	for f, n in pairs(ncalls) do
		if n > 0 then
			t[#t + 1] = f
		end
	end
	table.sort(t, mod.comp)
	if limit then
		while #t > limit do
			table.remove(t)
		end
	end
	for i, f in ipairs(t) do
		local dt = 0
		if tcalled[f] then
			dt = clock() - tcalled[f]
		end
		t[i] = { i, labeled[f] or "?", ncalls[f], telapsed[f] + dt, defined[f] }
	end
	return t
end

local cols = { 3, 29, 11, 24, 32 }

--[[@param max_rows? number]]
mod.report = function (max_rows)
	local out = {}
	local report = mod.query(max_rows)
	for i, row in ipairs(report) do
		for j = 1, 5 do
			local s = row[j]
			local l2 = cols[j]
			s = tostring(s)
			local l1 = s:len()
			if l1 < l2 then
				s = s..(" "):rep(l2-l1)
			elseif l1 > l2 then
				s = s:sub(l1 - l2 + 1, l1)
			end
			row[j] = s
		end
		out[i] = table.concat(row, " | ")
	end

	local row = " +-----+-------------------------------+-------------+--------------------------+----------------------------------+ \n"
	local col = " | #   | Function                      | Calls       | Time                     | Code                             | \n"
	local sz = row..col..row
	if #out > 0 then
		sz = sz .. " | " .. table.concat(out, " | \n | ") .. " | \n"
	end
	return "\n" .. sz .. row
end

-- store all internal profiler functions
for _, v in pairs(mod) do
	if type(v) == "function" then
		internal[v] = true
	end
end

return mod

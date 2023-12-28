#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

local mock = require("dep.mock")
for k, v in pairs(mock) do _G[k] = v end

--[[@diagnostic disable-next-line: param-type-mismatch]]
math.randomseed((os.time() + os.clock()) * 1000)

name = function () return mock.given_name() .. " " .. mock.surname() end
coinflip = function () return math.random(2) == 2 end
die = function () return math.random(1, 6) end
dice = function (n, sides)
	sides = sides or 6
	local sum = 0
	for _ = 1, n do sum = sum + math.random(1, sides) end
	return sum
end
random = math.random

--[[TODO: rolling huge numbers of dice]]
--[[TODO: generate counts for huge numbers of dice {1, 2, 3, 4, 5, 6}]]

if arg[1] == "help" then
	print("functions:")
	for k, v in pairs(_G) do
		if type(v) == "function" and (not tostring(v):match("^function: builtin") or k == "random") and k ~= "require" then
			print("\t" .. k)
		end
	end
	return
end

local fn = assert(loadstring("return " .. arg[1]))
while true do print(fn()) end

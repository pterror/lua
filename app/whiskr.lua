#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local whiskr_ = require("world.whiskr")

local whiskr = assert(whiskr_.open(arg[1] or os.getenv("HOME") .. "/whiskr.db"))

local epoll = require("dep.epoll").new()

local remove
local done = false

--[[@type table<string, fun(args: string)>]]
local command_handlers = {
	exit = function () done = true; if remove then remove() end end,
	help = function ()
		print([[
add <subject> <predicate> <object>     adds a fact
remove <subject> <predicate> <object>  removes a fact
subject <subject>                      lists all facts with subject <subject>
pred <predicate>                       lists all facts with predicate <pred>
object <object>                        lists all facts with object <object>]])
	end,
	add = function (args)
		local subj, pred, obj = args:match("(%S+)%s+(%S+)%s+(%S.+)")
		if not subj then io.stderr:write("whiskr: invalid arguments to 'add': '" ..  args .. "'") end
		whiskr:add_fact({ subject = subj, predicate = pred, object = obj })
	end,
	remove = function (args)
		local subj, pred, obj = args:match("(%S+)%s+(%S+)%s+(%S.+)")
		if not subj then io.stderr:write("whiskr: invalid arguments to 'add': '" ..  args .. "'") end
		whiskr:add_fact({ subject = subj, predicate = pred, object = obj })
	end,
	subject = function (subject)
		for fact in whiskr:by_subject(subject) do print_fact(fact) end
	end,
	pred = function (pred)
		for fact in whiskr:by_predicate(pred) do print_fact(fact) end
	end,
	object = function (object)
		for fact in whiskr:by_object(object) do print_fact(fact) end
	end,
}

--[[@diagnostic disable-next-line: param-type-mismatch]]
_, remove = epoll:add(0, function (line)
	--[[@type string, string]]
	local cmd, args = line:match("(%S+)%s*(.*)")
	if cmd then
		cmd = cmd:lower()
		local fn = command_handlers[cmd]
		if fn then fn(args)
		else io.stderr:write("whiskr: unknown command '" .. cmd .. "'\n") end
	end
	if not done then io.stdout:write("$ "); io.stdout:flush() end
end)

io.stdout:write("$ ")
io.stdout:flush()

while true do
	local success, err = xpcall(epoll.loop, debug.traceback, epoll)
	if not success and err then
		if err:match("^.+: interrupted!") then return end
		print(err)
		io.stdout:write("$ ")
		io.stdout:flush()
	end
end

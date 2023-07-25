#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local whiskr_ = require("world.whiskr")

local whiskr = assert(whiskr_.open(arg[1] or os.getenv("HOME") .. "/whiskr.db"))

local epoll = require("dep.epoll").new()

local remove
local done = false

local print_fact = function (fact) --[[@param fact whiskr_fact]]
	io.stdout:write(fact.subject, " ", fact.predicate, " ", fact.object, "\n")
end

--[[@type table<string, fun(args: string)>]]
local command_handlers = {
	exit = function () done = true; if remove then remove() end end,
	help = function ()
		print([[
q/x/exit                                 exit the program
h/help                                   show this help
l/list                                   list all facts
+/add <subject> <predicate> <object>     add a fact
-/remove <subject> <predicate> <object>  remove a fact
s/subject <subject>                      list all facts with subject <subject>
p/pred <predicate>                       list all facts with predicate <pred>
o/object <object>                        list all facts with object <object>]])
	end,
	list = function ()
		local iter, err = whiskr:list_facts()
		if not iter then io.stderr:write(err, "\n")
		else for fact in iter do print_fact(fact) end end
	end,
	add = function (args)
		local subj, pred, obj = args:match("(%S+)%s+(%S+)%s+(%S.*)")
		if not subj then io.stderr:write("whiskr: invalid arguments to 'add': '",  args, "'\n"); return end
		local success, err = whiskr:add_fact({ subject = subj, predicate = pred, object = obj })
		if not success then io.stderr:write(err, "\n") end
	end,
	remove = function (args)
		local subj, pred, obj = args:match("(%S+)%s+(%S+)%s+(%S.*)")
		if not subj then io.stderr:write("whiskr: invalid arguments to 'remove': '",  args, "'\n"); return end
		local deleted, err = whiskr:remove_fact({ subject = subj, predicate = pred, object = obj })
		if not deleted then return io.stderr:write(err, "\n")
		elseif deleted == 0 then io.stderr:write("whiskr_cli.remove: fact does not exist\n") end
	end,
	subject = function (subject)
		local iter, err = whiskr:by_subject(subject)
		if not iter then io.stderr:write(err, "\n")
		else for fact in iter do print_fact(fact) end end
	end,
	pred = function (pred)
		local iter, err = whiskr:by_predicate(pred)
		if not iter then io.stderr:write(err, "\n")
		else for fact in iter do print_fact(fact) end end
	end,
	object = function (object)
		local iter, err = whiskr:by_object(object)
		if not iter then io.stderr:write(err, "\n")
		else for fact in iter do print_fact(fact) end end
	end,
}
command_handlers.q = command_handlers.exit
command_handlers.x = command_handlers.exit
command_handlers.h = command_handlers.help
command_handlers.l = command_handlers.list
command_handlers["+"] = command_handlers.add
command_handlers["-"] = command_handlers.remove
command_handlers.s = command_handlers.subject
command_handlers.p = command_handlers.pred
command_handlers.o = command_handlers.object

--[[@diagnostic disable-next-line: param-type-mismatch]]
_, remove = epoll:add(0, function (line)
	--[[@type string, string]]
	local cmd, args = line:match("(%S+)%s*(.*)\n")
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

while not done do
	local success, err = xpcall(epoll.loop, debug.traceback, epoll)
	if not success and err then
		if err:match("^.+: interrupted!") then return end
		print(err)
		io.stdout:write("$ ")
		io.stdout:flush()
	end
end

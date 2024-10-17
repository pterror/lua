#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

if #arg < 2 then print("usage: dns_lookup.lua <nameserver> <domain>"); os.exit(1) end
local dns = require("lib.dns.format")
local dns_pretty_print = require("lib.dns.pretty_print")
local epoll = require("dep.epoll").new()
local pretty_print = require("dep.pretty_print").pretty_print
require("lib.dns.tcp_client").client(function (msg)
	for _, k in ipairs({ "questions", "answers", "nameservers", "additional" }) do
		print(("=== %s ===\nname\tclass\ttype%s"):format(k, k == "questions" and "" or "\tdata"))
		for _, a in ipairs(msg[k]) do
			io.write(table.concat(a.name, "."), "\t", dns.class_name[a.class], "\t", dns.type_name[a.type] or a.type, "\t")
			pretty_print(k == "questions" and "" or (dns_pretty_print.formatters[a.type] and dns_pretty_print.formatters[a.type](a.data) or a.data))
		end
	end
end, arg[1], arg[2], nil, arg[3] and dns.type[arg[3]], nil, epoll)
epoll:loop()

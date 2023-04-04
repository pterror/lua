#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

if #arg < 2 then print("usage: dns_lookup.lua <nameserver> <domain>"); os.exit(1) end
local dns = require("lib.dns.format")
local epoll = require("dep.epoll").new()
local pretty_print = require("dep.pretty_print").pretty_print
local domain_parts_to_string = function (parts) return table.concat(parts, ".") end
-- LINT: warn on unused diagnostics
local formatters = {
	[dns.type.CNAME] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MB]  = domain_parts_to_string,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MD] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MF] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MG] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MINFO] = function (x) x.rmailbx = domain_parts_to_string(x.rmailbx); x.emailbx = domain_parts_to_string(x.emailbx); return x end,
	--[[@diagnostic disable-next-line: deprecated]]
	[dns.type.MR] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	[dns.type.MX] = function (x) x.exchange = domain_parts_to_string(x.exchange); return x end,
	[dns.type.NS] = domain_parts_to_string,
	[dns.type.PTR] = domain_parts_to_string,
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	[dns.type.SOA] = function (x) x.mname = domain_parts_to_string(x.mname); x.rname = domain_parts_to_string(x.rname); return x end,
	[dns.type.TXT] = function (strs) return table.concat(strs, "\t") end,
	[dns.type.A] = function (arr) return table.concat(arr, ".") end,
	[dns.type.AAAA] = function (arr)
		local s = string.char(unpack(arr)):gsub("..", function (m) --[[@param m string]]
			local b1, b2 = m:byte(1, 2)
			return string.format(":%x", bit.bor(bit.lshift(b1, 8), b2))
		end):sub(2)
		local max0s = ""
		for m in s:gmatch("[0:][0:]+") do if #m > #max0s then max0s = m end end
		return #max0s > 0 and s:gsub(max0s, "::", 1) or s
	end,
	[dns.type.DS] = function (x)
		x.algorithm = dns.dnssec_algorithm_name[x.algorithm] or x.algorithm
		x.digest_type = dns.dnssec_digest_type_name[x.digest_type] or x.digest_type
		return x
	end,
	[dns.type.RRSIG] = function (x)
		x.type_covered = dns.type_name[x.type] or x.type_covered
		x.algorithm = dns.dnssec_algorithm_name[x.algorithm] or x.algorithm
		return x
	end,
	[dns.type.NSEC] = function (x)
		for i = 1, #x.types do x.types[i] = dns.type_name[x.types[i]] or x.types[i] end
		return x
	end,
	[dns.type.DNSKEY] = function (x) x.algorithm = dns.dnssec_algorithm_name[x.algorithm] or x.algorithm; return x end,
}
require("lib.dns.tcp_client").client(function (msg)
	for _, k in ipairs({ "questions", "answers", "nameservers", "additional" }) do
		print(("=== %s ===\nname\tclass\ttype%s"):format(k, k == "questions" and "" or "\tdata"))
		for _, a in ipairs(msg[k]) do
			io.write(table.concat(a.name, "."), "\t", dns.class_name[a.class], "\t", dns.type_name[a.type] or a.type, "\t")
			pretty_print(k == "questions" and "" or (formatters[a.type] and formatters[a.type](a.data) or a.data))
		end
	end
end, arg[1], arg[2], nil, arg[3] and dns.type[arg[3]], nil, epoll)
epoll:loop()

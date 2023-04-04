-- UDP port 53, truncated to 512 bytes (TC bit set if required)
-- TCP port 53, prefixed with 2-octet length field

local dns = require("lib.dns.format")
local tcp_client = require("lib.tcp.client").client

local mod = {}

-- FIXME: this isn't a client - it only sends a single message. so what should it be called
-- TODO: the positioning of epoll is very inconvenient. but breaking up the arguments isn't a great option either
--[[@param cb fun(msg: dns_message)]] --[[@param nameserver string]] --[[@param domain string]] --[[@param opcode? dns_opcode]] --[[@param type? dns_type]] --[[@param class? dns_class]] --[[@param epoll epoll?]]
mod.client = function (cb, nameserver, domain, opcode, type, class, epoll)
	local is_running = not epoll
	epoll = epoll or require("dep.epoll").new()
	--- @diagnostic disable-next-line: cast-local-type
	type = type or dns.type["*"]
	class = class or dns.class.IN
	local name_parts = {}
	for s in domain:gmatch("[^.]+") do name_parts[#name_parts+1] = s end
	if #name_parts[#name_parts] > 0 then name_parts[#name_parts+1] = "" end
	local s = dns.dns_message_to_string({
		opcode = opcode,
		is_query = true,
		is_recursion_desired = true,
		questions = { { name = name_parts, type = type, class = class } },
	})
	s = string.char(bit.rshift(#s, 8), bit.band(#s, 0xff)) .. s
	local send, close
	send, close = tcp_client(nameserver, 53, function (s2)
		--[[local length = bit.bor(bit.lshift(s2:byte(1), 8), s2:byte(2))]]
		cb(dns.string_to_dns_message(s2:sub(3)))
		close()
	end, epoll)
	send(s)
	if is_running then epoll:loop() end
end

return mod

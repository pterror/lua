-- TODO

local sha1 = require("dep.sha1").binary
local to_base64 = require("dep.base64").encode
local utf8 = require("lib.utf8")

local mod = {}

-- https://datatracker.ietf.org/doc/html/rfc6455#section-7.4.1
--[[@enum websocket_status]]
mod.status_ids = {
	normal = 1000,
	going_away = 1001,
	protocol_error = 1002,
	unknown_data_format = 1003,
	-- reserved = 1004,
	--[[@deprecated Reserved value. Marked deprecated to ensure it is being used properly.]]
	status_missing = 1005,
	--[[@deprecated Reserved value. Marked deprecated to ensure it is being used properly.]]
	abnormal_closure = 1006,
	-- TODO: what is this
	data_not_consistent_with_message_type = 1007,
	violates_policy = 1008,
	message_too_big = 1009,
	client_server_did_not_negotiate_extensions = 1010,
	server_unexpected_failure = 1011,
	--[[@deprecated Reserved value. Marked deprecated to ensure it is being used properly.]]
	tls_handshake_failure = 1015,
}

--[[@param sock luajitsocket]]
--[[@param body string]]
local err = function (sock, body)
	sock:send("HTTP/1.1 400 Bad Request\r\nContent-Length: " .. #body .. "\r\n\r\n" .. body)
	sock:close()
end

--[[@enum websocket_opcode]]
mod.opcode = {
	continuation = 0, text = 1, binary = 2,
	close = 8, ping = 9, pong = 10,
}

local is_valid_opcode = {
	true, true, true, false, false, false, false, false,
	true, true, true, false, false, false, false, false,
}

--[[@alias websocket_send fun(msg: websocket_message)]]
--[[@alias websocket_close fun()]]

--[[@class websocket_message_base]]
--[[@field type string]]
--[[@field payload string]]

--[[@class websocket_message_text: websocket_message_base]]
--[[@field type "text"]]

--[[@class websocket_message_binary: websocket_message_base]]
--[[@field type "binary"]]

--[[@class websocket_message_close: websocket_message_base]]
--[[@field type "close"]]
--[[@field status integer]]

--[[@class websocket_message_ping: websocket_message_base]]
--[[@field type "ping"]]

--[[@class websocket_message_pong: websocket_message_base]]
--[[@field type "pong"]]
--[[@field payload string Must be the same as the payload of the ping, if sent in response to a ping.]]

--[[@alias websocket_message websocket_message_text|websocket_message_binary|websocket_message_close|websocket_message_ping|websocket_message_pong]]

-- FIXME: should it use string errors?

--[[@enum websocket_error]]
-- **Not** guaranteed to stay the same across versions.  
-- Highly recommended to use the enum members directly
mod.error = { --[[TODO: convert to string]]
	invalid_format = 1,
	invalid_opcode = 2,
	frame_is_not_masked = 3,
	text_frame_not_valid_utf8 = 4,
	control_frame_is_fragmented = 5,
	continuation_frame_as_first_frame = 6,
	continuation_frame_has_incorrect_opcode = 7,
}

local bytes_to_string --[[@type fun(bytes: integer[]): string]]
if jit then
	local ffi = require("ffi")
	bytes_to_string = function (bytes) return ffi.string(ffi.new("const char[?]", #bytes, bytes), #bytes) end
else
	bytes_to_string = function (bytes)
		local chars = {}
		for i = 1, #bytes do chars[i] = string.char(bytes[i]) end
		return table.concat(chars)
	end
end

--[[@class websocket_mask: {[1]:integer;[2]:integer;[3]:integer;[4]:integer;}]]

local mi_next = { 2, 3, 4, 1 }
--[[@return string payload, integer? mi]] --[[@param packet string]] --[[@param i integer]] --[[@param payload_len integer]] --[[@param mask websocket_mask?]] --[[@param mi integer]]
local unmask = function (packet, i, payload_len, mask, mi)
	if mask then
		local bytes = {}
		for j = 1, math.min(payload_len, #packet - i + 1) do
			bytes[j] = bit.bxor(packet:byte(i + j - 1), mask[mi])
			mi = mi_next[mi]
		end
		return bytes_to_string(bytes), mi
	else return packet:sub(i, i + payload_len - 1) end
end

--[[@type websocket_error]]

--[[FIXME: return strings? also return error as second arg, not third]]

--[[Returns a partial websocket message if this is not the last frame in the message,]]
--[[or a websocket message if this is the last frame in the message,]]
--[[or an error code.]]
--[[@return websocket_message? msg, boolean|websocket_error ready_or_error, websocket_mask? mask, integer? mi, integer? remaining_len]] --[[@param packet string]] --[[@param acc? websocket_message]]
local decode = function (packet, acc)
	local h0 = packet:byte(1)
	local fin = bit.band(h0, 0x80) ~= 0 --[[is final packet?]]
	if bit.band(h0, 0x70) ~= 0 then return nil, mod.error.invalid_format end --[[TODO: fail the connection]]
	local opcode = bit.band(h0, 0x0f)
	if not is_valid_opcode[opcode + 1] then return nil, mod.error.invalid_opcode end --[[TODO: fail the connection]]
	local h1 = packet:byte(2)
	local payload_len = bit.band(h1, 0x7f)
	local mask
	local i = 3
	if payload_len == 126 then
		local b1, b2 = packet:byte(3, 4)
		--[[FIXME: compare performance of bitwise vs normal operators]]
		payload_len = bit.bor(bit.lshift(b1, 8), b2)
		i = 5
	elseif payload_len == 127 then
		--[[@type integer, integer, integer, integer, integer, integer, integer, integer]]
		local b1, b2, b3, b4, b5, b6, b7, b8 = packet:byte(3, 10)
		local hi = bit.bor(bit.lshift(b1, 24), bit.lshift(b2, 16), bit.lshift(b3, 8), b4)
		local lo = bit.bor(bit.lshift(b5, 24), bit.lshift(b6, 16), bit.lshift(b7, 8), b8)
		--[[this is a double, not an integer, but realistically you don't need websocket frames that long]]
		payload_len = hi * 0x100000000 + lo
		i = 11
	end
	if bit.band(h1, 0x80) ~= 0 then --[[has mask]]
		mask = { packet:byte(i, i + 3) } --[[@type websocket_mask]]
		i = i + 4
	else return nil, mod.error.frame_is_not_masked end
	local payload, mi = unmask(packet, i, payload_len, mask, 1)
	if not fin and opcode >= 0x8 then return nil, mod.error.control_frame_is_fragmented end
	if opcode == 0x1 then
		if not fin and acc then return nil, mod.error.continuation_frame_has_incorrect_opcode end
		--[[NOTE: almost certainly a perf issue]]
		if not utf8.is_valid(payload) then return nil, mod.error.text_frame_not_valid_utf8 end
		--[[@type websocket_message_text]]
		acc = { type = "text", payload = payload }
	elseif opcode == 0x2 then
		if not fin and acc then return nil, mod.error.continuation_frame_has_incorrect_opcode end
		--[[@type websocket_message_binary]]
		acc = { type = "binary", payload = payload }
	elseif opcode == 0x0 then --[[continuation]]
		if not acc then return nil, mod.error.continuation_frame_as_first_frame end
		acc.payload  = acc.payload .. payload
	elseif opcode == 0x9 then
		--[[TODO: reply with pong?]]
		--[[@type websocket_message_ping]]
		acc = { type = "ping", payload = payload }
	elseif opcode == 0xA then
		--[[@type websocket_message_pong]]
		acc = { type = "pong", payload = payload }
	elseif opcode == 0x8 then
		local status = 0
		if #payload > 0 then
			--[[@type integer, integer]]
			local a, b = payload:byte(1, 2)
			status = bit.bor(bit.lshift(a, 8), b)
		end
		--[[@type websocket_message_close]]
		acc = { type = "close", status = status, payload = payload:sub(3) }
	end
	return acc, fin, mask, mi, (payload_len + i - 1)
	--[[should split payload into extension + application data]]
	--[[(requires implementing extensions)]]
end

--[[@return string? buf]] --[[@param msg websocket_message]]
local encode = function (msg)
	local opcode = mod.opcode[msg.type]
	if not opcode then return end
	local s = string.char(bit.bor(0x80, opcode))
	local len = #msg.payload
	if len <= 125 then
		s = s .. string.char(len)
	elseif len <= 0xffff then
		s = s .. string.char(126, bit.rshift(len, 8), bit.band(len, 0xff))
	else
		local len_hi = math.floor(len / 0x100000000)
		s = s .. string.char(
			127,
			bit.rshift(len_hi, 24), bit.band(bit.rshift(len_hi, 16), 0xff),
			bit.band(bit.rshift(len_hi, 8), 0xff), bit.band(len_hi, 0xff),
			bit.rshift(len, 24), bit.band(bit.rshift(len, 16), 0xff),
			bit.band(bit.rshift(len, 8), 0xff), bit.band(len, 0xff)
		)
	end
	return s .. msg.payload
end

-- TODO: consider limiting packet size

-- TODO: nested function. outer takes the handler, returns function(sock, req)
--[[@return websocket_send? send, websocket_close? close]]
--[[@param sock luajitsocket]]
--[[@param req http_request]]
--[[@param read fun(sock: luajitsocket, msg: websocket_message)]]
--[[@param close fun(sock: luajitsocket)|nil]]
--[[@param epoll epoll]]
mod.websocket = function (sock, req, read, close, epoll)
	if (req.headers["upgrade"] or {})[1] ~= "websocket" or (req.headers["connection"] or {})[1] ~= "Upgrade" then return nil end
	--[[FIXME: return numeric error, let caller decide how to respond]]
	if (req.headers["sec-websocket-version"] or {})[1] ~= "13" then return err(sock, "Unsupported WebSocket version - only v13 supported") end
	--[[chrome supports permessage-deflate and client_max_window_bits]]
	--[[if req.headers["sec-websocket-extensions"] then return err(sock, "WebSocket extensions are not supported") end]]
	local key = (req.headers["sec-websocket-key"] or {})[1]
	if key == nil then return err(sock, "Missing header: Sec-WebSocket-Key") end
	if #key ~= 24 then return err(sock, "Invalid header length - should be 24: Sec-WebSocket-Key") end
	if not key:find("^[A-Za-z0-9+/]+==$") then return err(sock, "Invalid header - not base64: Sec-WebSocket-Key") end
	--[[TODO: check Sec-WebSocket-Protocol... and just reject them all?]]
	local msg, ready, mask, mi
	local remaining_len = 0
	local write, remove = epoll:modify(sock.fd, function ()
		--[[FIXME: set size = 131072 for chrome, but only *after* handling has been fixed]]
		local packet = sock:receive()
		--[[TODO: consider adding `i` parameter to `packet` to avoid `:sub`]]
		if not packet then return end
		while #packet > 0 do
			if remaining_len > 0 then
				local part
				part, mi = unmask(packet, 1, remaining_len, mask, mi)
				msg.payload = msg.payload .. part
			else
				--[[@diagnostic disable-next-line: cast-local-type]]
				msg, ready, mask, mi, remaining_len = decode(packet, msg)
				if not msg then ready = nil; remaining_len = 0; return end --[[errored]]
			end
			local old_packet_len = #packet
			packet = packet:sub(remaining_len + 1)
			remaining_len = remaining_len - old_packet_len
			if ready and remaining_len == 0 then read(sock, msg); msg = nil end
		end
	end, function () if close then close(sock) end end)
	assert(write)
	write((([[
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: ]]..to_base64(sha1(key .. "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"))..[[


]]):gsub("\n", "\r\n")))
	--[[@param msg2 websocket_message]]
	local send = function (msg2)
		local buf = encode(msg2)
		if buf then write(buf) end
	end
	return send, remove
end

return mod

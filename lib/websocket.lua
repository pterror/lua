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
local function err(sock, body)
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

--[[@type websocket_error]]

-- Returns a partial websocket message if this is not the last frame in the message,
-- or a websocket message if this is the last frame in the message,
-- or an error code.
--[[@return websocket_message?, websocket_message?, websocket_error?]] --[[@param packet string]] --[[@param acc websocket_message]]
local decode = function (packet, acc)
	local h0 = packet:byte(1)
	local fin = bit.band(h0, 0x80) ~= 0
	if bit.band(h0, 0x70) ~= 0 then
		-- TODO: fail the connection
		return nil, nil, mod.error.invalid_format
	end
	local opcode = bit.band(h0, 0x0F)
	if not is_valid_opcode[opcode + 1] then
		-- TODO: fail the connection
		return nil, nil, mod.error.invalid_opcode
	end
	local h1 = packet:byte(2)
	local payload_len = bit.band(h1, 0x7F)
	local mask
	local i = 3
	if bit.band(h1, 0x80) ~= 0 then -- has mask
		--[[@type integer, integer, integer, integer]]
		local a, b, c, d = packet:byte(i, i + 3)
		mask = { a, b, c, d }
		i = i + 4
	else
		return nil, nil, mod.error.frame_is_not_masked
	end
	if payload_len == 126 then
		local a, b = packet:byte(i, i + 1)
		-- FIXME: compare performance of bitwise vs normal operators
		payload_len = bit.bor(bit.lshift(a, 8), b)
		i = i + 2
	elseif payload_len == 127 then
		--[[@type integer, integer, integer, integer, integer, integer, integer, integer]]
		local a, b, c, d, e, f, g, h = packet:byte(i, i + 7)
		local hi = bit.bor(bit.lshift(a, 24), bit.lshift(b, 16), bit.lshift(c, 8), d)
		local lo = bit.bor(bit.lshift(e, 24), bit.lshift(f, 16), bit.lshift(g, 8), h)
		-- this is a double, not an integer, but realistically you don't need websocket frames that long
		payload_len = hi * 0x100000000 + lo
		i = i + 8
	end
	local payload
	if mask then
		local bytes = {}
		local mi = 1
		local MI_NEXT = { 2, 3, 4, 1 }
		for j = 1, payload_len do
			bytes[j] = bit.bxor(packet:byte(i + j - 1), mask[mi])
			mi = MI_NEXT[mi]
		end
		payload = string.char(unpack(bytes))
	else
		payload = packet:sub(i, i + payload_len - 1)
	end
	if fin then -- final packet
		-- TODO: if this was multi-packet we don't have opcode
		if opcode == 0x1 then
			-- NOTE: almost certainly a perf issue
			if not utf8.is_valid(payload) then return nil, nil, mod.error.text_frame_not_valid_utf8 end
			--[[@type websocket_message_text]]
			local result = { type = "text", payload = payload }
			return nil, result
		elseif opcode == 0x2 then
			--[[@type websocket_message_binary]]
			local result = { type = "binary", payload = payload }
			return nil, result
		elseif opcode == 0x0 then -- continuation
			-- TODO: how to pass to next call?
			acc.payload  = acc.payload .. payload
			return nil, acc
		elseif opcode == 0x9 then
			-- TODO: reply with pong
			--[[@type websocket_message_ping]]
			local result = { type = "ping", payload = payload }
			return nil, result
		elseif opcode == 0xA then
			--[[@type websocket_message_pong]]
			local result = { type = "pong", payload = payload }
			return nil, result
		elseif opcode == 0x8 then
			local status = 0
			if #payload > 0 then
				--[[@type integer, integer]]
				local a, b = payload:byte(1, 2)
				status = bit.bor(bit.lshift(a, 8), b)
			end
			--[[@type websocket_message_close]]
			local result = { type = "close", status = status, payload = payload:sub(3) }
			return nil, result
		end
	else
		if opcode >= 0x8 then return nil, nil, mod.error.control_frame_is_fragmented end
		if opcode == 0x1 then
			if acc then return nil, nil, mod.error.continuation_frame_has_incorrect_opcode end
			-- NOTE: almost certainly a perf issue
			if not utf8.is_valid(payload) then
				return nil, nil, mod.error.text_frame_not_valid_utf8
			end
			--[[@type websocket_message_text]]
			local result = { type = "text", payload = payload }
			return nil, result
		elseif opcode == 0x2 then
			if acc then return nil, nil, mod.error.continuation_frame_has_incorrect_opcode end
			--[[@type websocket_message_binary]]
			local result = { type = "binary", payload = payload }
			return nil, result
		elseif opcode == 0x0 then -- continuation
			if not acc then return nil, nil, mod.error.continuation_frame_as_first_frame end
			acc.payload  = acc.payload .. payload
			return acc
		end
	end
	--[[should split payload into extension + application data]]
	--[[(requires implementing extensions)]]
end

--[[@return string? buf]] --[[@param msg websocket_message]]
local function encode(msg)
	local opcode = mod.opcode[msg.type]
	if not opcode then return end
	local s = string.char(bit.bor(0x80, opcode))
	local len = #msg.payload
	if len <= 125 then
		s = s .. string.char(len)
	elseif len <= 0xFFFF then
		s = s .. string.char(126, bit.rshift(len, 8), bit.band(len, 0x7F))
	else
		s = s .. string.char(127, bit.rshift(len, 24), bit.band(bit.rshift(len, 16), 0x7F), bit.band(bit.rshift(len, 8), 0x7F), bit.band(len, 0x7F))
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
function mod.websocket(sock, req, read, close, epoll)
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
	local acc, msg
	local write, remove = epoll:modify(sock.fd, function ()
		local packet = sock:receive()
		if not packet then return end
		acc, msg = decode(packet, acc)
		if msg then read(sock, msg); msg = nil end
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

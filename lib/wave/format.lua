local mod = {}

local format_type = { [1] = "pcm", }

--[[@param s string]] --[[@param i integer]]
local string_to_wave = function (s, i)
	if not s:find("^RIFF", i) then return nil, "wave: not RIFF file" end
	local b1, b2, b3, b4 = s:byte(i + 4, i + 7)
	local length = bit.bor(bit.lshift(b4, 24), bit.lshift(b3, 16), bit.lshift(b2, 8), b1)
	if not s:find("^WAVE", i + 8) then return nil, "wave: not WAVE file" end
	if not s:find("^fmt ", i + 12) then return nil, "wave: missing \"fmt \" chunk" end
	--[[b1, b2, b3, b4 = s:byte(i + 16, i + 19)]]
	--[[local format_length = bit.bor(bit.lshift(b4, 24), bit.lshift(b3, 16), bit.lshift(b2, 8), b1)]]
	b1, b2 = s:byte(i + 20, i + 21)
	local format_raw = bit.bor(bit.lshift(b2, 8), b1)
	local format = format_type[format_raw] or format_raw
	b1, b2 = s:byte(i + 22, i + 23)
	local channel_count = bit.bor(bit.lshift(b2, 8), b1)
	b1, b2, b3, b4 = s:byte(i + 24, i + 27)
	local sample_rate = bit.bor(bit.lshift(b4, 24), bit.lshift(b3, 16), bit.lshift(b2, 8), b1)
	b1, b2, b3, b4 = s:byte(i + 28, i + 31)
	local bitrate = bit.bor(bit.lshift(b4, 24), bit.lshift(b3, 16), bit.lshift(b2, 8), b1)
	b1, b2 = s:byte(i + 32, i + 33)
	local bytes_per_instant = bit.bor(bit.lshift(b2, 8), b1)
	b1, b2 = s:byte(i + 34, i + 35)
	local bits_per_sample = bit.bor(bit.lshift(b2, 8), b1)
	if not s:find("^data", i + 36) then return nil, "wave: missing \"data\" chunk" end
	b1, b2, b3, b4 = s:byte(i + 40, i + 43)
	local data_length = bit.bor(bit.lshift(b4, 24), bit.lshift(b3, 16), bit.lshift(b2, 8), b1)
	local data = s:sub(i + 44, i + 44 + data_length - 1)
	return {
		format = format, channel_count = channel_count, sample_rate = sample_rate, bitrate = bitrate,
		bytes_per_instant = bytes_per_instant, bits_per_sample = bits_per_sample, data = data,
	}
end

--[[@param wave string]]
local wave_to_string = function (wave, i)
	local parts = {}
	parts[#parts+1] = "RIFF"
	parts[#parts+1] = "\0\0\0\0" --[[filled in at the end]]
	parts[#parts+1] = "WAVEfmt "
	--[[IMPL]]
	return table.concat(parts)
end

return mod

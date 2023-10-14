local ffi = require("ffi")

local mod = {}

--[[https://gist.github.com/bastibe/f4977c7e8b44a5064bada760902d2176]]

--[[@diagnostic disable: duplicate-doc-alias]]

ffi.cdef [[
	typedef struct {
		int /*pa_sample_format_t*/ format;
		uint32_t rate;
		uint8_t channels;
	} pa_sample_spec;
	typedef struct {
		uint8_t channels;
		int /*pa_channel_position_t*/ map[32 /*PA_CHANNELS_MAX*/];
	} pa_channel_map;
	typedef struct {
		uint32_t maxlength;
		uint32_t tlength;
		uint32_t prebuf;
		uint32_t minreq;
		uint32_t fragsize;
	} pa_buffer_attr;
	typedef struct pa_simple pa_simple;
	pa_simple* pa_simple_new(
		const char *server, const char *name, int /*pa_stream_direction_t*/ dir, const char *dev, const char *stream_name,
		const pa_sample_spec *ss, const pa_channel_map *map, const pa_buffer_attr *attr, int *error
	);
	int pa_simple_read(pa_simple *s, void *data, size_t bytes, int *error);
	int pa_simple_write(pa_simple *s, const void *data, size_t bytes, int *error);
]]

--[[@class pa_simple_ffi]]
--[[@field pa_simple_new fun(server: string?, name: string, dir: pa_stream_direction, dev: string?, stream_name: string, ss: ptr_c<pa_sample_spec_c>, map: ptr_c<pa_channel_map_c>?, attr: ptr_c<pa_buffer_attr_c>?, error: ptr_c<integer>): ptr_c<pa_simple_c>]]
--[[@field pa_simple_read fun(s: ptr_c<pa_simple_c>, data: ffi.cdata*, bytes: integer, error: ptr_c<integer>?): error_c]]
--[[@field pa_simple_write fun(s: ptr_c<pa_simple_c>, data: string, bytes: integer, error: ptr_c<integer>?): error_c]]

--[[@type pa_simple_ffi]]
local pa_simple_ffi = ffi.load("pulse-simple")

--[[@enum pa_stream_direction]]
mod.stream_direction = {
	PA_STREAM_NODIRECTION = 0,
	PA_STREAM_PLAYBACK = 1,
	PA_STREAM_RECORD = 2,
	PA_STREAM_UPLOAD = 3,
}

--[[@enum pa_sample_format]]
mod.sample_format = {
	PA_SAMPLE_U8 = 0,
	PA_SAMPLE_ALAW = 1,
	PA_SAMPLE_ULAW = 2,
	PA_SAMPLE_S16LE = 3,
	PA_SAMPLE_S16BE = 4,
	PA_SAMPLE_FLOAT32LE = 5,
	PA_SAMPLE_FLOAT32BE = 6,
	PA_SAMPLE_S32LE = 7,
	PA_SAMPLE_S32BE = 8,
	PA_SAMPLE_S24LE = 9,
	PA_SAMPLE_S24BE = 10,
	PA_SAMPLE_S24_32LE = 11,
	PA_SAMPLE_S24_32BE = 12,
	PA_SAMPLE_MAX = 13,
	PA_SAMPLE_INVALID = 14,
}

--[[@enum pa_channel_position]]
mod.channel_position = {
	--
}

--[[@class pa_sample_spec_c]]
--[[@field format pa_sample_format]]
--[[@field rate integer]]
--[[@field channels integer]]

--[[@class pa_channel_map_c]]
--[[@field channels integer]]
--[[@field map pa_channel_position[] ]]

--[[@class pa_simple_c opaque]]

--[[@class pa_buffer_attr_c]]
--[[@field maxlength integer]]
--[[@field tlength integer]]
--[[@field prebuf integer]]
--[[@field minreq integer]]
--[[@field fragsize integer]]

local pulseaudio = {} --[[@class pa_simple]]
pulseaudio.__index = pulseaudio

local error_buf = ffi.new("int[1]") --[[@type ptr_c<integer>]]

--[[@param server string?]] --[[@param name string]] --[[@param dir pa_stream_direction]] --[[@param dev string?]] --[[@param stream_name string]] --[[@param ss pa_sample_spec_c]] --[[@param map pa_channel_map_c?, attr: pa_buffer_attr_c?]]
pulseaudio.new = function (self, server, name, dir, dev, stream_name, ss, map, attr)
	local c = pa_simple_ffi.pa_simple_new(server, name, dir, dev, stream_name, ss, map, attr, error_buf)
	if error_buf[0] ~= 0 then return nil, error_buf[0] end
	local ret = { c = c } --[[@class pa_simple]]
	return setmetatable(ret, self)
end
--[[@param server string?]] --[[@param name string]] --[[@param dir pa_stream_direction]] --[[@param dev string?]] --[[@param stream_name string]] --[[@param ss pa_sample_spec_c]] --[[@param map pa_channel_map_c?, attr: pa_buffer_attr_c?]]
mod.new = function (server, name, dir, dev, stream_name, ss, map, attr)
	return pulseaudio:new(server, name, dir, dev, stream_name, ss, map, attr)
end

pulseaudio.read = function (self)
	local buf = ffi.new("char[65536]") --[[TODO: variable size]]
	if pa_simple_ffi.pa_simple_read(self.c, buf, #buf, error_buf) < 0 then return nil, error_buf[0] end
	return buf
end

pulseaudio.write = function (self, data)
	if pa_simple_ffi.pa_simple_write(self.c, data, #data, error_buf) < 0 then return nil, error_buf[0] end
	return true
end

return mod

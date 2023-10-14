local ffi = require("ffi")

--[[IMPL]]

--[[@diagnostic disable: duplicate-doc-alias]]

local mod = {}

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
  typedef struct pa_mainloop pa_mainloop;
  typedef int(* pa_poll_func)(struct pollfd *ufds, unsigned long nfds, int timeout, void *userdata);
  pa_mainloop *pa_mainloop_new(void);
  int pa_mainloop_poll(pa_mainloop *m);
  int pa_mainloop_prepare(pa_mainloop *m, int timeout);
  void pa_mainloop_quit(pa_mainloop *m, int retval);
  int pa_mainloop_quit(pa_mainloop *m, int *retval);
  void pa_mainloop_set_poll_func(pa_mainloop *m, pa_poll_func poll_func, void *userdata);
  void pa_mainloop_wakeup(pa_mainloop *m);
]]

--[[@class pollfd_c]]

--[[@class pa_async_ffi]]
--[[@field pa_mainloop_new fun(): ptr_c<pa_mainloop_c>]]
--[[@field pa_mainloop_poll fun(m: ptr_c<pa_mainloop_c>): error_c]]
--[[@field pa_mainloop_prepare fun(m: ptr_c<pa_mainloop_c>, timeout: integer): error_c]]
--[[@field pa_mainloop_quit fun(m: ptr_c<pa_mainloop_c>, retval: integer)]]
--[[@field pa_mainloop_set_poll_func fun(m: ptr_c<pa_mainloop_c>, poll_func: pa_poll_func_c, userdata: ffi.cdata*)]]
--[[@field pa_mainloop_wakeup fun(m: ptr_c<pa_mainloop_c>)]]

--[[@alias pa_poll_func_c fun(ufds: pollfd_c[], nfds: integer, timeout: integer, userdata: ffi.cdata*)]]

--[[@class pa_mainloop_c]]

--[[@type pa_async_ffi]]
local pa_async_ffi = ffi.load("pulse-async") --[[FIXME: correct name]]

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
	--[[FIXME:]]
}

local pulseaudio = {} --[[@class pa_asynchronous]]
pulseaudio.__index = pulseaudio

local error_buf = ffi.new("int[1]") --[[@type ptr_c<integer>]]

pulseaudio.new = function (self)
	local c = pa_async_ffi.pa_mainloop_new()
	if error_buf[0] ~= 0 then return nil, error_buf[0] end
	return setmetatable({ --[[@class pa_simple]]
		c = c,
	}, self)
end
mod.new = function () return pulseaudio:new() end

return mod

#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local soloud_mod = require("dep.soloud")
local soloud = soloud_mod.Soloud_create()
soloud_mod.Soloud_init(soloud)

local sound_path = arg[1]
if not sound_path then
	io.stderr:write("keysounds: usage: `keysounds.lua ~/path/to/sounds/`")
	return os.exit(1)
end

local read_all = function (path)
	local f = io.open(path)
	if not f then return end
	local ret = f:read("*all")
	f:close()
	return ret
end

local config = assert(require("dep.lunajson").json_to_value(read_all(sound_path .. "/config.json")))
package.loaded["dep.lunajson"] = nil

local ffi = require("ffi")
local xlib = require("dep.xlib")
local d = assert(xlib.display:new())

--[[ignored: id, name, key_define_type, includes_numpad]]
local default_sound --[[@type ptr_c<soloud_wav_c>]]
if config.sound then
	local path = sound_path .. "/" .. config.sound
	--[[@diagnostic disable-next-line: cast-local-type]]
	default_sound = soloud_mod.Wav_create()
	soloud_mod.Wav_load(default_sound, path)
end
local path_to_sound = {} --[[@type table<string, ptr_c<soloud_wav_c>>]]
local keycode_to_sound = {} --[[@type table<integer, ptr_c<soloud_wav_c>>]]
for k, v in pairs(config.defines) do
	local path = sound_path .. "/" .. v
	local sound = path_to_sound[path]
	if not sound then
		sound = soloud_mod.Wav_create()
		soloud_mod.Wav_load(sound, path)
		path_to_sound[path] = sound
	end
	default_sound = default_sound or sound
	keycode_to_sound[tonumber(k)] = sound
end
--[[@diagnostic disable-next-line: cast-local-type]]
read_all = nil
--[[@diagnostic disable-next-line: cast-local-type]]
path_to_sound = nil

--[[i don't have `rwin`; `function` doesn't emit an event  ]]
--[[rustyvibes is missing keycodes for `delete` and `rctrl`  ]]
--[[keycode to windows, not keysym to windows]]
local key_map = {
	--[[1-9 and 0-=]]
	[10] = 2, [11] = 3, [12] = 4, [13] = 5, [14] = 6, [15] = 7, [16] = 8, [17] = 9, [18] = 10, [19] = 11, [20] = 12, [21] = 13,
	--[[q-p and [] ]]
	[24] = 16, [25] = 17, [26] = 18, [27] = 19, [28] = 20, [29] = 21, [30] = 22, [31] = 23, [32] = 24, [33] = 25, [34] = 26, [35] = 27,
	--[[a-l and ;']]
	[38] = 30, [39] = 31, [40] = 32, [41] = 33, [42] = 34, [43] = 35, [44] = 36, [45] = 37, [46] = 38, [47] = 39, [48] = 40,
	--[[z-m and ,./]]
	[52] = 44, [53] = 45, [54] = 46, [55] = 47, [56] = 48, [57] = 49, [58] = 50, [59] = 51, [60] = 52, [61] = 53,
	--[[f1-f10]]
	[67] = 59, [68] = 60, [69] = 61, [70] = 62, [71] = 63, [72] = 64, [73] = 65, [74] = 66, [75] = 67, [76] = 68,
	--[[esc, lalt, f11, f12, ralt, up, left, right, down]]
	[9] = 1, [64] = 56, [95] = 87, [96] = 88, [108] = 3640, [111] = 57416, [113] = 57419, [114] = 57421, [116] = 57424,
	--[[backspace, tab, return, lctrl, `, lshift, \, rshift, tab, rctrl, win]]
	[22] = 14, [23] = 15, [36] = 28, [37] = 29, [49] = 41, [50] = 42, [51] = 43, [62] = 54, [65] = 57, [105] = 29, [133] = 3675,
}

local rr = xlib.record_alloc_range()
rr.device_events.first = xlib.event_type.key_press
rr.device_events.last = xlib.event_type.key_press
local rcs = ffi.new("uint64_t[1]", xlib.record_client_filter.all)
local rrs = ffi.new("XRecordRange *[1]", rr)
local rc = d:record_create_context(0, rcs, 1, rrs, 1)
xlib.free(rr)
d:record_enable_context(rc, function (_, data)
	if data[0].category ~= xlib.record_category.from_server then return end
	local buf = ffi.cast("unsigned char *", data[0].data)
	if buf[2] ~= 0 then return end --[[held key]]
	local key = key_map[buf[1]]
	local sound = key and keycode_to_sound[key] or default_sound
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if sound then soloud_mod.Soloud_play(soloud, sound) end
end, ffi.new("char[0]"))

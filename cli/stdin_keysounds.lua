#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local soloud_mod = require("dep.soloud")
local soloud = soloud_mod.Soloud_create()
soloud_mod.Soloud_init(soloud)

local sound_path = arg[1]
if not sound_path then
	io.stderr:write("showmethekey_keysounds: usage: `showmethekey_keysounds.lua ~/path/to/sounds/`")
	return os.exit(1)
end

--[[@param path string]]
local read_all = function (path)
	local f = io.open(path)
	if not f then return end
	--[[@type string]]
	local ret = f:read("*all")
	f:close()
	return ret
end

local config = assert( require("dep.lunajson").json_to_value(assert(read_all(sound_path .. "/config.json"))))
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
--[[keycode to windows keycode]]
local key_map = {
	--[[ralt, up, left, right, down, win]]
	[100] = 3640, [103] = 57416, [105] = 57419, [106] = 57421, [108] = 57424, [125] = 3675,
	--[[pgup, pgdn, home, end, delete]]
	[104] = 57416, [109] = 57424, [102] = 57419, [107] = 57421, [111] = 57427,
}

local epoll = require("dep.epoll").new()

--[[@diagnostic disable-next-line: param-type-mismatch]]
epoll:add(0, function (data)
	local keycode = tonumber(data)
	local sound = keycode_to_sound[key_map[keycode]] or keycode_to_sound[keycode] or keycode_to_sound[1]
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if sound then soloud_mod.Soloud_play(soloud, sound) end
end)

epoll:loop()

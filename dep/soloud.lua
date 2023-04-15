--[[SoLoud audio engine
Copyright (c) 2013-2020 Jari Komppa

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.
]]

local ffi = require("ffi")

local dir_path = debug.getinfo(1, "S").source:sub(2):gsub("[^\\/]+$", "")

--[[@type soloud_ffi]]
local soloud_ffi
if ffi.os == "Linux" then
	soloud_ffi = ffi.load(dir_path .. "libsoloud.so")
elseif ffi.os == "Windows" then
	if ffi.arch == "x64" then
		soloud_ffi = ffi.load(dir_path .. "soloud.dll")
	else --[[assume x86]]
		soloud_ffi = ffi.load(dir_path .. "soloud-x86.dll")
	end
end

--[[@class soloud_file_c]]
--[[@class soloud_audio_attenuator_c]]
--[[@class soloud_audio_collider_c]]
--[[@class soloud_audio_source_c]]
--[[@class soloud_filter_c]]

--[[@class soloud_c]]
--[[@class soloud_ay_c]]
--[[@class soloud_bassboost_filter_c]]
--[[@class soloud_biquad_resonant_filter_c]]
--[[@class soloud_bus_c]]
--[[@class soloud_dc_removal_filter_c]]
--[[@class soloud_echo_filter_c]]
--[[@class soloud_fft_filter_c]]
--[[@class soloud_flanger_filter_c]]
--[[@class soloud_freeverb_filter_c]]
--[[@class soloud_lofi_filter_c]]
--[[@class soloud_monotone_c]]
--[[@class soloud_noise_c]]
--[[@class soloud_openmpt_c]]
--[[@class soloud_queue_c]]
--[[@class soloud_robotize_filter_c]]
--[[@class soloud_sfxr_c]]
--[[@class soloud_speech_c]]
--[[@class soloud_tedsid_c]]
--[[@class soloud_vic_c]]
--[[@class soloud_vizsn_c]]
--[[@class soloud_wav_c]]
--[[@class soloud_wave_shaper_filter_c]]
--[[@class soloud_wav_stream_c]]

--[[@class soloud_ffi]]
--[[@field Soloud_destroy fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_create fun(): ptr_c<soloud_c>]]
--[[@field Soloud_init fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_initEx fun(x: ptr_c<soloud_c>, flags: integer, backend: integer, sample_rate: integer, buffer_size: integer, channels: integer)]]
--[[@field Soloud_deinit fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_getVersion fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_getErrorString fun(x: ptr_c<soloud_c>, error_code: integer): string]]
--[[@field Soloud_getBackendId fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getBackendString fun(x: ptr_c<soloud_c>): string]]
--[[@field Soloud_getBackendChannels fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getBackendSamplerate fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getBackendBufferSize fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_setSpeakerPosition fun(x: ptr_c<soloud_c>, channel: integer, x: number, y: number, z: number): integer]]
--[[@field Soloud_getSpeakerPosition fun(x: ptr_c<soloud_c>, channel: integer, x: ptr_c<number>, y: ptr_c<number>, z: ptr_c<number>): integer]]
--[[@field Soloud_play fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Soloud_playEx fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>, volume: number, pan: number, paused: integer, bus: integer): integer]]
--[[@field Soloud_playClocked fun(x: ptr_c<soloud_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Soloud_playClockedEx fun(x: ptr_c<soloud_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, volume: number, pan: number, bus: integer): integer]]
--[[@field Soloud_play3d fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number): integer]]
--[[@field Soloud_play3dEx fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number, vel_x: number, vel_y: number, vel_z: number, volume: number, paused: integer, bus: integer): integer]]
--[[@field Soloud_play3dClocked fun(x: ptr_c<soloud_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number): integer]]
--[[@field Soloud_play3dClockedEx fun(x: ptr_c<soloud_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number, vel_x: number, vel_y: number, vel_z: number, volume: number, bus: integer): integer]]
--[[@field Soloud_playBackground fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Soloud_playBackgroundEx fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>, volume: number, paused: integer, bus: integer): integer]]
--[[@field Soloud_seek fun(x: ptr_c<soloud_c>, voice_handle: integer, seconds: number): integer]]
--[[@field Soloud_stop fun(x: ptr_c<soloud_c>, voice_handle: integer)]]
--[[@field Soloud_stopAll fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_stopAudioSource fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>)]]
--[[@field Soloud_countAudioSource fun(x: ptr_c<soloud_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Soloud_setFilterParameter fun(x: ptr_c<soloud_c>, voice_handle: integer, filter_id: integer, attribute_id: integer, value: number)]]
--[[@field Soloud_getFilterParameter fun(x: ptr_c<soloud_c>, voice_handle: integer, filter_id: integer, attribute_id: integer): number]]
--[[@field Soloud_fadeFilterParameter fun(x: ptr_c<soloud_c>, voice_handle: integer, filter_id: integer, attribute_id: integer, to: number, time: number)]]
--[[@field Soloud_oscillateFilterParameter fun(x: ptr_c<soloud_c>, voice_handle: integer, filter_id: integer, attribute_id: integer, from: number, to: number, time: number)]]
--[[@field Soloud_getStreamTime fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getStreamPosition fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getPause fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getVolume fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getOverallVolume fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getPan fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getSamplerate fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getProtectVoice fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getActiveVoiceCount fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getVoiceCount fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_isValidVoiceHandle fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getRelativePlaySpeed fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_getPostClipScaler fun(x: ptr_c<soloud_c>): number]]
--[[@field Soloud_getMainResampler fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getGlobalVolume fun(x: ptr_c<soloud_c>): number]]
--[[@field Soloud_getMaxActiveVoiceCount fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_getLooping fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getAutoStop fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getLoopPoint fun(x: ptr_c<soloud_c>, voice_handle: integer): number]]
--[[@field Soloud_setLoopPoint fun(x: ptr_c<soloud_c>, voice_handle: integer, loop_point: number)]]
--[[@field Soloud_setLooping fun(x: ptr_c<soloud_c>, voice_handle: integer, looping: integer)]]
--[[@field Soloud_setAutoStop fun(x: ptr_c<soloud_c>, voice_handle: integer, auto_stop: integer)]]
--[[@field Soloud_setMaxActiveVoiceCount fun(x: ptr_c<soloud_c>, voice_count: integer): integer]]
--[[@field Soloud_setInaudibleBehavior fun(x: ptr_c<soloud_c>, voice_handle: integer, must_tick: integer, kill: integer)]]
--[[@field Soloud_setGlobalVolume fun(x: ptr_c<soloud_c>, volume: number)]]
--[[@field Soloud_setPostClipScaler fun(x: ptr_c<soloud_c>, scaler: number)]]
--[[@field Soloud_setMainResampler fun(x: ptr_c<soloud_c>, resampler: integer)]]
--[[@field Soloud_setPause fun(x: ptr_c<soloud_c>, voice_handle: integer, pause: integer)]]
--[[@field Soloud_setPauseAll fun(x: ptr_c<soloud_c>, pause: integer)]]
--[[@field Soloud_setRelativePlaySpeed fun(x: ptr_c<soloud_c>, voice_handle: integer, speed: number): integer]]
--[[@field Soloud_setProtectVoice fun(x: ptr_c<soloud_c>, voice_handle: integer, protect: integer)]]
--[[@field Soloud_setSamplerate fun(x: ptr_c<soloud_c>, voice_handle: integer, samplerate: number)]]
--[[@field Soloud_setPan fun(x: ptr_c<soloud_c>, voice_handle: integer, pan: number)]]
--[[@field Soloud_setPanAbsolute fun(x: ptr_c<soloud_c>, voice_handle: integer, l_volume: number, r_volume: number)]]
--[[@field Soloud_setChannelVolume fun(x: ptr_c<soloud_c>, voice_handle: integer, channel: integer, volume: number)]]
--[[@field Soloud_setVolume fun(x: ptr_c<soloud_c>, voice_handle: integer, volume: number)]]
--[[@field Soloud_setDelaySamples fun(x: ptr_c<soloud_c>, voice_handle: integer, samples: integer)]]
--[[@field Soloud_fadeVolume fun(x: ptr_c<soloud_c>, voice_handle: integer, to: number, time: number)]]
--[[@field Soloud_fadePan fun(x: ptr_c<soloud_c>, voice_handle: integer, to: number, time: number)]]
--[[@field Soloud_fadeRelativePlaySpeed fun(x: ptr_c<soloud_c>, voice_handle: integer, to: number, time: number)]]
--[[@field Soloud_fadeGlobalVolume fun(x: ptr_c<soloud_c>, to: number, time: number)]]
--[[@field Soloud_schedulePause fun(x: ptr_c<soloud_c>, voice_handle: integer, time: number)]]
--[[@field Soloud_scheduleStop fun(x: ptr_c<soloud_c>, voice_handle: integer, time: number)]]
--[[@field Soloud_oscillateVolume fun(x: ptr_c<soloud_c>, voice_handle: integer, from: number, to: number, time: number)]]
--[[@field Soloud_oscillatePan fun(x: ptr_c<soloud_c>, voice_handle: integer, from: number, to: number, time: number)]]
--[[@field Soloud_oscillateRelativePlaySpeed fun(x: ptr_c<soloud_c>, voice_handle: integer, from: number, to: number, time: number)]]
--[[@field Soloud_oscillateGlobalVolume fun(x: ptr_c<soloud_c>, from: number, to: number, time: number)]]
--[[@field Soloud_setGlobalFilter fun(x: ptr_c<soloud_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Soloud_setVisualizationEnable fun(x: ptr_c<soloud_c>, enable: integer)]]
--[[@field Soloud_calcFFT fun(x: ptr_c<soloud_c>): ptr_c<number>]]
--[[@field Soloud_getWave fun(x: ptr_c<soloud_c>): ptr_c<number>]]
--[[@field Soloud_getApproximateVolume fun(x: ptr_c<soloud_c>, channel: integer): number]]
--[[@field Soloud_getLoopCount fun(x: ptr_c<soloud_c>, voice_handle: integer): integer]]
--[[@field Soloud_getInfo fun(x: ptr_c<soloud_c>, voice_handle: integer, info_key: integer): number]]
--[[@field Soloud_createVoiceGroup fun(x: ptr_c<soloud_c>): integer]]
--[[@field Soloud_destroyVoiceGroup fun(x: ptr_c<soloud_c>, voice_group_handle: integer): integer]]
--[[@field Soloud_addVoiceToGroup fun(x: ptr_c<soloud_c>, voice_group_handle: integer, voice_handle: integer): integer]]
--[[@field Soloud_isVoiceGroup fun(x: ptr_c<soloud_c>, voice_group_handle: integer): integer]]
--[[@field Soloud_isVoiceGroupEmpty fun(x: ptr_c<soloud_c>, voice_group_handle: integer): integer]]
--[[@field Soloud_update3dAudio fun(x: ptr_c<soloud_c>)]]
--[[@field Soloud_set3dSoundSpeed fun(x: ptr_c<soloud_c>, speed: number): integer]]
--[[@field Soloud_get3dSoundSpeed fun(x: ptr_c<soloud_c>): number]]
--[[@field Soloud_set3dListenerParameters fun(x: ptr_c<soloud_c>, pos_x: number, pos_y: number, pos_z: number, at_x: number, at_y: number, at_z: number, a_up_x: number, a_up_y: number, a_up_z: number)]]
--[[@field Soloud_set3dListenerParametersEx fun(x: ptr_c<soloud_c>, pos_x: number, pos_y: number, pos_z: number, at_x: number, at_y: number, at_z: number, a_up_x: number, a_up_y: number, a_up_z: number, velocity_x: number, velocityY: number, velocityZ: number)]]
--[[@field Soloud_set3dListenerPosition fun(x: ptr_c<soloud_c>, pos_x: number, pos_y: number, pos_z: number)]]
--[[@field Soloud_set3dListenerAt fun(x: ptr_c<soloud_c>, at_x: number, at_y: number, at_z: number)]]
--[[@field Soloud_set3dListenerUp fun(x: ptr_c<soloud_c>, a_up_x: number, a_up_y: number, a_up_z: number)]]
--[[@field Soloud_set3dListenerVelocity fun(x: ptr_c<soloud_c>, velocity_x: number, velocity_y: number, velocity_z: number)]]
--[[@field Soloud_set3dSourceParameters fun(x: ptr_c<soloud_c>, voice_handle: integer, pos_x: number, pos_y: number, pos_z: number)]]
--[[@field Soloud_set3dSourceParametersEx fun(x: ptr_c<soloud_c>, voice_handle: integer, pos_x: number, pos_y: number, pos_z: number, velocity_x: number, velocity_y: number, velocity_z: number)]]
--[[@field Soloud_set3dSourcePosition fun(x: ptr_c<soloud_c>, voice_handle: integer, pos_x: number, pos_y: number, pos_z: number)]]
--[[@field Soloud_set3dSourceVelocity fun(x: ptr_c<soloud_c>, voice_handle: integer, velocity_x: number, velocity_y: number, velocity_z: number)]]
--[[@field Soloud_set3dSourceMinMaxDistance fun(x: ptr_c<soloud_c>, voice_handle: integer, min_distance: number, max_distance: number)]]
--[[@field Soloud_set3dSourceAttenuation fun(x: ptr_c<soloud_c>, voice_handle: integer, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Soloud_set3dSourceDopplerFactor fun(x: ptr_c<soloud_c>, voice_handle: integer, doppler_factor: number)]]
--[[@field Soloud_mix fun(x: ptr_c<soloud_c>, buffer: ptr_c<number>, samples: integer)]]
--[[@field Soloud_mixSigned16 fun(x: ptr_c<soloud_c>, buffer: ptr_c<integer>, samples: integer)]]
--[[@field Ay_destroy fun(x: ptr_c<soloud_ay_c>)]]
--[[@field Ay_create fun(): ptr_c<soloud_ay_c>]]
--[[@field Ay_setVolume fun(x: ptr_c<soloud_ay_c>, volume: number)]]
--[[@field Ay_setLooping fun(x: ptr_c<soloud_ay_c>, loop: integer)]]
--[[@field Ay_setAutoStop fun(x: ptr_c<soloud_ay_c>, auto_stop: integer)]]
--[[@field Ay_set3dMinMaxDistance fun(x: ptr_c<soloud_ay_c>, min_distance: number, max_distance: number)]]
--[[@field Ay_set3dAttenuation fun(x: ptr_c<soloud_ay_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Ay_set3dDopplerFactor fun(x: ptr_c<soloud_ay_c>, doppler_factor: number)]]
--[[@field Ay_set3dListenerRelative fun(x: ptr_c<soloud_ay_c>, listener_relative: integer)]]
--[[@field Ay_set3dDistanceDelay fun(x: ptr_c<soloud_ay_c>, distance_delay: integer)]]
--[[@field Ay_set3dCollider fun(x: ptr_c<soloud_ay_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Ay_set3dColliderEx fun(x: ptr_c<soloud_ay_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Ay_set3dAttenuator fun(x: ptr_c<soloud_ay_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Ay_setInaudibleBehavior fun(x: ptr_c<soloud_ay_c>, must_tick: integer, kill: integer)]]
--[[@field Ay_setLoopPoint fun(x: ptr_c<soloud_ay_c>, loop_point: ptr_c<number>)]]
--[[@field Ay_getLoopPoint fun(x: ptr_c<soloud_ay_c>): number]]
--[[@field Ay_setFilter fun(x: ptr_c<soloud_ay_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Ay_stop fun(x: ptr_c<soloud_ay_c>)]]
--[[@field BassboostFilter_destroy fun(x: ptr_c<soloud_bassboost_filter_c>)]]
--[[@field BassboostFilter_getParamCount fun(x: ptr_c<soloud_bassboost_filter_c>): integer]]
--[[@field BassboostFilter_getParamName fun(x: ptr_c<soloud_bassboost_filter_c>, param_index: integer): string]]
--[[@field BassboostFilter_getParamType fun(x: ptr_c<soloud_bassboost_filter_c>, param_index: integer): integer]]
--[[@field BassboostFilter_getParamMax fun(x: ptr_c<soloud_bassboost_filter_c>, param_index: integer): number]]
--[[@field BassboostFilter_getParamMin fun(x: ptr_c<soloud_bassboost_filter_c>, param_index: integer): number]]
--[[@field BassboostFilter_setParams fun(x: ptr_c<soloud_bassboost_filter_c>, boost: number): integer]]
--[[@field BassboostFilter_create fun(): ptr_c<soloud_bassboost_filter_c>]]
--[[@field BiquadResonantFilter_destroy fun(x: ptr_c<soloud_biquad_resonant_filter_c>)]]
--[[@field BiquadResonantFilter_getParamCount fun(x: ptr_c<soloud_biquad_resonant_filter_c>): integer]]
--[[@field BiquadResonantFilter_getParamName fun(x: ptr_c<soloud_biquad_resonant_filter_c>, param_index: integer): string]]
--[[@field BiquadResonantFilter_getParamType fun(x: ptr_c<soloud_biquad_resonant_filter_c>, param_index: integer): integer]]
--[[@field BiquadResonantFilter_getParamMax fun(x: ptr_c<soloud_biquad_resonant_filter_c>, param_index: integer): number]]
--[[@field BiquadResonantFilter_getParamMin fun(x: ptr_c<soloud_biquad_resonant_filter_c>, param_index: integer): number]]
--[[@field BiquadResonantFilter_create fun(): ptr_c<soloud_biquad_resonant_filter_c>]]
--[[@field BiquadResonantFilter_setParams fun(x: ptr_c<soloud_biquad_resonant_filter_c>, type: integer, frequency: number, resonance: number): integer]]
--[[@field Bus_destroy fun(x: ptr_c<soloud_bus_c>)]]
--[[@field Bus_create fun(): ptr_c<soloud_bus_c>]]
--[[@field Bus_setFilter fun(x: ptr_c<soloud_bus_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Bus_play fun(x: ptr_c<soloud_bus_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Bus_playEx fun(x: ptr_c<soloud_bus_c>, sound: ptr_c<soloud_audio_source_c>, volume: number, pan: number, paused: integer): integer]]
--[[@field Bus_playClocked fun(x: ptr_c<soloud_bus_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Bus_playClockedEx fun(x: ptr_c<soloud_bus_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, volume: number, pan: number): integer]]
--[[@field Bus_play3d fun(x: ptr_c<soloud_bus_c>, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number): integer]]
--[[@field Bus_play3dEx fun(x: ptr_c<soloud_bus_c>, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number, vel_x: number, vel_y: number, vel_z: number, volume: number, paused: integer): integer]]
--[[@field Bus_play3dClocked fun(x: ptr_c<soloud_bus_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number): integer]]
--[[@field Bus_play3dClockedEx fun(x: ptr_c<soloud_bus_c>, sound_time: number, sound: ptr_c<soloud_audio_source_c>, pos_x: number, pos_y: number, pos_z: number, vel_x: number, vel_y: number, vel_z: number, volume: number): integer]]
--[[@field Bus_setChannels fun(x: ptr_c<soloud_bus_c>, channels: integer): integer]]
--[[@field Bus_setVisualizationEnable fun(x: ptr_c<soloud_bus_c>, enable: integer)]]
--[[@field Bus_annexSound fun(x: ptr_c<soloud_bus_c>, voice_handle: integer)]]
--[[@field Bus_calcFFT fun(x: ptr_c<soloud_bus_c>): ptr_c<number>]]
--[[@field Bus_getWave fun(x: ptr_c<soloud_bus_c>): ptr_c<number>]]
--[[@field Bus_getApproximateVolume fun(x: ptr_c<soloud_bus_c>, channel: integer): number]]
--[[@field Bus_getActiveVoiceCount fun(x: ptr_c<soloud_bus_c>): integer]]
--[[@field Bus_getResampler fun(x: ptr_c<soloud_bus_c>): integer]]
--[[@field Bus_setResampler fun(x: ptr_c<soloud_bus_c>, resampler: integer)]]
--[[@field Bus_setVolume fun(x: ptr_c<soloud_bus_c>, volume: number)]]
--[[@field Bus_setLooping fun(x: ptr_c<soloud_bus_c>, loop: integer)]]
--[[@field Bus_setAutoStop fun(x: ptr_c<soloud_bus_c>, auto_stop: integer)]]
--[[@field Bus_set3dMinMaxDistance fun(x: ptr_c<soloud_bus_c>, min_distance: number, max_distance: number)]]
--[[@field Bus_set3dAttenuation fun(x: ptr_c<soloud_bus_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Bus_set3dDopplerFactor fun(x: ptr_c<soloud_bus_c>, doppler_factor: number)]]
--[[@field Bus_set3dListenerRelative fun(x: ptr_c<soloud_bus_c>, listener_relative: integer)]]
--[[@field Bus_set3dDistanceDelay fun(x: ptr_c<soloud_bus_c>, distance_delay: integer)]]
--[[@field Bus_set3dCollider fun(x: ptr_c<soloud_bus_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Bus_set3dColliderEx fun(x: ptr_c<soloud_bus_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Bus_set3dAttenuator fun(x: ptr_c<soloud_bus_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Bus_setInaudibleBehavior fun(x: ptr_c<soloud_bus_c>, must_tick: integer, kill: integer)]]
--[[@field Bus_setLoopPoint fun(x: ptr_c<soloud_bus_c>, loop_point: number)]]
--[[@field Bus_getLoopPoint fun(x: ptr_c<soloud_bus_c>): number]]
--[[@field Bus_stop fun(x: ptr_c<soloud_bus_c>)]]
--[[@field DCRemovalFilter_destroy fun(x: ptr_c<soloud_dc_removal_filter_c>)]]
--[[@field DCRemovalFilter_create fun(): ptr_c<soloud_dc_removal_filter_c>]]
--[[@field DCRemovalFilter_setParams fun(x: ptr_c<soloud_dc_removal_filter_c>): integer]]
--[[@field DCRemovalFilter_setParamsEx fun(x: ptr_c<soloud_dc_removal_filter_c>, length: number): integer]]
--[[@field DCRemovalFilter_getParamCount fun(x: ptr_c<soloud_dc_removal_filter_c>): integer]]
--[[@field DCRemovalFilter_getParamName fun(x: ptr_c<soloud_dc_removal_filter_c>, param_index: integer): string]]
--[[@field DCRemovalFilter_getParamType fun(x: ptr_c<soloud_dc_removal_filter_c>, param_index: integer): integer]]
--[[@field DCRemovalFilter_getParamMax fun(x: ptr_c<soloud_dc_removal_filter_c>, param_index: integer): number]]
--[[@field DCRemovalFilter_getParamMin fun(x: ptr_c<soloud_dc_removal_filter_c>, param_index: integer): number]]
--[[@field EchoFilter_destroy fun(x: ptr_c<soloud_echo_filter_c>)]]
--[[@field EchoFilter_getParamCount fun(x: ptr_c<soloud_echo_filter_c>): integer]]
--[[@field EchoFilter_getParamName fun(x: ptr_c<soloud_echo_filter_c>, param_index: integer): string]]
--[[@field EchoFilter_getParamType fun(x: ptr_c<soloud_echo_filter_c>, param_index: integer): integer]]
--[[@field EchoFilter_getParamMax fun(x: ptr_c<soloud_echo_filter_c>, param_index: integer): number]]
--[[@field EchoFilter_getParamMin fun(x: ptr_c<soloud_echo_filter_c>, param_index: integer): number]]
--[[@field EchoFilter_create fun(): ptr_c<soloud_echo_filter_c>]]
--[[@field EchoFilter_setParams fun(x: ptr_c<soloud_echo_filter_c>, delay: number): integer]]
--[[@field EchoFilter_setParamsEx fun(x: ptr_c<soloud_echo_filter_c>, delay: number, decay: number, filter: number): integer]]
--[[@field FFTFilter_destroy fun(x: ptr_c<soloud_fft_filter_c>)]]
--[[@field FFTFilter_create fun(): ptr_c<soloud_fft_filter_c>]]
--[[@field FFTFilter_getParamCount fun(x: ptr_c<soloud_fft_filter_c>): integer]]
--[[@field FFTFilter_getParamName fun(x: ptr_c<soloud_fft_filter_c>, param_index: integer): string]]
--[[@field FFTFilter_getParamType fun(x: ptr_c<soloud_fft_filter_c>, param_index: integer): integer]]
--[[@field FFTFilter_getParamMax fun(x: ptr_c<soloud_fft_filter_c>, param_index: integer): number]]
--[[@field FFTFilter_getParamMin fun(x: ptr_c<soloud_fft_filter_c>, param_index: integer): number]]
--[[@field FlangerFilter_destroy fun(x: ptr_c<soloud_flanger_filter_c>)]]
--[[@field FlangerFilter_getParamCount fun(x: ptr_c<soloud_flanger_filter_c>): integer]]
--[[@field FlangerFilter_getParamName fun(x: ptr_c<soloud_flanger_filter_c>, param_index: integer): string]]
--[[@field FlangerFilter_getParamType fun(x: ptr_c<soloud_flanger_filter_c>, param_index: integer): integer]]
--[[@field FlangerFilter_getParamMax fun(x: ptr_c<soloud_flanger_filter_c>, param_index: integer): number]]
--[[@field FlangerFilter_getParamMin fun(x: ptr_c<soloud_flanger_filter_c>, param_index: integer): number]]
--[[@field FlangerFilter_create fun(): ptr_c<soloud_flanger_filter_c>]]
--[[@field FlangerFilter_setParams fun(x: ptr_c<soloud_flanger_filter_c>, delay: number, freq: number): integer]]
--[[@field FreeverbFilter_destroy fun(x: ptr_c<soloud_freeverb_filter_c>)]]
--[[@field FreeverbFilter_getParamCount fun(x: ptr_c<soloud_freeverb_filter_c>): integer]]
--[[@field FreeverbFilter_getParamName fun(x: ptr_c<soloud_freeverb_filter_c>, param_index: integer): string]]
--[[@field FreeverbFilter_getParamType fun(x: ptr_c<soloud_freeverb_filter_c>, param_index: integer): integer]]
--[[@field FreeverbFilter_getParamMax fun(x: ptr_c<soloud_freeverb_filter_c>, param_index: integer): number]]
--[[@field FreeverbFilter_getParamMin fun(x: ptr_c<soloud_freeverb_filter_c>, param_index: integer): number]]
--[[@field FreeverbFilter_create fun(): ptr_c<soloud_freeverb_filter_c>]]
--[[@field FreeverbFilter_setParams fun(x: ptr_c<soloud_freeverb_filter_c>, mode: number, room_size: number, damp: number, a_width: number): integer]]
--[[@field LofiFilter_destroy fun(x: ptr_c<soloud_lofi_filter_c>)]]
--[[@field LofiFilter_getParamCount fun(x: ptr_c<soloud_lofi_filter_c>): integer]]
--[[@field LofiFilter_getParamName fun(x: ptr_c<soloud_lofi_filter_c>, param_index: integer): string]]
--[[@field LofiFilter_getParamType fun(x: ptr_c<soloud_lofi_filter_c>, param_index: integer): integer]]
--[[@field LofiFilter_getParamMax fun(x: ptr_c<soloud_lofi_filter_c>, param_index: integer): number]]
--[[@field LofiFilter_getParamMin fun(x: ptr_c<soloud_lofi_filter_c>, param_index: integer): number]]
--[[@field LofiFilter_create fun(): ptr_c<soloud_lofi_filter_c>]]
--[[@field LofiFilter_setParams fun(x: ptr_c<soloud_lofi_filter_c>, sample_rate: number, bitdepth: number): integer]]
--[[@field Monotone_destroy fun(x: ptr_c<soloud_monotone_c>)]]
--[[@field Monotone_create fun(): ptr_c<soloud_monotone_c>]]
--[[@field Monotone_setParams fun(x: ptr_c<soloud_monotone_c>, a_hardware_channels: integer): integer]]
--[[@field Monotone_setParamsEx fun(x: ptr_c<soloud_monotone_c>, a_hardware_channels: integer, a_waveform: integer): integer]]
--[[@field Monotone_load fun(x: ptr_c<soloud_monotone_c>, filename: string): integer]]
--[[@field Monotone_loadMem fun(x: ptr_c<soloud_monotone_c>, mem: string, length: integer): integer]]
--[[@field Monotone_loadMemEx fun(x: ptr_c<soloud_monotone_c>, mem: string, length: integer, copy: integer, take_ownership: integer): integer]]
--[[@field Monotone_loadFile fun(x: ptr_c<soloud_monotone_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field Monotone_setVolume fun(x: ptr_c<soloud_monotone_c>, volume: number)]]
--[[@field Monotone_setLooping fun(x: ptr_c<soloud_monotone_c>, loop: integer)]]
--[[@field Monotone_setAutoStop fun(x: ptr_c<soloud_monotone_c>, auto_stop: integer)]]
--[[@field Monotone_set3dMinMaxDistance fun(x: ptr_c<soloud_monotone_c>, min_distance: number, max_distance: number)]]
--[[@field Monotone_set3dAttenuation fun(x: ptr_c<soloud_monotone_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Monotone_set3dDopplerFactor fun(x: ptr_c<soloud_monotone_c>, doppler_factor: number)]]
--[[@field Monotone_set3dListenerRelative fun(x: ptr_c<soloud_monotone_c>, listener_relative: integer)]]
--[[@field Monotone_set3dDistanceDelay fun(x: ptr_c<soloud_monotone_c>, distance_delay: integer)]]
--[[@field Monotone_set3dCollider fun(x: ptr_c<soloud_monotone_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Monotone_set3dColliderEx fun(x: ptr_c<soloud_monotone_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Monotone_set3dAttenuator fun(x: ptr_c<soloud_monotone_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Monotone_setInaudibleBehavior fun(x: ptr_c<soloud_monotone_c>, must_tick: integer, kill: integer)]]
--[[@field Monotone_setLoopPoint fun(x: ptr_c<soloud_monotone_c>, loop_point: number)]]
--[[@field Monotone_getLoopPoint fun(x: ptr_c<soloud_monotone_c>): number]]
--[[@field Monotone_setFilter fun(x: ptr_c<soloud_monotone_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Monotone_stop fun(x: ptr_c<soloud_monotone_c>)]]
--[[@field Noise_destroy fun(x: ptr_c<soloud_noise_c>)]]
--[[@field Noise_create fun(): ptr_c<soloud_noise_c>]]
--[[@field Noise_setOctaveScale fun(x: ptr_c<soloud_noise_c>, a_oct0: number, a_oct1: number, a_oct2: number, a_oct3: number, a_oct4: number, a_oct5: number, a_oct6: number, a_oct7: number, a_oct8: number, a_oct9: number)]]
--[[@field Noise_setType fun(x: ptr_c<soloud_noise_c>, type: integer)]]
--[[@field Noise_setVolume fun(x: ptr_c<soloud_noise_c>, volume: number)]]
--[[@field Noise_setLooping fun(x: ptr_c<soloud_noise_c>, loop: integer)]]
--[[@field Noise_setAutoStop fun(x: ptr_c<soloud_noise_c>, auto_stop: integer)]]
--[[@field Noise_set3dMinMaxDistance fun(x: ptr_c<soloud_noise_c>, min_distance: number, max_distance: number)]]
--[[@field Noise_set3dAttenuation fun(x: ptr_c<soloud_noise_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Noise_set3dDopplerFactor fun(x: ptr_c<soloud_noise_c>, doppler_factor: number)]]
--[[@field Noise_set3dListenerRelative fun(x: ptr_c<soloud_noise_c>, listener_relative: integer)]]
--[[@field Noise_set3dDistanceDelay fun(x: ptr_c<soloud_noise_c>, distance_delay: integer)]]
--[[@field Noise_set3dCollider fun(x: ptr_c<soloud_noise_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Noise_set3dColliderEx fun(x: ptr_c<soloud_noise_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Noise_set3dAttenuator fun(x: ptr_c<soloud_noise_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Noise_setInaudibleBehavior fun(x: ptr_c<soloud_noise_c>, must_tick: integer, kill: integer)]]
--[[@field Noise_setLoopPoint fun(x: ptr_c<soloud_noise_c>, loop_point: number)]]
--[[@field Noise_getLoopPoint fun(x: ptr_c<soloud_noise_c>): number]]
--[[@field Noise_setFilter fun(x: ptr_c<soloud_noise_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Noise_stop fun(x: ptr_c<soloud_noise_c>)]]
--[[@field Openmpt_destroy fun(x: ptr_c<soloud_openmpt_c>)]]
--[[@field Openmpt_create fun(): ptr_c<soloud_openmpt_c>]]
--[[@field Openmpt_load fun(x: ptr_c<soloud_openmpt_c>, filename: string): integer]]
--[[@field Openmpt_loadMem fun(x: ptr_c<soloud_openmpt_c>, mem: string, length: integer): integer]]
--[[@field Openmpt_loadMemEx fun(x: ptr_c<soloud_openmpt_c>, mem: string, length: integer, copy: integer, take_ownership: integer): integer]]
--[[@field Openmpt_loadFile fun(x: ptr_c<soloud_openmpt_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field Openmpt_setVolume fun(x: ptr_c<soloud_openmpt_c>, volume: number)]]
--[[@field Openmpt_setLooping fun(x: ptr_c<soloud_openmpt_c>, loop: integer)]]
--[[@field Openmpt_setAutoStop fun(x: ptr_c<soloud_openmpt_c>, auto_stop: integer)]]
--[[@field Openmpt_set3dMinMaxDistance fun(x: ptr_c<soloud_openmpt_c>, min_distance: number, max_distance: number)]]
--[[@field Openmpt_set3dAttenuation fun(x: ptr_c<soloud_openmpt_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Openmpt_set3dDopplerFactor fun(x: ptr_c<soloud_openmpt_c>, doppler_factor: number)]]
--[[@field Openmpt_set3dListenerRelative fun(x: ptr_c<soloud_openmpt_c>, listener_relative: integer)]]
--[[@field Openmpt_set3dDistanceDelay fun(x: ptr_c<soloud_openmpt_c>, distance_delay: integer)]]
--[[@field Openmpt_set3dCollider fun(x: ptr_c<soloud_openmpt_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Openmpt_set3dColliderEx fun(x: ptr_c<soloud_openmpt_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Openmpt_set3dAttenuator fun(x: ptr_c<soloud_openmpt_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Openmpt_setInaudibleBehavior fun(x: ptr_c<soloud_openmpt_c>, must_tick: integer, kill: integer)]]
--[[@field Openmpt_setLoopPoint fun(x: ptr_c<soloud_openmpt_c>, loop_point: number)]]
--[[@field Openmpt_getLoopPoint fun(x: ptr_c<soloud_openmpt_c>): number]]
--[[@field Openmpt_setFilter fun(x: ptr_c<soloud_openmpt_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Openmpt_stop fun(x: ptr_c<soloud_openmpt_c>)]]
--[[@field Queue_destroy fun(x: ptr_c<soloud_queue_c>)]]
--[[@field Queue_create fun(): ptr_c<soloud_queue_c>]]
--[[@field Queue_play fun(x: ptr_c<soloud_queue_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Queue_getQueueCount fun(x: ptr_c<soloud_queue_c>): integer]]
--[[@field Queue_isCurrentlyPlaying fun(x: ptr_c<soloud_queue_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Queue_setParamsFromAudioSource fun(x: ptr_c<soloud_queue_c>, sound: ptr_c<soloud_audio_source_c>): integer]]
--[[@field Queue_setParams fun(x: ptr_c<soloud_queue_c>, samplerate: number): integer]]
--[[@field Queue_setParamsEx fun(x: ptr_c<soloud_queue_c>, samplerate: number, channels: integer): integer]]
--[[@field Queue_setVolume fun(x: ptr_c<soloud_queue_c>, volume: number)]]
--[[@field Queue_setLooping fun(x: ptr_c<soloud_queue_c>, loop: integer)]]
--[[@field Queue_setAutoStop fun(x: ptr_c<soloud_queue_c>, auto_stop: integer)]]
--[[@field Queue_set3dMinMaxDistance fun(x: ptr_c<soloud_queue_c>, min_distance: number, max_distance: number)]]
--[[@field Queue_set3dAttenuation fun(x: ptr_c<soloud_queue_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Queue_set3dDopplerFactor fun(x: ptr_c<soloud_queue_c>, doppler_factor: number)]]
--[[@field Queue_set3dListenerRelative fun(x: ptr_c<soloud_queue_c>, listener_relative: integer)]]
--[[@field Queue_set3dDistanceDelay fun(x: ptr_c<soloud_queue_c>, distance_delay: integer)]]
--[[@field Queue_set3dCollider fun(x: ptr_c<soloud_queue_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Queue_set3dColliderEx fun(x: ptr_c<soloud_queue_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Queue_set3dAttenuator fun(x: ptr_c<soloud_queue_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Queue_setInaudibleBehavior fun(x: ptr_c<soloud_queue_c>, must_tick: integer, kill: integer)]]
--[[@field Queue_setLoopPoint fun(x: ptr_c<soloud_queue_c>, loop_point: number)]]
--[[@field Queue_getLoopPoint fun(x: ptr_c<soloud_queue_c>): number]]
--[[@field Queue_setFilter fun(x: ptr_c<soloud_queue_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Queue_stop fun(x: ptr_c<soloud_queue_c>)]]
--[[@field RobotizeFilter_destroy fun(x: ptr_c<soloud_robotize_filter_c>)]]
--[[@field RobotizeFilter_getParamCount fun(x: ptr_c<soloud_robotize_filter_c>): integer]]
--[[@field RobotizeFilter_getParamName fun(x: ptr_c<soloud_robotize_filter_c>, param_index: integer): string]]
--[[@field RobotizeFilter_getParamType fun(x: ptr_c<soloud_robotize_filter_c>, param_index: integer): integer]]
--[[@field RobotizeFilter_getParamMax fun(x: ptr_c<soloud_robotize_filter_c>, param_index: integer): number]]
--[[@field RobotizeFilter_getParamMin fun(x: ptr_c<soloud_robotize_filter_c>, param_index: integer): number]]
--[[@field RobotizeFilter_setParams fun(x: ptr_c<soloud_robotize_filter_c>, freq: number, a_waveform: integer)]]
--[[@field RobotizeFilter_create fun(): ptr_c<soloud_robotize_filter_c>]]
--[[@field Sfxr_destroy fun(x: ptr_c<soloud_sfxr_c>)]]
--[[@field Sfxr_create fun(): ptr_c<soloud_sfxr_c>]]
--[[@field Sfxr_resetParams fun(x: ptr_c<soloud_sfxr_c>)]]
--[[@field Sfxr_loadParams fun(x: ptr_c<soloud_sfxr_c>, filename: string): integer]]
--[[@field Sfxr_loadParamsMem fun(x: ptr_c<soloud_sfxr_c>, mem: string, length: integer): integer]]
--[[@field Sfxr_loadParamsMemEx fun(x: ptr_c<soloud_sfxr_c>, mem: string, length: integer, copy: integer, take_ownership: integer): integer]]
--[[@field Sfxr_loadParamsFile fun(x: ptr_c<soloud_sfxr_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field Sfxr_loadPreset fun(x: ptr_c<soloud_sfxr_c>, preset_no: integer, rand_seed: integer): integer]]
--[[@field Sfxr_setVolume fun(x: ptr_c<soloud_sfxr_c>, volume: number)]]
--[[@field Sfxr_setLooping fun(x: ptr_c<soloud_sfxr_c>, loop: integer)]]
--[[@field Sfxr_setAutoStop fun(x: ptr_c<soloud_sfxr_c>, auto_stop: integer)]]
--[[@field Sfxr_set3dMinMaxDistance fun(x: ptr_c<soloud_sfxr_c>, min_distance: number, max_distance: number)]]
--[[@field Sfxr_set3dAttenuation fun(x: ptr_c<soloud_sfxr_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Sfxr_set3dDopplerFactor fun(x: ptr_c<soloud_sfxr_c>, doppler_factor: number)]]
--[[@field Sfxr_set3dListenerRelative fun(x: ptr_c<soloud_sfxr_c>, listener_relative: integer)]]
--[[@field Sfxr_set3dDistanceDelay fun(x: ptr_c<soloud_sfxr_c>, distance_delay: integer)]]
--[[@field Sfxr_set3dCollider fun(x: ptr_c<soloud_sfxr_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Sfxr_set3dColliderEx fun(x: ptr_c<soloud_sfxr_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Sfxr_set3dAttenuator fun(x: ptr_c<soloud_sfxr_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Sfxr_setInaudibleBehavior fun(x: ptr_c<soloud_sfxr_c>, must_tick: integer, kill: integer)]]
--[[@field Sfxr_setLoopPoint fun(x: ptr_c<soloud_sfxr_c>, loop_point: number)]]
--[[@field Sfxr_getLoopPoint fun(x: ptr_c<soloud_sfxr_c>): number]]
--[[@field Sfxr_setFilter fun(x: ptr_c<soloud_sfxr_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Sfxr_stop fun(x: ptr_c<soloud_sfxr_c>)]]
--[[@field Speech_destroy fun(x: ptr_c<soloud_speech_c>)]]
--[[@field Speech_create fun(): ptr_c<soloud_speech_c>]]
--[[@field Speech_setText fun(x: ptr_c<soloud_speech_c>, text: string): integer]]
--[[@field Speech_setParams fun(x: ptr_c<soloud_speech_c>): integer]]
--[[@field Speech_setParamsEx fun(x: ptr_c<soloud_speech_c>, base_frequency: integer, base_speed: number, base_declination: number, base_waveform: integer): integer]]
--[[@field Speech_setVolume fun(x: ptr_c<soloud_speech_c>, volume: number)]]
--[[@field Speech_setLooping fun(x: ptr_c<soloud_speech_c>, loop: integer)]]
--[[@field Speech_setAutoStop fun(x: ptr_c<soloud_speech_c>, auto_stop: integer)]]
--[[@field Speech_set3dMinMaxDistance fun(x: ptr_c<soloud_speech_c>, min_distance: number, max_distance: number)]]
--[[@field Speech_set3dAttenuation fun(x: ptr_c<soloud_speech_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Speech_set3dDopplerFactor fun(x: ptr_c<soloud_speech_c>, doppler_factor: number)]]
--[[@field Speech_set3dListenerRelative fun(x: ptr_c<soloud_speech_c>, listener_relative: integer)]]
--[[@field Speech_set3dDistanceDelay fun(x: ptr_c<soloud_speech_c>, distance_delay: integer)]]
--[[@field Speech_set3dCollider fun(x: ptr_c<soloud_speech_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Speech_set3dColliderEx fun(x: ptr_c<soloud_speech_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Speech_set3dAttenuator fun(x: ptr_c<soloud_speech_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Speech_setInaudibleBehavior fun(x: ptr_c<soloud_speech_c>, must_tick: integer, kill: integer)]]
--[[@field Speech_setLoopPoint fun(x: ptr_c<soloud_speech_c>, loop_point: number)]]
--[[@field Speech_getLoopPoint fun(x: ptr_c<soloud_speech_c>): number]]
--[[@field Speech_setFilter fun(x: ptr_c<soloud_speech_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Speech_stop fun(x: ptr_c<soloud_speech_c>)]]
--[[@field TedSid_destroy fun(x: ptr_c<soloud_tedsid_c>)]]
--[[@field TedSid_create fun(): ptr_c<soloud_tedsid_c>]]
--[[@field TedSid_load fun(x: ptr_c<soloud_tedsid_c>, filename: string): integer]]
--[[@field TedSid_loadMem fun(x: ptr_c<soloud_tedsid_c>, mem: string, length: integer): integer]]
--[[@field TedSid_loadMemEx fun(x: ptr_c<soloud_tedsid_c>, mem: string, length: integer, copy: integer, take_ownership: integer): integer]]
--[[@field TedSid_loadFile fun(x: ptr_c<soloud_tedsid_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field TedSid_setVolume fun(x: ptr_c<soloud_tedsid_c>, volume: number)]]
--[[@field TedSid_setLooping fun(x: ptr_c<soloud_tedsid_c>, loop: integer)]]
--[[@field TedSid_setAutoStop fun(x: ptr_c<soloud_tedsid_c>, auto_stop: integer)]]
--[[@field TedSid_set3dMinMaxDistance fun(x: ptr_c<soloud_tedsid_c>, min_distance: number, max_distance: number)]]
--[[@field TedSid_set3dAttenuation fun(x: ptr_c<soloud_tedsid_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field TedSid_set3dDopplerFactor fun(x: ptr_c<soloud_tedsid_c>, doppler_factor: number)]]
--[[@field TedSid_set3dListenerRelative fun(x: ptr_c<soloud_tedsid_c>, listener_relative: integer)]]
--[[@field TedSid_set3dDistanceDelay fun(x: ptr_c<soloud_tedsid_c>, distance_delay: integer)]]
--[[@field TedSid_set3dCollider fun(x: ptr_c<soloud_tedsid_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field TedSid_set3dColliderEx fun(x: ptr_c<soloud_tedsid_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field TedSid_set3dAttenuator fun(x: ptr_c<soloud_tedsid_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field TedSid_setInaudibleBehavior fun(x: ptr_c<soloud_tedsid_c>, must_tick: integer, kill: integer)]]
--[[@field TedSid_setLoopPoint fun(x: ptr_c<soloud_tedsid_c>, loop_point: number)]]
--[[@field TedSid_getLoopPoint fun(x: ptr_c<soloud_tedsid_c>): number]]
--[[@field TedSid_setFilter fun(x: ptr_c<soloud_tedsid_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field TedSid_stop fun(x: ptr_c<soloud_tedsid_c>)]]
--[[@field Vic_destroy fun(x: ptr_c<soloud_vic_c>)]]
--[[@field Vic_create fun(): ptr_c<soloud_vic_c>]]
--[[@field Vic_setModel fun(x: ptr_c<soloud_vic_c>, model: integer)]]
--[[@field Vic_getModel fun(x: ptr_c<soloud_vic_c>): integer]]
--[[@field Vic_setRegister fun(x: ptr_c<soloud_vic_c>, reg: integer, value: integer)]]
--[[@field Vic_getRegister fun(x: ptr_c<soloud_vic_c>, reg: integer): integer]]
--[[@field Vic_setVolume fun(x: ptr_c<soloud_vic_c>, volume: number)]]
--[[@field Vic_setLooping fun(x: ptr_c<soloud_vic_c>, loop: integer)]]
--[[@field Vic_setAutoStop fun(x: ptr_c<soloud_vic_c>, auto_stop: integer)]]
--[[@field Vic_set3dMinMaxDistance fun(x: ptr_c<soloud_vic_c>, min_distance: number, max_distance: number)]]
--[[@field Vic_set3dAttenuation fun(x: ptr_c<soloud_vic_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Vic_set3dDopplerFactor fun(x: ptr_c<soloud_vic_c>, doppler_factor: number)]]
--[[@field Vic_set3dListenerRelative fun(x: ptr_c<soloud_vic_c>, listener_relative: integer)]]
--[[@field Vic_set3dDistanceDelay fun(x: ptr_c<soloud_vic_c>, distance_delay: integer)]]
--[[@field Vic_set3dCollider fun(x: ptr_c<soloud_vic_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Vic_set3dColliderEx fun(x: ptr_c<soloud_vic_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Vic_set3dAttenuator fun(x: ptr_c<soloud_vic_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Vic_setInaudibleBehavior fun(x: ptr_c<soloud_vic_c>, must_tick: integer, kill: integer)]]
--[[@field Vic_setLoopPoint fun(x: ptr_c<soloud_vic_c>, loop_point: number)]]
--[[@field Vic_getLoopPoint fun(x: ptr_c<soloud_vic_c>): number]]
--[[@field Vic_setFilter fun(x: ptr_c<soloud_vic_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Vic_stop fun(x: ptr_c<soloud_vic_c>)]]
--[[@field Vizsn_destroy fun(x: ptr_c<soloud_vizsn_c>)]]
--[[@field Vizsn_create fun(): ptr_c<soloud_vizsn_c>]]
--[[@field Vizsn_setText fun(x: ptr_c<soloud_vizsn_c>, text: string)]]
--[[@field Vizsn_setVolume fun(x: ptr_c<soloud_vizsn_c>, volume: number)]]
--[[@field Vizsn_setLooping fun(x: ptr_c<soloud_vizsn_c>, loop: integer)]]
--[[@field Vizsn_setAutoStop fun(x: ptr_c<soloud_vizsn_c>, auto_stop: integer)]]
--[[@field Vizsn_set3dMinMaxDistance fun(x: ptr_c<soloud_vizsn_c>, min_distance: number, max_distance: number)]]
--[[@field Vizsn_set3dAttenuation fun(x: ptr_c<soloud_vizsn_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Vizsn_set3dDopplerFactor fun(x: ptr_c<soloud_vizsn_c>, doppler_factor: number)]]
--[[@field Vizsn_set3dListenerRelative fun(x: ptr_c<soloud_vizsn_c>, listener_relative: integer)]]
--[[@field Vizsn_set3dDistanceDelay fun(x: ptr_c<soloud_vizsn_c>, distance_delay: integer)]]
--[[@field Vizsn_set3dCollider fun(x: ptr_c<soloud_vizsn_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Vizsn_set3dColliderEx fun(x: ptr_c<soloud_vizsn_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Vizsn_set3dAttenuator fun(x: ptr_c<soloud_vizsn_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Vizsn_setInaudibleBehavior fun(x: ptr_c<soloud_vizsn_c>, must_tick: integer, kill: integer)]]
--[[@field Vizsn_setLoopPoint fun(x: ptr_c<soloud_vizsn_c>, loop_point: number)]]
--[[@field Vizsn_getLoopPoint fun(x: ptr_c<soloud_vizsn_c>): number]]
--[[@field Vizsn_setFilter fun(x: ptr_c<soloud_vizsn_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Vizsn_stop fun(x: ptr_c<soloud_vizsn_c>)]]
--[[@field Wav_destroy fun(x: ptr_c<soloud_wav_c>)]]
--[[@field Wav_create fun(): ptr_c<soloud_wav_c>]]
--[[@field Wav_load fun(x: ptr_c<soloud_wav_c>, filename: string): integer]]
--[[@field Wav_loadMem fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer): integer]]
--[[@field Wav_loadMemEx fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer, copy: integer, take_ownership: integer): integer]]
--[[@field Wav_loadFile fun(x: ptr_c<soloud_wav_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field Wav_loadRawWave8 fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer): integer]]
--[[@field Wav_loadRawWave8Ex fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer, samplerate: number, channels: integer): integer]]
--[[@field Wav_loadRawWave16 fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer): integer]]
--[[@field Wav_loadRawWave16Ex fun(x: ptr_c<soloud_wav_c>, mem: string, length: integer, samplerate: number, channels: integer): integer]]
--[[@field Wav_loadRawWave fun(x: ptr_c<soloud_wav_c>, mem: ptr_c<number>, length: integer): integer]]
--[[@field Wav_loadRawWaveEx fun(x: ptr_c<soloud_wav_c>, mem: ptr_c<number>, length: integer, samplerate: number, channels: integer, copy: integer, take_ownership: integer): integer]]
--[[@field Wav_getLength fun(x: ptr_c<soloud_wav_c>): number]]
--[[@field Wav_setVolume fun(x: ptr_c<soloud_wav_c>, volume: number)]]
--[[@field Wav_setLooping fun(x: ptr_c<soloud_wav_c>, loop: integer)]]
--[[@field Wav_setAutoStop fun(x: ptr_c<soloud_wav_c>, auto_stop: integer)]]
--[[@field Wav_set3dMinMaxDistance fun(x: ptr_c<soloud_wav_c>, min_distance: number, max_distance: number)]]
--[[@field Wav_set3dAttenuation fun(x: ptr_c<soloud_wav_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field Wav_set3dDopplerFactor fun(x: ptr_c<soloud_wav_c>, doppler_factor: number)]]
--[[@field Wav_set3dListenerRelative fun(x: ptr_c<soloud_wav_c>, listener_relative: integer)]]
--[[@field Wav_set3dDistanceDelay fun(x: ptr_c<soloud_wav_c>, distance_delay: integer)]]
--[[@field Wav_set3dCollider fun(x: ptr_c<soloud_wav_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field Wav_set3dColliderEx fun(x: ptr_c<soloud_wav_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field Wav_set3dAttenuator fun(x: ptr_c<soloud_wav_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field Wav_setInaudibleBehavior fun(x: ptr_c<soloud_wav_c>, must_tick: integer, kill: integer)]]
--[[@field Wav_setLoopPoint fun(x: ptr_c<soloud_wav_c>, loop_point: number)]]
--[[@field Wav_getLoopPoint fun(x: ptr_c<soloud_wav_c>): number]]
--[[@field Wav_setFilter fun(x: ptr_c<soloud_wav_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field Wav_stop fun(x: ptr_c<soloud_wav_c>)]]
--[[@field WaveShaperFilter_destroy fun(x: ptr_c<soloud_wave_shaper_filter_c>)]]
--[[@field WaveShaperFilter_setParams fun(x: ptr_c<soloud_wave_shaper_filter_c>, amount: number): integer]]
--[[@field WaveShaperFilter_create fun(): ptr_c<soloud_wave_shaper_filter_c>]]
--[[@field WaveShaperFilter_getParamCount fun(x: ptr_c<soloud_wave_shaper_filter_c>): integer]]
--[[@field WaveShaperFilter_getParamName fun(x: ptr_c<soloud_wave_shaper_filter_c>, param_index: integer): string]]
--[[@field WaveShaperFilter_getParamType fun(x: ptr_c<soloud_wave_shaper_filter_c>, param_index: integer): integer]]
--[[@field WaveShaperFilter_getParamMax fun(x: ptr_c<soloud_wave_shaper_filter_c>, param_index: integer): number]]
--[[@field WaveShaperFilter_getParamMin fun(x: ptr_c<soloud_wave_shaper_filter_c>, param_index: integer): number]]
--[[@field WavStream_destroy fun(x: ptr_c<soloud_wav_stream_c>)]]
--[[@field WavStream_create fun(): ptr_c<soloud_wav_stream_c>]]
--[[@field WavStream_load fun(x: ptr_c<soloud_wav_stream_c>, filename: string): integer]]
--[[@field WavStream_loadMem fun(x: ptr_c<soloud_wav_stream_c>, data: string, data_len: integer): integer]]
--[[@field WavStream_loadMemEx fun(x: ptr_c<soloud_wav_stream_c>, data: string, data_len: integer, copy: integer, take_ownership: integer): integer]]
--[[@field WavStream_loadToMem fun(x: ptr_c<soloud_wav_stream_c>, filename: string): integer]]
--[[@field WavStream_loadFile fun(x: ptr_c<soloud_wav_stream_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field WavStream_loadFileToMem fun(x: ptr_c<soloud_wav_stream_c>, file: ptr_c<soloud_file_c>): integer]]
--[[@field WavStream_getLength fun(x: ptr_c<soloud_wav_stream_c>): number]]
--[[@field WavStream_setVolume fun(x: ptr_c<soloud_wav_stream_c>, volume: number)]]
--[[@field WavStream_setLooping fun(x: ptr_c<soloud_wav_stream_c>, loop: integer)]]
--[[@field WavStream_setAutoStop fun(x: ptr_c<soloud_wav_stream_c>, auto_stop: integer)]]
--[[@field WavStream_set3dMinMaxDistance fun(x: ptr_c<soloud_wav_stream_c>, min_distance: number, max_distance: number)]]
--[[@field WavStream_set3dAttenuation fun(x: ptr_c<soloud_wav_stream_c>, attenuation_model: integer, attenuation_rolloff_factor: number)]]
--[[@field WavStream_set3dDopplerFactor fun(x: ptr_c<soloud_wav_stream_c>, doppler_factor: number)]]
--[[@field WavStream_set3dListenerRelative fun(x: ptr_c<soloud_wav_stream_c>, listener_relative: integer)]]
--[[@field WavStream_set3dDistanceDelay fun(x: ptr_c<soloud_wav_stream_c>, distance_delay: integer)]]
--[[@field WavStream_set3dCollider fun(x: ptr_c<soloud_wav_stream_c>, collider: ptr_c<soloud_audio_collider_c>)]]
--[[@field WavStream_set3dColliderEx fun(x: ptr_c<soloud_wav_stream_c>, collider: ptr_c<soloud_audio_collider_c>, a_user_data: integer)]]
--[[@field WavStream_set3dAttenuator fun(x: ptr_c<soloud_wav_stream_c>, attenuator: ptr_c<soloud_audio_attenuator_c>)]]
--[[@field WavStream_setInaudibleBehavior fun(x: ptr_c<soloud_wav_stream_c>, must_tick: integer, kill: integer)]]
--[[@field WavStream_setLoopPoint fun(x: ptr_c<soloud_wav_stream_c>, loop_point: number)]]
--[[@field WavStream_getLoopPoint fun(x: ptr_c<soloud_wav_stream_c>): number]]
--[[@field WavStream_setFilter fun(x: ptr_c<soloud_wav_stream_c>, filter_id: integer, filter: ptr_c<soloud_filter_c>)]]
--[[@field WavStream_stop fun(x: ptr_c<soloud_wav_stream_c>)]]

ffi.cdef [[
	typedef struct _File File;
	typedef struct _AudioAttenuator AudioAttenuator;
	typedef struct _AudioCollider AudioCollider;
	typedef struct _AudioSource AudioSource;
	typedef struct _Filter Filter;

	void Soloud_destroy(void *x);
	void *Soloud_create();
	int Soloud_init(void *x);
	int Soloud_initEx(void *x, unsigned int aFlags, unsigned int aBackend, unsigned int aSamplerate, unsigned int aBufferSize, unsigned int aChannels);
	void Soloud_deinit(void *x);
	unsigned int Soloud_getVersion(void *x);
	const char *Soloud_getErrorString(void *x, int aErrorCode);
	unsigned int Soloud_getBackendId(void *x);
	const char *Soloud_getBackendString(void *x);
	unsigned int Soloud_getBackendChannels(void *x);
	unsigned int Soloud_getBackendSamplerate(void *x);
	unsigned int Soloud_getBackendBufferSize(void *x);
	int Soloud_setSpeakerPosition(void *x, unsigned int aChannel, float aX, float aY, float aZ);
	int Soloud_getSpeakerPosition(void *x, unsigned int aChannel, float *aX, float *aY, float *aZ);
	unsigned int Soloud_play(void *x, AudioSource *aSound);
	unsigned int Soloud_playEx(void *x, AudioSource *aSound, float aVolume, float aPan, int aPaused, unsigned int aBus);
	unsigned int Soloud_playClocked(void *x, double aSoundTime, AudioSource *aSound);
	unsigned int Soloud_playClockedEx(void *x, double aSoundTime, AudioSource *aSound, float aVolume, float aPan, unsigned int aBus);
	unsigned int Soloud_play3d(void *x, AudioSource *aSound, float aPosX, float aPosY, float aPosZ);
	unsigned int Soloud_play3dEx(void *x, AudioSource *aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, int aPaused, unsigned int aBus);
	unsigned int Soloud_play3dClocked(void *x, double aSoundTime, AudioSource *aSound, float aPosX, float aPosY, float aPosZ);
	unsigned int Soloud_play3dClockedEx(void *x, double aSoundTime, AudioSource *aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, unsigned int aBus);
	unsigned int Soloud_playBackground(void *x, AudioSource *aSound);
	unsigned int Soloud_playBackgroundEx(void *x, AudioSource *aSound, float aVolume, int aPaused, unsigned int aBus);
	int Soloud_seek(void *x, unsigned int aVoiceHandle, double aSeconds);
	void Soloud_stop(void *x, unsigned int aVoiceHandle);
	void Soloud_stopAll(void *x);
	void Soloud_stopAudioSource(void *x, AudioSource *aSound);
	int Soloud_countAudioSource(void *x, AudioSource *aSound);
	void Soloud_setFilterParameter(void *x, unsigned int aVoiceHandle, unsigned int aFilterId, unsigned int aAttributeId, float aValue);
	float Soloud_getFilterParameter(void *x, unsigned int aVoiceHandle, unsigned int aFilterId, unsigned int aAttributeId);
	void Soloud_fadeFilterParameter(void *x, unsigned int aVoiceHandle, unsigned int aFilterId, unsigned int aAttributeId, float aTo, double aTime);
	void Soloud_oscillateFilterParameter(void *x, unsigned int aVoiceHandle, unsigned int aFilterId, unsigned int aAttributeId, float aFrom, float aTo, double aTime);
	double Soloud_getStreamTime(void *x, unsigned int aVoiceHandle);
	double Soloud_getStreamPosition(void *x, unsigned int aVoiceHandle);
	int Soloud_getPause(void *x, unsigned int aVoiceHandle);
	float Soloud_getVolume(void *x, unsigned int aVoiceHandle);
	float Soloud_getOverallVolume(void *x, unsigned int aVoiceHandle);
	float Soloud_getPan(void *x, unsigned int aVoiceHandle);
	float Soloud_getSamplerate(void *x, unsigned int aVoiceHandle);
	int Soloud_getProtectVoice(void *x, unsigned int aVoiceHandle);
	unsigned int Soloud_getActiveVoiceCount(void *x);
	unsigned int Soloud_getVoiceCount(void *x);
	int Soloud_isValidVoiceHandle(void *x, unsigned int aVoiceHandle);
	float Soloud_getRelativePlaySpeed(void *x, unsigned int aVoiceHandle);
	float Soloud_getPostClipScaler(void *x);
	unsigned int Soloud_getMainResampler(void *x);
	float Soloud_getGlobalVolume(void *x);
	unsigned int Soloud_getMaxActiveVoiceCount(void *x);
	int Soloud_getLooping(void *x, unsigned int aVoiceHandle);
	int Soloud_getAutoStop(void *x, unsigned int aVoiceHandle);
	double Soloud_getLoopPoint(void *x, unsigned int aVoiceHandle);
	void Soloud_setLoopPoint(void *x, unsigned int aVoiceHandle, double aLoopPoint);
	void Soloud_setLooping(void *x, unsigned int aVoiceHandle, int aLooping);
	void Soloud_setAutoStop(void *x, unsigned int aVoiceHandle, int aAutoStop);
	int Soloud_setMaxActiveVoiceCount(void *x, unsigned int aVoiceCount);
	void Soloud_setInaudibleBehavior(void *x, unsigned int aVoiceHandle, int aMustTick, int aKill);
	void Soloud_setGlobalVolume(void *x, float aVolume);
	void Soloud_setPostClipScaler(void *x, float aScaler);
	void Soloud_setMainResampler(void *x, unsigned int aResampler);
	void Soloud_setPause(void *x, unsigned int aVoiceHandle, int aPause);
	void Soloud_setPauseAll(void *x, int aPause);
	int Soloud_setRelativePlaySpeed(void *x, unsigned int aVoiceHandle, float aSpeed);
	void Soloud_setProtectVoice(void *x, unsigned int aVoiceHandle, int aProtect);
	void Soloud_setSamplerate(void *x, unsigned int aVoiceHandle, float aSamplerate);
	void Soloud_setPan(void *x, unsigned int aVoiceHandle, float aPan);
	void Soloud_setPanAbsolute(void *x, unsigned int aVoiceHandle, float aLVolume, float aRVolume);
	void Soloud_setChannelVolume(void *x, unsigned int aVoiceHandle, unsigned int aChannel, float aVolume);
	void Soloud_setVolume(void *x, unsigned int aVoiceHandle, float aVolume);
	void Soloud_setDelaySamples(void *x, unsigned int aVoiceHandle, unsigned int aSamples);
	void Soloud_fadeVolume(void *x, unsigned int aVoiceHandle, float aTo, double aTime);
	void Soloud_fadePan(void *x, unsigned int aVoiceHandle, float aTo, double aTime);
	void Soloud_fadeRelativePlaySpeed(void *x, unsigned int aVoiceHandle, float aTo, double aTime);
	void Soloud_fadeGlobalVolume(void *x, float aTo, double aTime);
	void Soloud_schedulePause(void *x, unsigned int aVoiceHandle, double aTime);
	void Soloud_scheduleStop(void *x, unsigned int aVoiceHandle, double aTime);
	void Soloud_oscillateVolume(void *x, unsigned int aVoiceHandle, float aFrom, float aTo, double aTime);
	void Soloud_oscillatePan(void *x, unsigned int aVoiceHandle, float aFrom, float aTo, double aTime);
	void Soloud_oscillateRelativePlaySpeed(void *x, unsigned int aVoiceHandle, float aFrom, float aTo, double aTime);
	void Soloud_oscillateGlobalVolume(void *x, float aFrom, float aTo, double aTime);
	void Soloud_setGlobalFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Soloud_setVisualizationEnable(void *x, int aEnable);
	float *Soloud_calcFFT(void *x);
	float *Soloud_getWave(void *x);
	float Soloud_getApproximateVolume(void *x, unsigned int aChannel);
	unsigned int Soloud_getLoopCount(void *x, unsigned int aVoiceHandle);
	float Soloud_getInfo(void *x, unsigned int aVoiceHandle, unsigned int aInfoKey);
	unsigned int Soloud_createVoiceGroup(void *x);
	int Soloud_destroyVoiceGroup(void *x, unsigned int aVoiceGroupHandle);
	int Soloud_addVoiceToGroup(void *x, unsigned int aVoiceGroupHandle, unsigned int aVoiceHandle);
	int Soloud_isVoiceGroup(void *x, unsigned int aVoiceGroupHandle);
	int Soloud_isVoiceGroupEmpty(void *x, unsigned int aVoiceGroupHandle);
	void Soloud_update3dAudio(void *x);
	int Soloud_set3dSoundSpeed(void *x, float aSpeed);
	float Soloud_get3dSoundSpeed(void *x);
	void Soloud_set3dListenerParameters(void *x, float aPosX, float aPosY, float aPosZ, float aAtX, float aAtY, float aAtZ, float aUpX, float aUpY, float aUpZ);
	void Soloud_set3dListenerParametersEx(void *x, float aPosX, float aPosY, float aPosZ, float aAtX, float aAtY, float aAtZ, float aUpX, float aUpY, float aUpZ, float aVelocityX, float aVelocityY, float aVelocityZ);
	void Soloud_set3dListenerPosition(void *x, float aPosX, float aPosY, float aPosZ);
	void Soloud_set3dListenerAt(void *x, float aAtX, float aAtY, float aAtZ);
	void Soloud_set3dListenerUp(void *x, float aUpX, float aUpY, float aUpZ);
	void Soloud_set3dListenerVelocity(void *x, float aVelocityX, float aVelocityY, float aVelocityZ);
	void Soloud_set3dSourceParameters(void *x, unsigned int aVoiceHandle, float aPosX, float aPosY, float aPosZ);
	void Soloud_set3dSourceParametersEx(void *x, unsigned int aVoiceHandle, float aPosX, float aPosY, float aPosZ, float aVelocityX, float aVelocityY, float aVelocityZ);
	void Soloud_set3dSourcePosition(void *x, unsigned int aVoiceHandle, float aPosX, float aPosY, float aPosZ);
	void Soloud_set3dSourceVelocity(void *x, unsigned int aVoiceHandle, float aVelocityX, float aVelocityY, float aVelocityZ);
	void Soloud_set3dSourceMinMaxDistance(void *x, unsigned int aVoiceHandle, float aMinDistance, float aMaxDistance);
	void Soloud_set3dSourceAttenuation(void *x, unsigned int aVoiceHandle, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Soloud_set3dSourceDopplerFactor(void *x, unsigned int aVoiceHandle, float aDopplerFactor);
	void Soloud_mix(void *x, float *aBuffer, unsigned int aSamples);
	void Soloud_mixSigned16(void *x, short *aBuffer, unsigned int aSamples);
	void Ay_destroy(void *x);
	void *Ay_create();
	void Ay_setVolume(void *x, float aVolume);
	void Ay_setLooping(void *x, int aLoop);
	void Ay_setAutoStop(void *x, int aAutoStop);
	void Ay_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Ay_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Ay_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Ay_set3dListenerRelative(void *x, int aListenerRelative);
	void Ay_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Ay_set3dCollider(void *x, AudioCollider *aCollider);
	void Ay_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Ay_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Ay_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Ay_setLoopPoint(void *x, double aLoopPoint);
	double Ay_getLoopPoint(void *x);
	void Ay_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Ay_stop(void *x);
	void BassboostFilter_destroy(void *x);
	int BassboostFilter_getParamCount(void *x);
	const char *BassboostFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int BassboostFilter_getParamType(void *x, unsigned int aParamIndex);
	float BassboostFilter_getParamMax(void *x, unsigned int aParamIndex);
	float BassboostFilter_getParamMin(void *x, unsigned int aParamIndex);
	int BassboostFilter_setParams(void *x, float aBoost);
	void *BassboostFilter_create();
	void BiquadResonantFilter_destroy(void *x);
	int BiquadResonantFilter_getParamCount(void *x);
	const char *BiquadResonantFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int BiquadResonantFilter_getParamType(void *x, unsigned int aParamIndex);
	float BiquadResonantFilter_getParamMax(void *x, unsigned int aParamIndex);
	float BiquadResonantFilter_getParamMin(void *x, unsigned int aParamIndex);
	void *BiquadResonantFilter_create();
	int BiquadResonantFilter_setParams(void *x, int aType, float aFrequency, float aResonance);
	void Bus_destroy(void *x);
	void *Bus_create();
	void Bus_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	unsigned int Bus_play(void *x, AudioSource *aSound);
	unsigned int Bus_playEx(void *x, AudioSource *aSound, float aVolume, float aPan, int aPaused);
	unsigned int Bus_playClocked(void *x, double aSoundTime, AudioSource *aSound);
	unsigned int Bus_playClockedEx(void *x, double aSoundTime, AudioSource *aSound, float aVolume, float aPan);
	unsigned int Bus_play3d(void *x, AudioSource *aSound, float aPosX, float aPosY, float aPosZ);
	unsigned int Bus_play3dEx(void *x, AudioSource *aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, int aPaused);
	unsigned int Bus_play3dClocked(void *x, double aSoundTime, AudioSource *aSound, float aPosX, float aPosY, float aPosZ);
	unsigned int Bus_play3dClockedEx(void *x, double aSoundTime, AudioSource *aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume);
	int Bus_setChannels(void *x, unsigned int aChannels);
	void Bus_setVisualizationEnable(void *x, int aEnable);
	void Bus_annexSound(void *x, unsigned int aVoiceHandle);
	float *Bus_calcFFT(void *x);
	float *Bus_getWave(void *x);
	float Bus_getApproximateVolume(void *x, unsigned int aChannel);
	unsigned int Bus_getActiveVoiceCount(void *x);
	unsigned int Bus_getResampler(void *x);
	void Bus_setResampler(void *x, unsigned int aResampler);
	void Bus_setVolume(void *x, float aVolume);
	void Bus_setLooping(void *x, int aLoop);
	void Bus_setAutoStop(void *x, int aAutoStop);
	void Bus_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Bus_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Bus_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Bus_set3dListenerRelative(void *x, int aListenerRelative);
	void Bus_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Bus_set3dCollider(void *x, AudioCollider *aCollider);
	void Bus_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Bus_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Bus_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Bus_setLoopPoint(void *x, double aLoopPoint);
	double Bus_getLoopPoint(void *x);
	void Bus_stop(void *x);
	void DCRemovalFilter_destroy(void *x);
	void *DCRemovalFilter_create();
	int DCRemovalFilter_setParams(void *x);
	int DCRemovalFilter_setParamsEx(void *x, float aLength);
	int DCRemovalFilter_getParamCount(void *x);
	const char *DCRemovalFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int DCRemovalFilter_getParamType(void *x, unsigned int aParamIndex);
	float DCRemovalFilter_getParamMax(void *x, unsigned int aParamIndex);
	float DCRemovalFilter_getParamMin(void *x, unsigned int aParamIndex);
	void EchoFilter_destroy(void *x);
	int EchoFilter_getParamCount(void *x);
	const char *EchoFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int EchoFilter_getParamType(void *x, unsigned int aParamIndex);
	float EchoFilter_getParamMax(void *x, unsigned int aParamIndex);
	float EchoFilter_getParamMin(void *x, unsigned int aParamIndex);
	void *EchoFilter_create();
	int EchoFilter_setParams(void *x, float aDelay);
	int EchoFilter_setParamsEx(void *x, float aDelay, float aDecay, float aFilter);
	void FFTFilter_destroy(void *x);
	void *FFTFilter_create();
	int FFTFilter_getParamCount(void *x);
	const char *FFTFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int FFTFilter_getParamType(void *x, unsigned int aParamIndex);
	float FFTFilter_getParamMax(void *x, unsigned int aParamIndex);
	float FFTFilter_getParamMin(void *x, unsigned int aParamIndex);
	void FlangerFilter_destroy(void *x);
	int FlangerFilter_getParamCount(void *x);
	const char *FlangerFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int FlangerFilter_getParamType(void *x, unsigned int aParamIndex);
	float FlangerFilter_getParamMax(void *x, unsigned int aParamIndex);
	float FlangerFilter_getParamMin(void *x, unsigned int aParamIndex);
	void *FlangerFilter_create();
	int FlangerFilter_setParams(void *x, float aDelay, float aFreq);
	void FreeverbFilter_destroy(void *x);
	int FreeverbFilter_getParamCount(void *x);
	const char *FreeverbFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int FreeverbFilter_getParamType(void *x, unsigned int aParamIndex);
	float FreeverbFilter_getParamMax(void *x, unsigned int aParamIndex);
	float FreeverbFilter_getParamMin(void *x, unsigned int aParamIndex);
	void *FreeverbFilter_create();
	int FreeverbFilter_setParams(void *x, float aMode, float aRoomSize, float aDamp, float aWidth);
	void LofiFilter_destroy(void *x);
	int LofiFilter_getParamCount(void *x);
	const char *LofiFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int LofiFilter_getParamType(void *x, unsigned int aParamIndex);
	float LofiFilter_getParamMax(void *x, unsigned int aParamIndex);
	float LofiFilter_getParamMin(void *x, unsigned int aParamIndex);
	void *LofiFilter_create();
	int LofiFilter_setParams(void *x, float aSampleRate, float aBitdepth);
	void Monotone_destroy(void *x);
	void *Monotone_create();
	int Monotone_setParams(void *x, int aHardwareChannels);
	int Monotone_setParamsEx(void *x, int aHardwareChannels, int aWaveform);
	int Monotone_load(void *x, const char *aFilename);
	int Monotone_loadMem(void *x, const unsigned char *aMem, unsigned int aLength);
	int Monotone_loadMemEx(void *x, const unsigned char *aMem, unsigned int aLength, int aCopy, int aTakeOwnership);
	int Monotone_loadFile(void *x, File *aFile);
	void Monotone_setVolume(void *x, float aVolume);
	void Monotone_setLooping(void *x, int aLoop);
	void Monotone_setAutoStop(void *x, int aAutoStop);
	void Monotone_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Monotone_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Monotone_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Monotone_set3dListenerRelative(void *x, int aListenerRelative);
	void Monotone_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Monotone_set3dCollider(void *x, AudioCollider *aCollider);
	void Monotone_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Monotone_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Monotone_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Monotone_setLoopPoint(void *x, double aLoopPoint);
	double Monotone_getLoopPoint(void *x);
	void Monotone_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Monotone_stop(void *x);
	void Noise_destroy(void *x);
	void *Noise_create();
	void Noise_setOctaveScale(void *x, float aOct0, float aOct1, float aOct2, float aOct3, float aOct4, float aOct5, float aOct6, float aOct7, float aOct8, float aOct9);
	void Noise_setType(void *x, int aType);
	void Noise_setVolume(void *x, float aVolume);
	void Noise_setLooping(void *x, int aLoop);
	void Noise_setAutoStop(void *x, int aAutoStop);
	void Noise_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Noise_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Noise_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Noise_set3dListenerRelative(void *x, int aListenerRelative);
	void Noise_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Noise_set3dCollider(void *x, AudioCollider *aCollider);
	void Noise_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Noise_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Noise_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Noise_setLoopPoint(void *x, double aLoopPoint);
	double Noise_getLoopPoint(void *x);
	void Noise_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Noise_stop(void *x);
	void Openmpt_destroy(void *x);
	void *Openmpt_create();
	int Openmpt_load(void *x, const char *aFilename);
	int Openmpt_loadMem(void *x, const unsigned char *aMem, unsigned int aLength);
	int Openmpt_loadMemEx(void *x, const unsigned char *aMem, unsigned int aLength, int aCopy, int aTakeOwnership);
	int Openmpt_loadFile(void *x, File *aFile);
	void Openmpt_setVolume(void *x, float aVolume);
	void Openmpt_setLooping(void *x, int aLoop);
	void Openmpt_setAutoStop(void *x, int aAutoStop);
	void Openmpt_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Openmpt_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Openmpt_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Openmpt_set3dListenerRelative(void *x, int aListenerRelative);
	void Openmpt_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Openmpt_set3dCollider(void *x, AudioCollider *aCollider);
	void Openmpt_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Openmpt_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Openmpt_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Openmpt_setLoopPoint(void *x, double aLoopPoint);
	double Openmpt_getLoopPoint(void *x);
	void Openmpt_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Openmpt_stop(void *x);
	void Queue_destroy(void *x);
	void *Queue_create();
	int Queue_play(void *x, AudioSource *aSound);
	unsigned int Queue_getQueueCount(void *x);
	int Queue_isCurrentlyPlaying(void *x, AudioSource *aSound);
	int Queue_setParamsFromAudioSource(void *x, AudioSource *aSound);
	int Queue_setParams(void *x, float aSamplerate);
	int Queue_setParamsEx(void *x, float aSamplerate, unsigned int aChannels);
	void Queue_setVolume(void *x, float aVolume);
	void Queue_setLooping(void *x, int aLoop);
	void Queue_setAutoStop(void *x, int aAutoStop);
	void Queue_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Queue_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Queue_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Queue_set3dListenerRelative(void *x, int aListenerRelative);
	void Queue_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Queue_set3dCollider(void *x, AudioCollider *aCollider);
	void Queue_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Queue_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Queue_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Queue_setLoopPoint(void *x, double aLoopPoint);
	double Queue_getLoopPoint(void *x);
	void Queue_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Queue_stop(void *x);
	void RobotizeFilter_destroy(void *x);
	int RobotizeFilter_getParamCount(void *x);
	const char *RobotizeFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int RobotizeFilter_getParamType(void *x, unsigned int aParamIndex);
	float RobotizeFilter_getParamMax(void *x, unsigned int aParamIndex);
	float RobotizeFilter_getParamMin(void *x, unsigned int aParamIndex);
	void RobotizeFilter_setParams(void *x, float aFreq, int aWaveform);
	void *RobotizeFilter_create();
	void Sfxr_destroy(void *x);
	void *Sfxr_create();
	void Sfxr_resetParams(void *x);
	int Sfxr_loadParams(void *x, const char *aFilename);
	int Sfxr_loadParamsMem(void *x, unsigned char *aMem, unsigned int aLength);
	int Sfxr_loadParamsMemEx(void *x, unsigned char *aMem, unsigned int aLength, int aCopy, int aTakeOwnership);
	int Sfxr_loadParamsFile(void *x, File *aFile);
	int Sfxr_loadPreset(void *x, int aPresetNo, int aRandSeed);
	void Sfxr_setVolume(void *x, float aVolume);
	void Sfxr_setLooping(void *x, int aLoop);
	void Sfxr_setAutoStop(void *x, int aAutoStop);
	void Sfxr_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Sfxr_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Sfxr_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Sfxr_set3dListenerRelative(void *x, int aListenerRelative);
	void Sfxr_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Sfxr_set3dCollider(void *x, AudioCollider *aCollider);
	void Sfxr_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Sfxr_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Sfxr_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Sfxr_setLoopPoint(void *x, double aLoopPoint);
	double Sfxr_getLoopPoint(void *x);
	void Sfxr_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Sfxr_stop(void *x);
	void Speech_destroy(void *x);
	void *Speech_create();
	int Speech_setText(void *x, const char *aText);
	int Speech_setParams(void *x);
	int Speech_setParamsEx(void *x, unsigned int aBaseFrequency, float aBaseSpeed, float aBaseDeclination, int aBaseWaveform);
	void Speech_setVolume(void *x, float aVolume);
	void Speech_setLooping(void *x, int aLoop);
	void Speech_setAutoStop(void *x, int aAutoStop);
	void Speech_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Speech_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Speech_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Speech_set3dListenerRelative(void *x, int aListenerRelative);
	void Speech_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Speech_set3dCollider(void *x, AudioCollider *aCollider);
	void Speech_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Speech_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Speech_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Speech_setLoopPoint(void *x, double aLoopPoint);
	double Speech_getLoopPoint(void *x);
	void Speech_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Speech_stop(void *x);
	void TedSid_destroy(void *x);
	void *TedSid_create();
	int TedSid_load(void *x, const char *aFilename);
	int TedSid_loadMem(void *x, const unsigned char *aMem, unsigned int aLength);
	int TedSid_loadMemEx(void *x, const unsigned char *aMem, unsigned int aLength, int aCopy, int aTakeOwnership);
	int TedSid_loadFile(void *x, File *aFile);
	void TedSid_setVolume(void *x, float aVolume);
	void TedSid_setLooping(void *x, int aLoop);
	void TedSid_setAutoStop(void *x, int aAutoStop);
	void TedSid_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void TedSid_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void TedSid_set3dDopplerFactor(void *x, float aDopplerFactor);
	void TedSid_set3dListenerRelative(void *x, int aListenerRelative);
	void TedSid_set3dDistanceDelay(void *x, int aDistanceDelay);
	void TedSid_set3dCollider(void *x, AudioCollider *aCollider);
	void TedSid_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void TedSid_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void TedSid_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void TedSid_setLoopPoint(void *x, double aLoopPoint);
	double TedSid_getLoopPoint(void *x);
	void TedSid_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void TedSid_stop(void *x);
	void Vic_destroy(void *x);
	void *Vic_create();
	void Vic_setModel(void *x, int model);
	int Vic_getModel(void *x);
	void Vic_setRegister(void *x, int reg, unsigned char value);
	unsigned char Vic_getRegister(void *x, int reg);
	void Vic_setVolume(void *x, float aVolume);
	void Vic_setLooping(void *x, int aLoop);
	void Vic_setAutoStop(void *x, int aAutoStop);
	void Vic_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Vic_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Vic_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Vic_set3dListenerRelative(void *x, int aListenerRelative);
	void Vic_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Vic_set3dCollider(void *x, AudioCollider *aCollider);
	void Vic_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Vic_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Vic_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Vic_setLoopPoint(void *x, double aLoopPoint);
	double Vic_getLoopPoint(void *x);
	void Vic_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Vic_stop(void *x);
	void Vizsn_destroy(void *x);
	void *Vizsn_create();
	void Vizsn_setText(void *x, char *aText);
	void Vizsn_setVolume(void *x, float aVolume);
	void Vizsn_setLooping(void *x, int aLoop);
	void Vizsn_setAutoStop(void *x, int aAutoStop);
	void Vizsn_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Vizsn_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Vizsn_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Vizsn_set3dListenerRelative(void *x, int aListenerRelative);
	void Vizsn_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Vizsn_set3dCollider(void *x, AudioCollider *aCollider);
	void Vizsn_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Vizsn_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Vizsn_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Vizsn_setLoopPoint(void *x, double aLoopPoint);
	double Vizsn_getLoopPoint(void *x);
	void Vizsn_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Vizsn_stop(void *x);
	void Wav_destroy(void *x);
	void *Wav_create();
	int Wav_load(void *x, const char *aFilename);
	int Wav_loadMem(void *x, const unsigned char *aMem, unsigned int aLength);
	int Wav_loadMemEx(void *x, const unsigned char *aMem, unsigned int aLength, int aCopy, int aTakeOwnership);
	int Wav_loadFile(void *x, File *aFile);
	int Wav_loadRawWave8(void *x, unsigned char *aMem, unsigned int aLength);
	int Wav_loadRawWave8Ex(void *x, unsigned char *aMem, unsigned int aLength, float aSamplerate, unsigned int aChannels);
	int Wav_loadRawWave16(void *x, short *aMem, unsigned int aLength);
	int Wav_loadRawWave16Ex(void *x, short *aMem, unsigned int aLength, float aSamplerate, unsigned int aChannels);
	int Wav_loadRawWave(void *x, float *aMem, unsigned int aLength);
	int Wav_loadRawWaveEx(void *x, float *aMem, unsigned int aLength, float aSamplerate, unsigned int aChannels, int aCopy, int aTakeOwnership);
	double Wav_getLength(void *x);
	void Wav_setVolume(void *x, float aVolume);
	void Wav_setLooping(void *x, int aLoop);
	void Wav_setAutoStop(void *x, int aAutoStop);
	void Wav_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void Wav_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void Wav_set3dDopplerFactor(void *x, float aDopplerFactor);
	void Wav_set3dListenerRelative(void *x, int aListenerRelative);
	void Wav_set3dDistanceDelay(void *x, int aDistanceDelay);
	void Wav_set3dCollider(void *x, AudioCollider *aCollider);
	void Wav_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void Wav_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void Wav_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void Wav_setLoopPoint(void *x, double aLoopPoint);
	double Wav_getLoopPoint(void *x);
	void Wav_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void Wav_stop(void *x);
	void WaveShaperFilter_destroy(void *x);
	int WaveShaperFilter_setParams(void *x, float aAmount);
	void *WaveShaperFilter_create();
	int WaveShaperFilter_getParamCount(void *x);
	const char *WaveShaperFilter_getParamName(void *x, unsigned int aParamIndex);
	unsigned int WaveShaperFilter_getParamType(void *x, unsigned int aParamIndex);
	float WaveShaperFilter_getParamMax(void *x, unsigned int aParamIndex);
	float WaveShaperFilter_getParamMin(void *x, unsigned int aParamIndex);
	void WavStream_destroy(void *x);
	void *WavStream_create();
	int WavStream_load(void *x, const char *aFilename);
	int WavStream_loadMem(void *x, const unsigned char *aData, unsigned int aDataLen);
	int WavStream_loadMemEx(void *x, const unsigned char *aData, unsigned int aDataLen, int aCopy, int aTakeOwnership);
	int WavStream_loadToMem(void *x, const char *aFilename);
	int WavStream_loadFile(void *x, File *aFile);
	int WavStream_loadFileToMem(void *x, File *aFile);
	double WavStream_getLength(void *x);
	void WavStream_setVolume(void *x, float aVolume);
	void WavStream_setLooping(void *x, int aLoop);
	void WavStream_setAutoStop(void *x, int aAutoStop);
	void WavStream_set3dMinMaxDistance(void *x, float aMinDistance, float aMaxDistance);
	void WavStream_set3dAttenuation(void *x, unsigned int aAttenuationModel, float aAttenuationRolloffFactor);
	void WavStream_set3dDopplerFactor(void *x, float aDopplerFactor);
	void WavStream_set3dListenerRelative(void *x, int aListenerRelative);
	void WavStream_set3dDistanceDelay(void *x, int aDistanceDelay);
	void WavStream_set3dCollider(void *x, AudioCollider *aCollider);
	void WavStream_set3dColliderEx(void *x, AudioCollider *aCollider, int aUserData);
	void WavStream_set3dAttenuator(void *x, AudioAttenuator *aAttenuator);
	void WavStream_setInaudibleBehavior(void *x, int aMustTick, int aKill);
	void WavStream_setLoopPoint(void *x, double aLoopPoint);
	double WavStream_getLoopPoint(void *x);
	void WavStream_setFilter(void *x, unsigned int aFilterId, Filter *aFilter);
	void WavStream_stop(void *x);
]]

--[[FIXME: don't return ffi directly...]]
return soloud_ffi

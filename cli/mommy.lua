#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then
	arg = { ... }
else
	package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path
end

--[[@diagnostic disable-next-line: param-type-mismatch]]
math.randomseed(os.clock() * 100000)

local env_prefix = (os.getenv("MOMMY_ENV_PREFIX") or "MOMMY") .. "_"

--[[@param s string]]
local env = function(s)
	return os.getenv(env_prefix .. s)
end

local status = 0
if arg[1] == "-s" then
	--[[@diagnostic disable-next-line: cast-local-type]]
	status = tonumber(arg[2] or "0")
else
	--[[FIXME: no escaping]]
	os.execute(table.concat(arg, " "))
end
local success = status == 0
if success and env("COMPLIMENTS_ENABLED") == "0" then return end
if not success and env("ENCOURAGEMENTS_ENABLED") == "0" then return end

--[[@param s string]]
--[[@param pat string]]
local match_all = function(s, pat)
	--[[@type string[] ]]
	local result = {}
	for x in s:gmatch(pat) do result[#result + 1] = x end
	if #result == 0 then result[#result + 1] = "" end
	return result
end

--[[@param s string]]
--[[@param pat? string]]
local choose = function(s, pat)
	local choices = match_all(s, pat or "[^/]+")
	local n = math.random(#choices)
	return choices[n]
end

local get_sweetie = function()
	local file = io.popen("whoami")
	if not file then return "girl" end
	local contents = file:read()
	file:close()
	return #contents > 0 and contents or "girl"
end

local mood = choose(env("MOOD") or "")
local capitalize = env("CAPITALIZE") == "1"

local output = ""
if success then
	output = choose(mood and env(#mood > 0 and ("COMPLIMENTS_" .. mood:upper()) or "COMPLIMENTS") or [[*pets your head*
amazing work as always
good %%SWEETIE%%
good job, %%SWEETIE%%
that's a good %%SWEETIE%%
who's my good %%SWEETIE%%
%%CAREGIVER%% is very proud of you
%%CAREGIVER%% is so proud of you
%%CAREGIVER%% knew you could do it
%%CAREGIVER%% loves you, you are doing amazing
%%CAREGIVER%%'s %%SWEETIE%% is so smart
%%CAREGIVER%% thinks you deserve a special treat for that
my little %%SWEETIE%% deserves a big fat kiss for that]], "[^\n]+")
else
	output = choose(
		mood and env(#mood > 0 and ("ENCOURAGEMENTS_" .. mood:upper()) or "ENCOURAGEMENTS") or
		[[%%CAREGIVER%% believes in you
%%CAREGIVER%% knows you'll get there
%%CAREGIVER%% knows %%THEIR%% little %%SWEETIE%% can do better
just know that %%CAREGIVER%% still loves you
don't worry, it'll be alright
it's okay to make mistakes
%%CAREGIVER%% knows it's hard, but it will be okay
%%CAREGIVER%% is always here for you
%%CAREGIVER%% is always here for you if you need %%THEM%%
come here, sit on my lap while we figure this out together
never give up, my love
just a little further, %%CAREGIVER%% knows you can do it
%%CAREGIVER%% knows you'll get there, don't worry about it
did %%CAREGIVER%%'s %%SWEETIE%% make a big mess]], "[^\n]+")
end
if capitalize then output = output:upper() end
local pronouns = choose(env("PRONOUNS") or "she her her")
local they, them, their = unpack(match_all(pronouns, "%S+"))
output = choose(env("PREFIX") or "") .. output .. choose(env("SUFFIX") or "~")
local color = choose(env("COLOR") or "005")
local color_prefix = "\x1b[38;5;" .. color .. "m"
local color_suffix = "\x1b[0m\n"
--[[@param s string]]
local colorize = function(s) return s .. color_prefix end
local replacements = {
	CAREGIVER = colorize(choose(env("CAREGIVER") or "mommy")),
	SWEETIE = colorize(choose(env("SWEETIE") or get_sweetie())),
	PET = colorize(choose(env("PET") or "slut/toy/pet/pervert/whore")),
	PART = colorize(choose(env("PART") or "milk")),
	THEY = colorize(they),
	THEM = colorize(them),
	THEIR = colorize(their),
	N = "\n",
	S = "/",
}
output = output:gsub("%%%%([^%%]+)%%%%", replacements)
io.stdout:write(color_prefix, output, color_suffix)

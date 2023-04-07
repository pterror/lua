local path = require("lib.path")

local mod = {}

local script_path = debug.getinfo(1).source:match("@?(.*/)")

--[[`mod.name` is a tricky one, since given_name does not always come first]]

--[[@alias mock_given_name_country_code "es"|"us"]]
--[[@alias mock_surname_country_code "cn"|"cz"|"de"|"es"|"eus"|"fr"|"gk"|"hi"|"ie"|"il"|"it"|"kr"|"ne"|"pl"|"pt"|"ru"|"uk"|"us"]]

local given_name_cache = {} --[[@type table<string, string[]>]]

--[[@param country_code? "*"|mock_given_name_country_code]]
mod.given_name = function (country_code)
	country_code = country_code or "_"
	local names = given_name_cache[country_code]
	if not names then
		names = {}
		local file = io.open(path.resolve(script_path, "mock/name/given/" .. country_code))
		if not file then error("mock.given_name: invalid country code") end
		local line = file:read("*line")
		while line do names[#names+1] = line; line = file:read("*line") end
		file:close()
		given_name_cache[country_code] = names
	end
	return names[math.random(#names)]
end

local surname_cache = {} --[[@type table<string, string[]>]]

--[[@param country_code? "*"|mock_surname_country_code]]
mod.surname = function (country_code)
	country_code = country_code or "_"
	local names = surname_cache[country_code]
	if not names then
		names = {}
		local file = io.open(path.resolve(script_path, "mock/name/sur/" .. country_code))
		if not file then error("mock.surname: invalid country code") end
		local line = file:read("*line")
		while line do names[#names+1] = line; line = file:read("*line") end
		file:close()
		surname_cache[country_code] = names
	end
	return names[math.random(#names)]
end

local color_cache

mod.color = function ()
	if not color_cache then
		color_cache = {}
		local file = assert(io.open(path.resolve(script_path, "mock/color")))
		local line = file:read("*line")
		while line do color_cache[#color_cache+1] = line; line = file:read("*line") end
		file:close()
	end
	return color_cache[math.random(#color_cache)]
end

local email_domain_cache --[[@type { domain: string, cumulative_frequency: integer }[] ]]
local email_domain_total_frequency = 0 --[[@type integer]]

mod.email_domain = function ()
	if not email_domain_cache then
		email_domain_cache = {}
		local file = assert(io.open(path.resolve(script_path, "mock/email/domain")))
		local line = file:read("*line")
		while line do
			local domain, freq = line:match("(.-)\t(.+)")
			--[[@type integer]]
			--[[@diagnostic disable-next-line: assign-type-mismatch]]
			email_domain_total_frequency = email_domain_total_frequency + (tonumber(freq) or 0)
			email_domain_cache[#email_domain_cache+1] = { domain = domain, cumulative_frequency = email_domain_total_frequency }
			line = file:read("*line")
		end
		file:close()
	end
	local x = math.random(email_domain_total_frequency)
	for _, d in ipairs(email_domain_cache) do
		if d.cumulative_frequency >= x then return d.domain end
	end
end

mod.email = function ()
	return mod.given_name():gsub(" ", "."):lower() .. "." .. mod.surname():gsub(" ", "."):lower() .. "@" .. mod.email_domain()
end

--[[TODO: mod.email]]

return mod

--[[message name: `char.base`]]
--[[@class gmcp_aardwolf_char_base]]
--[[@field name string]]
--[[@field class string]]
--[[@field subclass string]]
--[[@field race string]]
--[[@field clan string]]
--[[@field pretitle string]]
--[[@field perlevel integer]]
--[[@field tier integer]]
--[[@field remorts integer]]
--[[@field redos integer]]
--[[@field classes string a subset of 0123456 which represent mage, cleric, thief, warrior, ranger, paladin and psionicist in that order]]
--[[@field level integer]]
--[[@field pups integer]]
--[[@field totpups integer]]

--[[message name: `char.vitals`]]
--[[@class gmcp_aardwolf_char_vitals]]
--[[@field hp integer]]
--[[@field mana integer]]
--[[@field moves integer]]

--[[@type gmcp_aardwolf_char_base]]
local x

--[[char.base { "name": Lasher, "class": Warrior, "subclass": Soldier, "race": Elf, "clan": wolf, "pretitle": "Testing ", "perlevel": 1000, "tier": 1, "remorts": 7, "redos": 0, "classes" : "0123456", "level": 210, "pups": 12345, "totpups": 23456 }]]

local mod = {}
mod["char.base"] = function ()

end

return mod

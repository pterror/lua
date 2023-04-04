--[[TODO: http client with persistent connection]]
local json = require("dep.lunajson")
local http_request = require("lib.http.client").request
local format = string.format

--[[@class discord_client]]
--[[@field id string]] -- TODO: put it on thing
local mod = {}

--[[@param method http_method]] --[[@param path string]] --[[@param payload? {}]]
local request = function (method, path, payload)
	http_request(method, "https://discord.com/api/v10/" .. path, {
		--[[TODO: auth]]
		{ ["Content-Type"] = "application/json" }
	}, payload and json.encode(payload) or "")
end

--[[Returns a list of application role connection metadata objects for the given application.]]
--[[@return discord_application_role_connection_metadata[] ]]
mod.get_application_role_connection_metadata_records = function (self)
 return request("GET", format("applications/%s/role-connections/metadata", self.id))
end

--[[Updates and returns a list of application role connection metadata objects for the given application.]]
--[[@param objs discord_application_role_connection_metadata[] ]]
--[[@return discord_application_role_connection_metadata[] ]]
mod.update_application_role_connection_metadata_records = function (self, objs)
	return request("PUT", format("applications/%s/role-connections/metadata", self.id), objs)
end

return mod

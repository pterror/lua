local http = require("lib.http.client")
local json_to_value = require("dep.lunajson").json_to_value

local mod = {}

--[[@param server matrix_server]]
--[[@param path string]]
local get = function(server, path)
	return http.send({ host = server.host, path = path, method = "GET", headers = {}, body = "" })
end

--[[@param server matrix_server]]
--[[@param path string]]
--[[@return unknown]]
local get_json = function(server, path)
	return json_to_value(assert(get(server, path)))
end

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixclient]]
--[[@param server matrix_server]]
--[[@return matrix_server_discovery_info]]
mod.get_server_discovery_info = function(server)
	return get_json(server, "/.well-known/matrix/client")
end

--[[https://spec.matrix.org/v1.11/client-server-api/#get_matrixclientversions]]
--[[@param server matrix_server]]
--[[@return matrix_server_support_info]]
mod.get_server_support_info = function(server)
	return get_json(server, "/.well-known/matrix/support")
end

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixsupport]]
--[[@param server matrix_server]]
--[[@return matrix_versions]]
mod.get_server_versions = function(server)
	return get_json(server, "/_matrix/client/versions")
end

return mod

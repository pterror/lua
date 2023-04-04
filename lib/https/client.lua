--[[IMPL]]

local socket = require("dep.ljsocket")
local tls = require("dep.tls")
local format = require("lib.http.format")

local mod = {}

--[[TODO: the heck does tls_config_insecure_noverifycert do]]
local client_tls = tls.tls_client()
local tls_config = tls.tls_config_new()
tls.tls_config_insecure_noverifycert(tls_config)
tls.tls_config_insecure_noverifyname(tls_config)
tls.tls_configure(client_tls, tls_config)

--[[IMPL: https://github.com/CapsAdmin/luajitsocket/blob/master/examples/tcp_client_blocking_tls.lua]]

--[[@param req http_client_request]]
function mod.request(req)
	req.body = req.body or ""
	-- are domains case sensitive?
	local client = assert(socket.create("inet", "stream", "tcp"))
	assert(client:connect(req.host, "https"))
	assert(client:send(format.http_client_request_to_string(req)))
	--[[TODO: default user agent]]
	--[[TODO: other default headers - language]]
	--[[if not headers[""] ]]
end

return mod

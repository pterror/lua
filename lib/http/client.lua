local socket = require("dep.ljsocket")

local mod = {}

-- TODO: tls: https://github.com/CapsAdmin/luajitsocket/blob/master/examples/tcp_client_blocking_tls.lua

--[[@param method http_method normally uppercase. case-sensitive.]]
--[[@param url string]]
--[[@param headers { [1]: string, [2]: string }[] ]]
--[[@param body string]]
function mod.request(method, url, headers, body)
	-- are domains case sensitive?
	--[[@type string, string, string]]
	local secure, host, path = url:match("http://([^/]+)(.+)")
	if not path then return nil, "invalid url" end
	local client = assert(socket.create("inet", "stream", "tcp"))
	assert(client:connect(host, "http" .. secure))
	assert(client:send(method .. " " .. path .. "HTTP/1.1\r\nHost: " .. host .. "\r\n"))
	--[[IMPL]]
end

return mod

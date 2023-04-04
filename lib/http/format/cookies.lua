local mod = {}

--[[@return table<string,string>? cookies]]
--[[@param req http_request]]
mod.http_request_to_cookies = function (req)
	local cookies_str = (req.headers["cookie"] or {})[1]
	if not cookies_str then return end
	local ret = {}
	for k, v in (cookies_str .. "; "):gmatch("(.-)=(.-); ") do ret[k] = v end
	return ret
end

return mod

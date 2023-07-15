local urlencode_to_string = require("lib.urlencode").urlencode_to_string
local status_names = require("lib.http.status").status_names
local nan = 0 / 0

-- TODO: http/2, http/3, tls

local mod = {}

--[[Documentation taken from https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods]]
--[[@enum http_method]]
mod.method = {
	GET = "GET", --[[Requests a representation of the specified resource. Should only retrieve data.]]
	HEAD = "HEAD", --[[Asks for a response identical to a `GET` request, but without the response body.]]
	POST = "POST", --[[Submits an entity to the specified resource, often causing side effects like a change in state on the server.]]
	PUT = "PUT", --[[Replaces all current representations of the target resource with the request payload.]]
	DELETE = "DELETE", --[[Deletes the specified resource.]]
	CONNECT = "CONNECT", --[[Establishes a tunnel to the server identified by the target resource.]]
	OPTIONS = "OPTIONS", --[[Describes the communication options for the target resource.]]
	TRACE = "TRACE", --[[Performs a message loop-back test along the path to the target resource.]]
	PATCH = "PATCH", --[[Applies partial modifications to a resource.]]
}

-- TODO: default all input and output to streams

--[[@class http_response]]
--[[@field status? integer]]
--[[@field status_text? string]]
--[[@field headers table<string, string | string[]>]]
--[[@field body? string]]

--[[@class http_client_request]]
--[[@field method string]]
--[[@field host string]]
--[[@field port? integer]]
--[[@field path string]]
--[[@field headers table<string, string[]>]]
--[[@field body string]]

--[[@param s string]] --[[@param i? integer]]
mod.string_to_http_request = function (s, i)
	i = i or 1
	local head, body = s:match("(.-)\r\n\r\n(.*)", i) --[[@type string, string]]
	if not head then return end --[[maybe it's https, either way we don't support it]]
	--[[@type string, string, string, string]]
	local method, path, version_raw, headers_raw = head:match("([^ ]*) ([^ ]*) ([^ ]*)\r\n(.*)")
	if not method then return end
	local version = tonumber(version_raw:match("HTTP/([0-9.]+)")) or nan
	local headers = {} --[[@type table<string, string[]>]]
	for line in (headers_raw .. "\r\n"):gmatch("(.-)\r\n") do
		local k, v = line:match("(.-): (.*)") --[[@type string, string]]
		local arr = headers[k:lower()]
		if arr == nil then arr = {}; headers[k:lower()] = arr end
		arr[#arr+1] = v
	end
	local params = {} --[[@type table<string, string>]]
	local param_index = path:find("?")
	if param_index ~= nil then
		local params_str
		--[[@type string, string]]
		path, params_str = path:match("([^?]*)?(.*)")
		for k, v in params_str:gmatch("([^=&]*)=?([^&]*)&?") do
			params[urlencode_to_string(k)] = urlencode_to_string(v)
		end
	end
	--[[TODO: application/x-www-form-urlencoded, multipart/form-data, text/plain]]
	--[[https://www.rfc-editor.org/rfc/rfc9112#name-message-body-length]]
	--[[TODO: http/2]]
	--[[@class http_request]]
	return {
		method = method, path = path, params = params, version_raw = version_raw, version = version,
		headers = headers, body = body
	}, #s + 1 --[[realistically this should take into account content-length]]
end

--[[@param res http_response]]
mod.http_response_to_string = function (res)
	res.body = res.body or ""
	local parts = {} --[[@type string[] ]]
	--[[TODO: http/2]]
	parts[#parts+1] = "HTTP/1.1 " .. (res.status or 200) .. " " .. (res.status_text or status_names[res.status] or status_names[200]) .. "\r\n"
	local res_headers = {} --[[@type table<string, string[]|string>]]
	for k, v in pairs(res.headers or {}) do
		res_headers[k:gsub("^%l", string.upper):gsub("-%l", string.upper)] = v
	end
	if res_headers["Content-Type"] ~= nil then
		parts[#parts+1] = "Content-Type: " .. res_headers["Content-Type"] .. "\r\n"
	end
	parts[#parts+1] = "Content-Length: " .. (res_headers["Content-Length"] or #(res.body or "")) .. "\r\n"
	res_headers["Content-Type"] = nil
	res_headers["Content-Length"] = nil
	for k, v in pairs(res_headers) do
		if type(v) == "table" then
			for i = 1, #v do
				parts[#parts+1] = k .. ": " .. v[i] .. "\r\n"
			end
		else
			parts[#parts+1] = k .. ": " .. v .. "\r\n"
		end
	end
	parts[#parts+1] = "\r\n"
	parts[#parts+1] = res.body
	return table.concat(parts)
end

--[[@param req http_client_request]]
mod.http_client_request_to_string = function (req)
	local parts = {} --[[@type string[] ]]
	parts[#parts+1] = (req.method or "GET") .. " " .. (req.path or "/") .. " HTTP/1.1\r\nHost: " .. req.host .. "\r\n"
	for k, v_ in pairs(req.headers or {}) do
		for _, v in ipairs(v_) do parts[#parts+1] = k .. ": " .. v .. "\r\n" end
	end
	parts[#parts+1] = "\r\n"
	parts[#parts+1] = req.body or ""
	return table.concat(parts)
end

--[[@param s string]] --[[@param i? integer]]
mod.string_to_http_client_response = function (s, i)
	i = i or 1
	local head, body = s:match("(.-)\r\n\r\n(.*)", i) --[[@type string, string]]
	if not head then return end
	--[[@type string, string, string, string]]
	local version_raw, status_raw, status_text, headers_raw = head:match("([^ ]*) ([^ ]*) ([^ ]*)\r\n(.*)")
	if not version_raw then return end
	local version = tonumber(version_raw:match("HTTP/([0-9.]+)")) or nan
	local headers = {} --[[@type table<string, string[]>]]
	for line in (headers_raw .. "\r\n"):gmatch("(.-)\r\n") do
		local k, v = line:match("(.-): (.*)") --[[@type string, string]]
		local arr = headers[k:lower()]
		if arr == nil then arr = {}; headers[k:lower()] = arr end
		arr[#arr+1] = v
	end
	local status = tonumber(status_raw)
	--[[@class http_client_response]]
	return {
		--[[status_raw could be added but for now it is not deemed useful]]
		version_raw = version_raw, version = version, status = status, status_text = status_text, headers = headers,
		body = body,
	}, #s + 1
end

return mod

local path = require("lib.path")
local mimetype_by_name = require("lib.mimetype.by_name").mimetype
local mimetype_by_contents

local mod = {}

--[[@param base? string]]
mod.static_router = function (base)
	if base ~= nil and type(base) ~= "string" then
		return nil, "static_router() expects string as base path, got " .. tostring(base)
	end
	base = (base or "."):gsub("/$", "")
	--[[@return true?]] --[[@param req http_request]] --[[@param res http_response]]
	return function (req, res)
		-- TODO: urldecode? urldecode(req.path)
		local file = io.open(path.resolve(base, req.path), "r")
		if file == nil then res.status = 404; return end
		res.status = 200
		res.body = file:read("*all")
		if res.body == nil then res.status = 404; return end
		file:close()
		-- TODO: consider refactoring this out - it's a one liner either way anyway
		res.headers["Content-Type"] = mimetype_by_name(req.path)
		if not res.headers["Content-Type"] then
			mimetype_by_contents = mimetype_by_contents or require("lib.mimetype.by_contents").mimetype
			res.headers["Content-Type"] = mimetype_by_contents(res.body)
		end
		return true
	end
end

return mod

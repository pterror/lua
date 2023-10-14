-- ideally: path based but with $seg -> param.seg
-- currently: path based copy of staticx_router
local table_router = require("lib.http.router.tablex").table_router
local dir_list = require("lib.fs.dir_list").dir_list
local mimetype_by_name = require("lib.mimetype.by_name").mimetype
local mimetype_by_contents

local mod = {}

--[[@return http_callback]]
--[[@param path? string]]
mod.path_based_router = function (path)
	local handle_file = function (path2) --[[@param path2 string]]
		if path2:find("%.lua$") then
			local success, cb = pcall(dofile, path2)
			if not success then io.stderr:write("path_basedxx: caught error when rendering page: ", cb, "\n") end
			return success and cb or nil
		--[[@diagnostic disable-next-line: undefined-global]]
		elseif DEV then
			return function (req, res)
				local file = io.open(path2)
				if not file then return false end
				local contents = file:read("*all")
				file:close()
				res.body = contents
				res.headers["Content-Type"] = mimetype_by_name(req.path)
				if not res.headers["Content-Type"] then
					mimetype_by_contents = mimetype_by_contents or require("lib.mimetype.by_contents").mimetype
					res.headers["Content-Type"] = mimetype_by_contents(res.body)
				end
				return true
			end
		else
			local file = io.open(path2)
			if not file then return nil end
			local contents = file:read("*all")
			local content_type = mimetype_by_name(path2)
			if not content_type then
				mimetype_by_contents = mimetype_by_contents or require("lib.mimetype.by_contents").mimetype
				content_type = mimetype_by_contents(contents)
			end
			file:close()
			return function (req, res)
				res.body = contents
				res.headers["Content-Type"] = content_type
				return true
			end
		end
	end
	local handle_dir
	handle_dir = function (path2) --[[@param path2 string]]
		local routes = {}
		for entry in dir_list(path2) do
			local new_path = path2 .. "/" .. entry.name
			if entry.is_dir then
				routes[(entry.name == "*") and 1 or entry.name] = handle_dir(new_path)
			else
				local cb = handle_file(new_path)
				if cb then routes[(entry.name == "*.lua") and 1 or entry.name:match("^(.*)%.lua$") or entry.name] = cb end
			end
		end
		return routes
	end
	local cb = table_router(handle_dir(path or ""))
	return function (req, res, sock)
		local ret = cb(req, res, sock)
		if not ret then res.status = 404 end
		return ret
	end
end

return mod


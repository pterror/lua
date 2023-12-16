#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local json = require("dep.lunajson")
local whiskr = require("world.whiskr")

--[[@param root string]]
local make_routes = function (root)
	local db = assert(whiskr.open(root))
	--[[@type http_table_handler]]
	local routes = {
		list = function (_, res)
			local facts = {} --[[@type unknown[] ]]
			for fact in db:list_facts() do facts[#facts+1] = fact end
			res.headers["Content-Type"] = "application/json"
			res.body = json.value_to_json(facts)
		end,
		add = function (req, res)
			local body = json.json_to_value(req.body)
			res.headers["Content-Type"] = "application/json"
			if type(body) ~= "table" or type(body.subject) ~= "string" or type(body.predicate) ~= "string" or type(body.object) ~= "string" then
				res.status = 400
				res.body = [[{"error":"expected `{ subject: string; predicate: string; object: string; }`"}]]
				return
			end
			local success, err = db:add_fact(body)
			if not success then res.status = 400; res.body = [[{"error":"]] .. err .. [["}]]; return end
			res.body = "{}"
		end,
		delete = function (req, res)
			local body = json.json_to_value(req.body)
			res.headers["Content-Type"] = "application/json"
			if type(body) ~= "table" or type(body.subject) ~= "string" or type(body.predicate) ~= "string" or type(body.object) ~= "string" then
				res.status = 400
				res.body = [[{"error":"expected `{ subject: string; predicate: string; object: string; }`"}]]
				return
			end
			local rows_deleted, err = db:remove_fact(body)
			if not rows_deleted then res.status = 400; res.body = [[{"error":"]] .. err .. [["}]]
			elseif rows_deleted == nil then res.status = 400; res.body = [[{"error":"fact not found"}]]
			else res.body = "{}" end
		end,
	}
	return routes
end

if pcall(debug.getlocal, 4, 1) then return { make_routes = make_routes }
else
	local root = arg[1] or "."
	require("lib.http.server").server(
		require("lib.http.router.tablex").table_router(make_routes(root)),
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		tonumber(os.getenv("PORT") or os.getenv("port") or 8080)
	)
end

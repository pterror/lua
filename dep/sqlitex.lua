local sqlite = require("dep.sqlite")

local mod = {}

--[[IMPL]]
--[[FIXME: need a consistent key order]]

--[[prefer model over table; table is a lower-level abstraction]]
--[[useful for 1:m or m:n]]

--[[@class sqlitex_database]]
local database = {}
mod.database = database
database.__index = database

--[[@param path string]]
database.new = function (self, path)
	local db, success, error
	db, error = sqlite.open(path)
	if not db then return db, error end
	local ret = setmetatable({ --[[@class sqlitex_database]]
		db = db,
		models = {}, --[[@type table<string, sqlitex_model<unknown>>]]
	}, self)
	success, error = ret.db:execute("PRAGMA foreign_keys = ON;")
	if not success then return success, error end
	return ret
end

--[[@class sqlitex_model<t>: { schema: t; }]]
--[[@field name string]]
local model = {}
mod.model = model
model.__index = model

local type_converters = {}
local convert_type = function (t)
	local fn = type_converters[t.type]
	if fn then return fn(t)
	else return nil, "sqlitex: cannot store type " .. t.type end
end
type_converters.integer = function () return "INTEGER NOT NULL" end
type_converters.number = function () return "DOUBLE NOT NULL" end
type_converters.string = function () return "TEXT NOT NULL" end
type_converters.boolean = function () return "BOOLEAN NOT NULL" end
type_converters.optional = function (t)
	--[[@diagnostic disable-next-line: unbalanced-assignments]]
	local ret, err = convert_type(t.inner)
	if ret and ret:match(" NOT NULL$") then return ret:sub(1, -#" NOT NULL" - 1) end
	return ret, err
end

--[[@generic t]]
--[[@return sqlitex_model<t>? model, string? err]]
--[[@param db sqlitex_database]]
--[[@param name string]]
--[[@param schema t]]
--[[@param keyorder? string[] ]]
model.new = function (self, db, name, schema, keyorder)
	--[[TODO: migrations - read existing schema from db and divv]]
	--[[TODO: backups]]
	--[[TODO: automatically breaking up complex structures (e.g. array properties -> 1:n relation)]]
	--[[TODO: foreign keys - this can be done with newtypes]]
	--[[TODO: arbitrary validation for t. types]]
	--[[TODO: consider supporting enums]]
	if name:find("`") then return nil, "sqlitex: name cannot contain `: " .. name end
	--[[@diagnostic disable-next-line: undefined-field]]
	if schema.type ~= "struct" and schema.type ~= "struct_exact" then
		return nil, "sqlitex: models must be structs"
	end
	if not keyorder then
		keyorder = {} --[[@type string[] ]] --[[FIXME: better key order]]
		for k in pairs(schema.shape) do
			keyorder[#keyorder+1] = k
			if k:find("`") then return nil, "sqlitex: column cannot contain `: " .. k end
		end
		table.sort(keyorder)
	end
	local ret = setmetatable({ --[[@class sqlitex_model]]
		name = name,
		schema = schema,
		db = db,
		keyorder = keyorder,
	}, self)
	local parts = {}
	parts[#parts+1] = "CREATE TABLE IF NOT EXISTS `" .. name .. "` ("
	local prefix = ""
	for _, k in ipairs(keyorder) do
		parts[#parts+1] = prefix .. k .. " " .. convert_type(schema.shape[k])
		prefix = ","
	end
	parts[#parts+1] = ");"
	print(table.concat(parts))
	local success, err = db.db:execute(table.concat(parts))
	if not success then return success, err end
	return ret
end
--[[@generic t]]
--[[@return sqlitex_model<t>]]
--[[@param name string]]
--[[@param schema t]]
database.model = function (self, name, schema) return model:new(self, name, schema) end

--[[@generic t]]
--[[@param self sqlitex_model<t>]]
--[[@param value t]]
model.add = function (self, value)
	local values = {}
	local v_i = 1
	--[[@diagnostic disable-next-line: undefined-field]]
	for _, k in ipairs(self.keyorder) do
		--[[@diagnostic disable-next-line: undefined-field]]
		if k ~= "id" then values[v_i] = value[self.keyorder[k]] end
	end
	--[[@diagnostic disable-next-line: undefined-field]]
	return self.db.db:execute(self.add_stmt, unpack(values))
end

--[[TODO: model.set]]
--[[TODO: model.delete]]

--[[@generic t]]
--[[@param self sqlitex_model<t>]]
--[[@param value t]]
model.delete = function (self, value)
	--[[@diagnostic disable-next-line: undefined-field]]
	self.db.db:execute("DELETE FROM `" .. self.name .. "`", unpack(values))
	local values = {}
	local v_i = 1
	--[[@diagnostic disable-next-line: undefined-field]]
	for _, k in ipairs(self.keyorder) do
		if k ~= "id" then values[v_i] = self.keyorder[k] end
	end
	--[[@diagnostic disable-next-line: undefined-field]]
	return self.db.db:execute(self.add_stmt, unpack(values))
end

return mod

local ffi = require("ffi")

local mod = {}

ffi.cdef [[
	// opaque structs
	typedef struct sqlite3 sqlite3;
	typedef struct sqlite3_stmt sqlite3_stmt;

	int sqlite3_open(const char *filename, sqlite3 **ppDb);
	int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail);
	int sqlite3_step(sqlite3_stmt*);
	int sqlite3_reset(sqlite3_stmt *pStmt);

	// reading columns
	int sqlite3_column_count(sqlite3_stmt *pStmt);
	int sqlite3_column_type(sqlite3_stmt*, int iCol);
	int sqlite3_column_bytes(sqlite3_stmt*, int iCol);
	const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);
	double sqlite3_column_double(sqlite3_stmt*, int iCol);

	// binding values
	int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
	int sqlite3_bind_double(sqlite3_stmt*, int, double);
	int sqlite3_bind_int(sqlite3_stmt*, int, int);
	int sqlite3_bind_null(sqlite3_stmt*, int);
	int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));

	int sqlite3_finalize(sqlite3_stmt *pStmt);
	int sqlite3_close_v2(sqlite3*);

	const char *sqlite3_errmsg(sqlite3*);
]]

local float = ffi.typeof("float")
local double = ffi.typeof("double")
local is_float_like_cdata = function (a)
	local type = ffi.typeof(a)
	return type == float or type == double
end

local SQLITE_STATIC = 0 --[[application controls lifetime]]
local SQLITE_TRANSIENT = ffi.cast("void(*)(void*)", -1) --[[sqlite makes copy]]

-- datatypes
local SQLITE_INTEGER = 1
local SQLITE_FLOAT = 2
local SQLITE_TEXT = 3 --[[in v2 it meant something else]]
local SQLITE_BLOB = 4
local SQLITE_NULL = 5

--[[@class sqlite_error_c]]

-- TODO: enum for the error
--[[@class sqlite_ffi]]
--[[@field sqlite3_open fun(filename: string, ppDb: sqlite_c): sqlite_error_c]]
--[[@field sqlite3_prepare_v2 fun(db: sqlite_c, zSql: string, nByte: integer, ppStmt: sqlite_stmt_c, pzTail: ffi.cdata* | nil): sqlite_error_c]]
--[[@field sqlite3_step fun(stmt: sqlite_stmt_c): sqlite_error_c]]
--[[@field sqlite3_column_count fun(pStmt: sqlite_stmt_c): sqlite_error_c]]
--[[@field sqlite3_column_type fun(pStmt: sqlite_stmt_c, iCol: integer): sqlite_error_c]]
--[[@field sqlite3_column_bytes fun(pStmt: sqlite_stmt_c, iCol: integer): integer]]
--[[@field sqlite3_column_blob fun(pStmt: sqlite_stmt_c, iCol: integer): string_c]]
--[[@field sqlite3_column_double fun(pStmt: sqlite_stmt_c, iCol: integer): number]]
--[[@field sqlite3_bind_blob fun(pStmt: sqlite_stmt_c, iCol: integer, value: ffi.cdata*, n: integer, free: ffi.cdata* | 0 | -1): sqlite_error_c]]
--[[@field sqlite3_bind_double fun(pStmt: sqlite_stmt_c, iCol: integer, value: number): sqlite_error_c]]
--[[@field sqlite3_bind_int fun(pStmt: sqlite_stmt_c, iCol: integer, value: integer): sqlite_error_c]]
--[[@field sqlite3_bind_null fun(pStmt: sqlite_stmt_c, iCol: integer): sqlite_error_c]]
--[[@field sqlite3_bind_text fun(pStmt: sqlite_stmt_c, iCol: integer, value: string, length: integer, free: ffi.cdata* | 0 | -1): sqlite_error_c]]
--[[@field sqlite3_finalize fun(pStmt: sqlite_stmt_c): sqlite_error_c]]
--[[@field sqlite3_reset fun(pStmt: sqlite_stmt_c): sqlite_error_c]]
--[[@field sqlite3_close_v2 fun(db: sqlite_c): sqlite_error_c]]
--[[@field sqlite3_errmsg fun(db: sqlite_c): string_c]]

--[[@type sqlite_ffi]]
local sqlite_ffi
if ffi.os == "Windows" then
	if ffi.arch == "x64" then sqlite_ffi = ffi.load("dep/sqlite.dll")
	--[[assume x86]]
	else sqlite_ffi = ffi.load("dep/sqlite-x86.dll") end
elseif ffi.os == "Linux" then
	--[[TODO: bundle instead of relying on system installation]]
	sqlite_ffi = ffi.load("sqlite3") --[[@type sqlite_ffi]]
else
	--[[TODO: i think macos has it built in]]
	error("os " .. ffi.os .. "not supported")
end

--[[@param self sqlite]]
local err = function (self) return ffi.string(sqlite_ffi.sqlite3_errmsg(self.db[0])) end

--[[@class sqlite_c]]
--[[@class sqlite_stmt_c]]

--[[we use a class here instead of a module since details are internal anyway]]

--[[@class sqlite]]
--[[@field db sqlite_c]]
local sqlite = {}
sqlite.__index = sqlite
mod.sqlite = sqlite

--[[@return sqlite? database, string? error]] --[[@param path string]]
sqlite.open = function (self, path)
	--[[TODO: does the * to ** conversion work properly]]
	local db = ffi.new("sqlite3 *[1]") --[[@type sqlite_c]]
	if sqlite_ffi.sqlite3_open(path, db) ~= 0 then return nil, "sqlite: sqlite3_open" end
	--[[FIXME: why does this need () around it to suppress error]]
	return (setmetatable({
		db = db
	}, self))
end
--[[@return sqlite? database, string? error]] --[[@param path string]]
mod.open = function (path) return sqlite:open(path) end

sqlite.close = function (self) sqlite_ffi.sqlite3_close_v2(self.db) end

--[[do we need binding for blobs?]]

--[[@param stmt sqlite_stmt_c]]
--[[@param params (number|string|boolean?)[] ]]
--[[@param length integer required because values may be nil]]
local bind = function (stmt, params, length)
	for i = 1, length do
		local x = params[i]
		if type(x) == "number" then
			sqlite_ffi.sqlite3_bind_double(stmt, i, x)
		elseif type(x) == "string" then
			sqlite_ffi.sqlite3_bind_text(stmt, i, x, #x, SQLITE_TRANSIENT)
		elseif type(x) == "boolean" then
			sqlite_ffi.sqlite3_bind_int(stmt, i, x and 1 or 0)
		elseif type(x) == "cdata" and tonumber(x) ~= nil then
			if is_float_like_cdata(x) then
				sqlite_ffi.sqlite3_bind_double(stmt, i, x)
			else
				sqlite_ffi.sqlite3_bind_int(stmt, i, x)
			end
		elseif x == nil then
			sqlite_ffi.sqlite3_bind_null(stmt, i)
		else
			error("sqlite:execute: cannot bind type " .. (type(x) == "cdata" and tostring(ffi.typeof(x)) or type(x)))
		end
	end
end

--[[@return true? success, string? error]] --[[@param sql string]] --[[@param ... number|string|boolean?]]
sqlite.execute = function (self, sql, ...)
	local c_sql = sql
	local next_sql = ffi.new("const char *[1]")
	local stmt_ptr = ffi.new("sqlite3_stmt *[1]") --[[@type sqlite_stmt_c]]
	while true do 
		if sqlite_ffi.sqlite3_prepare_v2(self.db[0], c_sql, -1, stmt_ptr, next_sql) ~= 0 then return nil, "sqlite: sqlite3_prepare_v2: " .. err(self) end
		local stmt = stmt_ptr[0]
		if stmt == nil then break end
		bind(stmt, { ... }, select("#", ...))
		local ret = sqlite_ffi.sqlite3_step(stmt)
		if ret ~= 101 --[[SQLITE_DONE]] then return nil, "sqlite: sqlite3_step: " .. err(self) end
		if next_sql[0] == 0 then break end
		if sqlite_ffi.sqlite3_finalize(stmt) ~= 0 then return nil, "sqlite: sqlite3_finalize: " .. err(self) end
		c_sql = next_sql[0]
	end
	return true
end

--[[warning: ignores all but the first statement  ]]
--[[the returned iterator still returns errors as `nil, err` so please don't make the first column nullable  ]]
--[[it returns errors when done, and when no columns are `SELECT`ed  ]]
--[[if you don't have a non-nullable column then `SELECT 1` and ignore the first column  ]]
--[[@return (fun():...:unknown)? iterator, string? error]] --[[@param sql string]] --[[@param ... number|string|boolean?]]
sqlite.query = function (self, sql, ...)
	local stmt_ptr = ffi.new("sqlite3_stmt *[1]") --[[@type sqlite_stmt_c]]
	if sqlite_ffi.sqlite3_prepare_v2(self.db[0], sql, #sql+1, stmt_ptr, nil) ~= 0 then return nil, "sqlite: sqlite3_prepare_v2: " .. err(self) end
	local stmt = stmt_ptr[0]
	bind(stmt, { ... }, select("#", ...))
	return function ()
		local code = sqlite_ffi.sqlite3_step(stmt)
		if code == 100 then --[[SQLITE_ROW]]
			--[[TODO: consider using luajit int64s (not portable!)]]
			local columns = {}
			local dispatch = {
				[SQLITE_INTEGER] = function (i) columns[i + 1] = sqlite_ffi.sqlite3_column_double(stmt, i) end,
				[SQLITE_FLOAT] = function (i) columns[i + 1] = sqlite_ffi.sqlite3_column_double(stmt, i) end,
				[SQLITE_TEXT] = function (i)
					local length = sqlite_ffi.sqlite3_column_bytes(stmt, i)
					columns[i + 1] = ffi.string(sqlite_ffi.sqlite3_column_blob(stmt, i), length)
				end,
				[SQLITE_BLOB] = function (i)
					local length = sqlite_ffi.sqlite3_column_bytes(stmt, i)
					columns[i + 1] = ffi.string(sqlite_ffi.sqlite3_column_blob(stmt, i), length)
				end,
				[SQLITE_NULL] = function (i) columns[i + 1] = nil end,
			}
			for i = 0, sqlite_ffi.sqlite3_column_count(stmt) - 1 do
				dispatch[sqlite_ffi.sqlite3_column_type(stmt, i)](i)
			end
			if #columns > 0 then return unpack(columns)
			else return nil, "sqlite: no columns" end
		elseif code == 101 then sqlite_ffi.sqlite3_finalize(stmt); return nil, "sqlite: done" --[[SQLITE_DONE]]
		else return nil, "sqlite: sqlite3_step: unhandled code " .. code end
	end
end

return mod

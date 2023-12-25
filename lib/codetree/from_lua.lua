local mod = {}

local string_reader = require("dep.ljltk.reader").string
local lexer = require("dep.ljltk.lexer")
local lua_ast = require("dep.ljltk.lua_ast")
local parser = require("dep.ljltk.parser")

--[[@param code string]]
mod.lua_to_codetree = function (code)
  local tree = parser(lua_ast.New(), lexer(string_reader(code), ""))
end

return mod

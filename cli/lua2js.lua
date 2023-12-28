#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local filename = arg[1]
local reader = require("dep.ljltk.reader").file(filename)
local ls = require("dep.ljltk.lexer")(reader, filename)
local ast_builder = require("dep.ljltk.lua_ast").New()
local ast_tree = require("dep.ljltk.parser")(ast_builder, ls)
local code = require("dep.lua2js").lua2js(ast_tree, filename)
print(code)

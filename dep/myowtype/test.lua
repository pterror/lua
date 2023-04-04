--[[@class luatype_type]]
--[[@field is string]]
--[[@return luatype_type]] --[[@param name string]]
local opaque = function (name) return { is = "type", name = name } end
--[[@return luatype_type]] --[[@param child luatype_type]]
local extends = function (child, ...) child.parents = { ... }; return child end

local string = opaque("string")
local number = opaque("number")
local integer = extends(opaque("integer"), number)

local typecheck = function (tree)
	-- FIXME: make it more general
end

local walk = function (tree)
end

-- TODO: a way to make things const and stuff. should --[[#]] mean arbitrary type-level code??

local code = [=[
	local foo = function () end
	function foo() end
	--[[a comment]] local a = string
]=]
local reader = require("dep.ljltk.reader").string(code)
local ls = require("dep.ljltk.lexer")(reader, code)
local ast_builder = require("dep.ljltk.lua_ast").New()
local ast_tree = require("dep.ljltk.parser")(ast_builder, ls)
require("dep.pretty_print").pretty_print(ast_tree)

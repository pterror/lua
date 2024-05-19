--[[FIXME]]

local path = require("lib.path")
local dir_list = require("lib.fs.dir_list")

mod.api = function (root)
	return {
		--[[@param input {path:string}]]
		list = function (input)
			if type(input) ~= "table" or type(input.path) ~= "string" then
				return nil, "expected `{ path: string; }`"
			end
			local full_path = path.resolve(root, input.path)
			local entries = {} --[[@type file_info[] ]]
			for entry in dir_list.dir_list(full_path) do
				entries[#entries+1] = entry
			end
			return entries
		end,
		--[[@param input {path:string}]]
		read = function (input)
			if type(input) ~= "table" or type(input.path) ~= "string" then
				return nil, "expected `{ path: string; }`"
			end
			local full_path = path.resolve(root, input.path)
			local file = io.open(full_path, "r")
			if not file then return nil, "could not open file for reading" end
			local contents = file:read("*all")
			file:close()
			return contents
		end,
		--[[@param input {path:string,contents:string}]]
		write = function (input)
			if type(input) ~= "table" or type(input.path) ~= "string" or type(input.contents) ~= "string" then
				return nil, "expected `{ path: string; contents: string; }`"
			end
			local full_path = path.resolve(root, input.path)
			local file = io.open(full_path, "w")
			if not file then return nil, "could not open file for writing" end
			file:write(input.contents)
			file:close()
		end,
	}
end
local mod = { }

local rep = string.rep
local insert = table.insert

local dump
dump = function (node, level)
	if not level then level = 1 end
	if type(node) == "nil" then
		return "null"
	end
	if type(node) == "string" then
		return "\""..node.."\""
	end
	if type(node) == "number" then
		return node
	end
	if type(node) == "boolean" or type(node) == "cdata" then
		return tostring(node)
	end
	if type(node) == "function" then
		return tostring(node)
	end

	local buff = { }
	local dent = rep("    ", level)

	if #node == 0 and next(node, nil) then
		insert(buff, "{")
		for k,data in pairs(node) do
			insert(buff, "\n" .. dent .. dump(k) .. ": " .. dump(data, level + 1))
			if next(node, k) then insert(buff, ",") end
		end
		insert(buff, "\n" .. rep("    ", level - 1) .. "}")
	else
		insert(buff, "[")
		for i,data in pairs(node) do
			insert(buff, "\n" .. dent .. dump(data, level + 1))
			if i ~= #node then insert(buff, ",") end
		end
		insert(buff, "\n" .. rep("    ", level - 1) .. "]")
	end

	return table.concat(buff, "")
end

mod.dump = dump

return mod

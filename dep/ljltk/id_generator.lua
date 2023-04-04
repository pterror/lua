local unique_name = function (variables, name)
	if variables:lookup(name) ~= nil then
		local prefix, index = string.match(name, "^(.+)(%d+)$")
		if not prefix then
			prefix, index = name, 1
		else
			index = tonumber(index) + 1
		end
		local test_name = prefix .. tostring(index)
		while variables:lookup(test_name) ~= nil do
			index = index + 1
			test_name = prefix .. tostring(index)
		end
		return test_name
	else
		return name
	end
end

local pseudo = function (name)
	return "@" .. name
end

local pseudo_match = function (pseudo_name)
	return string.match(pseudo_name, "^@(.+)$")
end

local genid = function (variables, name)
	local pname = pseudo(name or "_")
	local uname = unique_name(variables, pname)
	return variables:declare(uname)
end

local normalize = function (variables, raw_name)
	local name = pseudo_match(raw_name)
	local uname = unique_name(variables, name)
	return uname
end

local close_gen_variables = function (variables)
	local vars = variables.current.vars
	for i = 1, #vars do
		local id = vars[i]
		if pseudo_match(id.name) then
			id.name = normalize(variables, id.name)
		end
	end
end

return { genid = genid, close_gen_variables = close_gen_variables }

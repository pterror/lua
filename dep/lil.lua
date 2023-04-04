-- lil
-- little interface library

if jit.os == "Windows" then
	return require("dep.lil.win")
elseif jit.os == "Linux" then
	return require("dep.lil.linux")
else
	return nil, jit.os .. " not supported"
end

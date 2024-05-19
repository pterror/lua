local mod = {}

mod.c = function (code)
  local file = assert(io.popen("tcc -w -run -", "w"))
  file:write(code)
  file:close()
end

return mod

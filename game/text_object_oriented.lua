local mod = {}

--[[@generic t]]
--[[@param obj t]]
--[[@return t]]
mod.new = function (obj, new)
  new = new or {}
  return setmetatable({}, obj)
end
--[[TODO: everything]]

return mod

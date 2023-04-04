local mod = {}

--[[@class make_task]]
--[[@field deps? string[] ]]
--[[@field fn fun()]]
--[[@field desc? string]]

--[[function runner with dependency support]]
--[[@param tasks table<string, make_task>]] --[[@param task_name? string]]
mod.make = function (tasks, task_name)
	local doing = {}
	local done = {}
	local do_
	do_ = function (task_)
		if done[task_] then return true end
		if doing[task_] then return nil, "make: cyclic dependency" end
		doing[task_] = true
		local task = tasks[task_]
		if not task then return nil, "make: unknown task '" .. task_ .. "'" end
		if type(task) == "function" then task = { fn = task } end
		for _, dep in ipairs(task.deps or {}) do
			local ok, err = do_(dep)
			if not ok then return nil, err end
		end
		task.fn()
		doing[task_] = false
		done[task_] = true
		return true
	end
	return do_(task_name or "")
end

--[[@param tasks table<string, make_task>]]
mod.list = function (tasks)
	local keys = {}
	for k in pairs(tasks) do keys[#keys+1] = k end
	table.sort(keys)
	for _, k in pairs(keys) do
		local task = tasks[k]
		if type(task) == "table" and task.desc then print("make.lua " .. k, task.desc) else print("make.lua " .. k) end
	end
end

return mod

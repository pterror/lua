local ui = require("lib.ui.format")

local parse_ref = function (ref) --[[@param ref string]]
	local name --[[@type string]]
	local branch --[[@type string]]
	name = ref:match("^refs/heads/(.+)$")
	if name ~= nil then return { type = "branch", name = name, branch = name } end
	name, branch = ref:match("^refs/remotes/(.-)/(.+)$")
	if name ~= nil then
		return {
			type = "remote_branch",
			name = name .. "/" .. branch,
			remote = name,
			branch = branch,
		}
	end
	name = ref:match("^refs/remotes/(.+)$")
	if name ~= nil then return { type = "remote", name = name, remote = name } end
	--[[TODO: this is never true because checking out a tag goes to its commit]]
	name = ref:match("^refs/tags/(.+)$")
	if name ~= nil then return { type = "tag", name = name, tag = name } end
	name = ref:match("^refs/notes/(.+)$")
	if name ~= nil then return { type = "notes", name = name, namespace = name } end
	--[[TODO: ref may be "HEAD"]]
	return { type = "commit", name = ref, commit = ref };
end

--[[
	TODO: consider using a custom vector format instead of svg.
	maybe just the same constructs supported in `path`s
]]
--[[FIXME: svgs don't work in the terminal]]
--[[@param s string]]
local sym = function (s) return "/git_icons.svg#symbol-" .. s end
--[[@param t string]]
local ref_sym = function (t) return sym("ref-" .. t:gsub("_", "-")) end
--[[@param t string]]
local diff_class = function (t)
	return "status-" .. t:gsub("^worktree_", ""):gsub("^index_", ""):gsub("_", "-")
end
--[[@param t string]]
local worktree_sym = function (t)
	return sym(
		t:sub(1, #"index_") == "index_"
			and "blank"
			or ("file-" .. t:gsub("^worktree_", ""):gsub("_", "-"))
	)
end
--[[@param t string]]
local index_sym = function (t)
	return sym(
		t:sub(1, #"worktree_") == "worktree_"
			and "blank"
			or ("file-" .. t:gsub("^index_", ""):gsub("_", "-"))
	)
end

local api = assert(require("api.git").api(arg[1] or "."))

local head_raw = assert(api.repository.head.name(), "git: could not find head")
local head = parse_ref(head_raw)
local refs = {}
local refs_raw = assert(api.reference.list(), "git: could not list refs")
for i = 1, #refs_raw do refs[i] = parse_ref(refs_raw[i]) end
local diffs = assert(api.status(), "git: could not get changed files")

--[[@generic t, u]]
--[[@param arr t[] ]]
--[[@param fn fun(item: t): u]]
--[[@return u[] ]]
local map = function (arr, fn)
	local ret = {}
	for i = 1, #arr do ret[i] = fn(arr[i]) end
	return ret
end

--[[
	FIXME: how to send ui updates?
	how to specify events and event handlers?
	the *simple* way would be processing on server side but it means super high latency when the server is remote
	this can be solved by decoupling the api from the ui but then the ui still requires its own server
	alternatively the events can be transpiled to frontend code.
]]

--[[TODO: style. remember to do terminal detection for color support]]
return ui.document {
	title = "git",
	ui.heading[1] "git",
	ui.vstack { --[[FIXME: naming of `vstack` and `hstack`]]
		ui.vstack {
			ui.heading[2] "current head",
			ui.hstack { ui.image(ref_sym(head.type)), ui.text(head.name) },
		},
		ui.vstack {
			ui.heading[2] "all refs",
			ui.list {
				unpack(map(refs, function (ref)
					return ui.hstack { ui.image(ref_sym(ref.type)), ui.text(ref.name) }
				end)),
			},
		},
		ui.vstack {
			ui.heading[2] "changed files",
			ui.list {
				unpack(map(diffs, function (diff)
					local class = diff_class(diff.type) --[[FIXME: somehow use this?]]
					local i2w = diff.index_to_workdir
					local h2i = diff.head_to_index
					--[[is there a way to make styling/theming easily configurable?]]
					local name = i2w and (i2w.new_file.path or i2w.old_file.path) or
						h2i and (h2i.new_file.path or h2i.old_file.path)
					return ui.hstack {
						ui.image(worktree_sym(diff.type)),
						ui.image(index_sym(diff.type)),
						ui.text(name),
					}
				end)),
			},
		},
	},
}

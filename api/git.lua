--[[@diagnostic disable: param-type-mismatch]]

local ffi = require("ffi")
local git = require("dep.git")
git.git_libgit2_init()
local version_obj
local prerelease_obj
local features_obj

local mod = {}

local _, null_mod = pcall(require, "lib.null")
mod.null = null_mod and null_mod.null or {}

local git_error_names = {
	[git.GIT_OK] = "ok",
	[git.GIT_ERROR] = "error",
	[git.GIT_ENOTFOUND] = "enotfound",
	[git.GIT_EEXISTS] = "eexists",
	[git.GIT_EAMBIGUOUS] = "eambiguous",
	[git.GIT_EBUFS] = "ebufs",
	[git.GIT_EUSER] = "euser",
	[git.GIT_EBAREREPO] = "ebarerepo",
	[git.GIT_EUNBORNBRANCH] = "eunbornbranch",
	[git.GIT_EUNMERGED] = "eunmerged",
	[git.GIT_ENONFASTFORWARD] = "enonfastforward",
	[git.GIT_EINVALIDSPEC] = "einvalidspec",
	[git.GIT_ECONFLICT] = "econflict",
	[git.GIT_ELOCKED] = "elocked",
	[git.GIT_EMODIFIED] = "emodified",
	[git.GIT_EAUTH] = "eauth",
	[git.GIT_ECERTIFICATE] = "ecertificate",
	[git.GIT_EAPPLIED] = "eapplied",
	[git.GIT_EPEEL] = "epeel",
	[git.GIT_EEOF] = "eeof",
	[git.GIT_EINVALID] = "einvalid",
	[git.GIT_EUNCOMMITTED] = "euncommitted",
	[git.GIT_EDIRECTORY] = "edirectory",
	[git.GIT_EMERGECONFLICT] = "emergeconflict",
	[git.GIT_PASSTHROUGH] = "passthrough",
	[git.GIT_ITEROVER] = "iterover",
	[git.GIT_RETRY] = "retry",
	[git.GIT_EMISMATCH] = "emismatch",
	[git.GIT_EINDEXDIRTY] = "eindexdirty",
	[git.GIT_EAPPLYFAIL] = "eapplyfail",
	[git.GIT_EOWNER] = "eowner",
	[git.GIT_TIMEOUT] = "timeout",
}
mod.error_names = git_error_names

local git_status_names = {
	[git.GIT_STATUS_CURRENT] = "current",
	[git.GIT_STATUS_INDEX_NEW] = "index_new",
	[git.GIT_STATUS_INDEX_MODIFIED] = "index_modified",
	[git.GIT_STATUS_INDEX_DELETED] = "index_deleted",
	[git.GIT_STATUS_INDEX_RENAMED] = "index_renamed",
	[git.GIT_STATUS_INDEX_TYPECHANGE] = "index_typechange",
	[git.GIT_STATUS_WT_NEW] = "worktree_new",
	[git.GIT_STATUS_WT_MODIFIED] = "worktree_modified",
	[git.GIT_STATUS_WT_DELETED] = "worktree_deleted",
	[git.GIT_STATUS_WT_TYPECHANGE] = "worktree_typechange",
	[git.GIT_STATUS_WT_RENAMED] = "worktree_renamed",
	[git.GIT_STATUS_WT_UNREADABLE] = "worktree_unreadable",
	[git.GIT_STATUS_IGNORED] = "ignored",
	[git.GIT_STATUS_CONFLICTED] = "conflicted",
}
mod.status_names = git_status_names

local git_delta_names = {
	[git.GIT_DELTA_UNMODIFIED] = "unmodified",
	[git.GIT_DELTA_ADDED] = "added",
	[git.GIT_DELTA_DELETED] = "deleted",
	[git.GIT_DELTA_MODIFIED] = "modified",
	[git.GIT_DELTA_RENAMED] = "renamed",
	[git.GIT_DELTA_COPIED] = "copied",
	[git.GIT_DELTA_IGNORED] = "ignored",
	[git.GIT_DELTA_UNTRACKED] = "untracked",
	[git.GIT_DELTA_TYPECHANGE] = "typechange",
	[git.GIT_DELTA_UNREADABLE] = "unreadable",
	[git.GIT_DELTA_CONFLICTED] = "conflicted",
}
mod.delta_names = git_delta_names

local git_filemode_names = {
	[git.GIT_FILEMODE_UNREADABLE] = "unreadable",
	[git.GIT_FILEMODE_TREE] = "tree",
	[git.GIT_FILEMODE_BLOB] = "blob",
	[git.GIT_FILEMODE_BLOB_EXECUTABLE] = "blob_executable",
	[git.GIT_FILEMODE_LINK] = "link",
	[git.GIT_FILEMODE_COMMIT] = "commit",
}
mod.filemode_names = git_filemode_names

local git_diff_flag_names = {
	[git.GIT_DIFF_FLAG_BINARY] = "binary",
	[git.GIT_DIFF_FLAG_NOT_BINARY] = "not_binary",
	[git.GIT_DIFF_FLAG_VALID_ID] = "valid_id",
	[git.GIT_DIFF_FLAG_EXISTS] = "exists",
	[git.GIT_DIFF_FLAG_VALID_SIZE] = "valid_size",
}
mod.diff_flag_names = git_diff_flag_names

local repo_head = function (repo)
	local head_ptr = ffi.new("git_reference *[1]")
	local err = git.git_repository_head(head_ptr, repo)
	if err >= 0 then return ffi.gc(head_ptr[0], git.git_reference_free)
	else return nil, git_error_names[err] .. "in `git_repository_head`" end
end

local ref_name = function (ref)
	local name = git.git_reference_name(ref)
	if name ~= nil then return ffi.string(name) end
end

local oid_buf = ffi.new("char[?]", git.GIT_OID_SHA1_HEXSIZE + 1)
local oid_hex = function (oid, len)
	git.git_oid_fmt(oid_buf, oid)
	return ffi.string(oid_buf, len)
end

local diff_flags = function (flags)
	local ret = {} --[[@type string[] ]]
	for flag, name in pairs(git_diff_flag_names) do
		if bit.band(flags, flag) ~= 0 then ret[#ret+1] = name end
	end
	return ret
end

local diff_file = function (file)
	return {
		id = oid_hex(file.id, file.id_abbrev),
		path = ffi.string(file.path),
		size = tonumber(file.size),
		flags = diff_flags(file.flags),
		mode = git_filemode_names[file.mode],
	}
end

local diff_delta = function (delta)
	return {
		type = git_delta_names[delta.status],
		flags = diff_flags(delta.flags),
		similarity = delta.similarity,
		nfiles = delta.nfiles,
		old_file = diff_file(delta.old_file),
		new_file = diff_file(delta.new_file),
	}
end

--[[@param root string]]
mod.api = function (root)
	local repo do
		local repo_ptr = ffi.new("git_repository *[1]")
		local err = git.git_repository_open(repo_ptr, root)
		if err < 0 then
			return nil, git_error_names[err] .. " in `git_repository_open`"
		end
		repo = ffi.gc(repo_ptr[0], git.git_repository_free)
	end
	return {
		meta = {
			version = function ()
				if not version_obj then
					local version_c = ffi.new("int[3]")
					git.git_libgit2_version(version_c, version_c + 1, version_c + 2)
					version_obj = { version_c[0], version_c[1], version_c[2] }
				end
				return version_obj
			end,
			prerelease = function ()
				if not prerelease_obj then
					local prerelease_c = git.git_libgit2_prerelease()
					prerelease_obj = prerelease_c ~= nil and ffi.string(prerelease_c) or mod.null
				end
				return prerelease_obj
			end,
			features = function ()
				if not features_obj then
					features_obj = {}
					local feature_flags = git.git_libgit2_features()
					if bit.band(feature_flags, git.GIT_FEATURE_THREADS) then features_obj[#features_obj+1] = [["threads"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_HTTPS) then features_obj[#features_obj+1] = [["https"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_SSH) then features_obj[#features_obj+1] = [["ssh"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_NSEC) then features_obj[#features_obj+1] = [["nsec"]] end
				end
				return features_obj
			end,
			--[[omitted: options (git_libgit2_opts, both setting and getting)]]
		},
		repository = {
			is_empty = function ()
				local is_empty = git.git_repository_is_empty(repo)
				if is_empty < 0 then return nil, git_error_names[is_empty] .. " in `git_repository_is_empty`" end
				return is_empty ~= 0
			end,
			head = {
				name = function ()
					local head, err = repo_head(repo)
					local name = head and ref_name(head)
					if name == "HEAD" then
						local obj_ptr = ffi.new("git_object*[1]")
						err = git.git_reference_peel(obj_ptr, head, git.GIT_OBJECT_COMMIT)
						if err < 0 then return nil, git_error_names[err] .. " in `git_reference_peel`" end
					end
					if not head then return nil, err end
					return name
				end,
			},
			--[[
				omitted:
				- git_repository_discover
			]]
		},
		reference = {
			list = function ()
				local strarray_ptr = ffi.new("git_strarray[1]")
				local err = git.git_reference_list(strarray_ptr, repo)
				if err < 0 then return nil, git_error_names[err] .. " in `git_reference_list`" end
				local strarray = strarray_ptr[0]
				local refs = {} --[[@type string[] ]]
				for i = 0, tonumber(strarray.count) - 1 do refs[i + 1] = ffi.string(strarray.strings[i]) end
				git.git_strarray_free(strarray_ptr[0])
				return refs
			end,
		},
		file = {
			["*"] = {
				blame = function (input)
					local blame_ptr = ffi.new("git_blame*[1]")
					local err = git.git_blame_file(blame_ptr, repo, input.globs[1], nil)
					if err < 0 then return nil, git_error_names[err] .. " in `git_blame_file`" end
					--[[FIXME: return value?]]
				end,
			},
		},
		status = function ()
			local status_list_ptr = ffi.new("git_status_list*[1]")
			local err = git.git_status_list_new(status_list_ptr, repo, nil)
			if err < 0 then return nil, git_error_names[err] .. " in `git_status_list_new`" end
			local status_list = status_list_ptr[0]
			local statuses = {}
			for i = 1, tonumber(git.git_status_list_entrycount(status_list)) do
				local entry = git.git_status_byindex(status_list, i - 1)
				if entry == nil then io.stderr:write("serve_api.git.status: error reading status")
				else
					statuses[#statuses+1] = {
						type = git_status_names[tonumber(entry.status)],
						head_to_index = entry.head_to_index ~= nil and diff_delta(entry.head_to_index[0]) or mod.null,
						index_to_workdir = entry.index_to_workdir ~= nil and diff_delta(entry.index_to_workdir[0]) or mod.null,
					}
				end
			end
			return statuses
		end,
		-- ref = { --[[branches, commits and tags are all refs]]
		-- 	["*"] = {
		-- 		path = {
		-- 			["*"] = {
		-- 				list = {
		-- 					--[[IMPL]]
		-- 				},
		-- 				contents = {
		-- 					--[[IMPL]]
		-- 				},
		-- 			},
		-- 		},
		-- 		merge = {
		-- 			--[[IMPL]]
		-- 		},
		-- 	},
		-- },
	}
end

return mod

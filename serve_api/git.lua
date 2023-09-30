#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: param-type-mismatch]]

local ffi = require("ffi")
local json = require("dep.lunajson")
local git = require("dep.git")
git.git_libgit2_init()
local version_str
local prerelease_str
local features_str

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

local git_filemode_names = {
	[git.GIT_FILEMODE_UNREADABLE] = "unreadable",
	[git.GIT_FILEMODE_TREE] = "tree",
	[git.GIT_FILEMODE_BLOB] = "blob",
	[git.GIT_FILEMODE_BLOB_EXECUTABLE] = "blob_executable",
	[git.GIT_FILEMODE_LINK] = "link",
	[git.GIT_FILEMODE_COMMIT] = "commit",
}

local git_diff_flag_names = {
	[git.GIT_DIFF_FLAG_BINARY] = "binary",
	[git.GIT_DIFF_FLAG_NOT_BINARY] = "not_binary",
	[git.GIT_DIFF_FLAG_VALID_ID] = "valid_id",
	[git.GIT_DIFF_FLAG_EXISTS] = "exists",
	[git.GIT_DIFF_FLAG_VALID_SIZE] = "valid_size",
}

local repo_head = function (repo)
	local head_ptr = ffi.new("git_reference *[1]")
	local err = git.git_repository_head(head_ptr, repo)
	if err >= 0 then return ffi.gc(head_ptr[0], git.git_reference_free)
	else return nil, git_error_names[err] .. [[in `git_repository_head`]] end
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
local make_routes = function (root)
	local repo do
		local repo_ptr = ffi.new("git_repository *[1]")
		local err = git.git_repository_open(repo_ptr, root)
		if err < 0 then
			return function (_, res)
				res.headers["Content-Type"] = "application/json"
				res.status = 404
				res.body = [[{"error":"]] .. git_error_names[err] .. [[ in `git_repository_open`"}]]
			end
		end
		repo = ffi.gc(repo_ptr[0], git.git_repository_free)
	end
	--[[@type http_table_handler]]
	local routes = {
		meta = {
			version = function (_, res)
				if not version_str then
					local version_c = ffi.new("int[3]")
					git.git_libgit2_version(version_c, version_c + 1, version_c + 2)
					version_str = "[" .. version_c[0] .. "," .. version_c[1] .. "," .. version_c[2] .. "]"
				end
				res.headers["Content-Type"] = "application/json"
				res.body = version_str
			end,
			prerelease = function (_, res)
				if not prerelease_str then
					local prerelease_c = git.git_libgit2_prerelease()
					prerelease_str = prerelease_c ~= nil and ("\"" .. ffi.string(prerelease_c) .. "\"") or "null"
				end
				res.headers["Content-Type"] = "application/json"
				res.body = prerelease_str
			end,
			features = function (_, res)
				if not features_str then
					local features = {}
					local feature_flags = git.git_libgit2_features()
					if bit.band(feature_flags, git.GIT_FEATURE_THREADS) then features[#features+1] = [["threads"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_HTTPS) then features[#features+1] = [["https"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_SSH) then features[#features+1] = [["ssh"]]
					elseif bit.band(feature_flags, git.GIT_FEATURE_NSEC) then features[#features+1] = [["nsec"]] end
					features_str = "[" .. table.concat(features, ",") .. "]"
				end
				res.headers["Content-Type"] = "application/json"
				res.body = features_str
			end,
			--[[omitted: options (git_libgit2_opts, both setting and getting)]]
		},
		repository = {
			is_empty = function (_,  res)
				local is_empty = git.git_repository_is_empty(repo)
				res.headers["Content-Type"] = "application/json"
				if is_empty < 0 then res.status = 404; res.body = [[{"error":"]] .. git_error_names[is_empty] .. [[ in `git_repository_is_empty`"}]]; return end
				res.body = is_empty == 0 and "false" or "true"
			end,
			head = {
				name = function (_, res)
					local head, err = repo_head(repo)
					local name = head and ref_name(head)
					if name == "HEAD" then
						local obj_ptr = ffi.new("git_object*[1]")
						err = git.git_reference_peel(obj_ptr, head, git.GIT_OBJECT_COMMIT)
						if err < 0 then res.status = 404; res.body = [[{"error":"]] .. git_error_names[err] .. [[ in `git_reference_peel`"}]]; return end
					end
					res.headers["Content-Type"] = "application/json"
					if err then res.status = 404; res.body =  [[{"error":"]] .. err .. [["}]]; return end
					res.body = json.value_to_json(name)
				end,
			},
			--[[
				omitted:
				- git_repository_discover
			]]
		},
		reference = {
			list = function (_, res)
				local strarray_ptr = ffi.new("git_strarray[1]")
				local err = git.git_reference_list(strarray_ptr, repo)
				if err < 0 then res.status = 404; res.body = [[{"error":"]] .. git_error_names[err] .. [[ in `git_reference_list`"}]]; return end
				local strarray = strarray_ptr[0]
				local refs = {} --[[@type string]]
				for i = 0, tonumber(strarray.count) - 1 do
					refs[i + 1] = ffi.string(strarray.strings[i])
				end
				git.git_strarray_free(strarray_ptr[0])
				res.headers["Content-Type"] = "application/json"
				res.body = json.value_to_json(refs)
			end,
		},
		file = {
			["*"] = {
				blame = function (req, res)
					local blame_ptr = ffi.new("git_blame*[1]")
					local err = git.git_blame_file(blame_ptr, repo, req.globs[1], nil)
					if err < 0 then res.status = 404; res.body = [[{"error":"]] .. git_error_names[err] .. [[ in `git_blame_file`"}]]; return end
				end,
			},
		},
		status = function (_, res)
			local status_list_ptr = ffi.new("git_status_list*[1]")
			local err = git.git_status_list_new(status_list_ptr, repo, nil)
			if err < 0 then res.status = 404; res.body = [[{"error":"]] .. git_error_names[err] .. [[ in `git_status_list_new`"}]]; return end
			local status_list = status_list_ptr[0]
			local statuses = {}
			for i = 1, tonumber(git.git_status_list_entrycount(status_list)) do
				local entry = git.git_status_byindex(status_list, i - 1)
				if entry == nil then io.stderr:write("serve_api.git.status: error reading status")
				else
					statuses[#statuses+1] = {
						type = git_status_names[tonumber(entry.status)],
						head_to_index = entry.head_to_index ~= nil and diff_delta(entry.head_to_index[0]) or json.null,
						index_to_workdir = entry.index_to_workdir ~= nil and diff_delta(entry.index_to_workdir[0]) or json.null,
					}
				end
			end
			res.headers["Content-Type"] = "application/json"
			res.body = json.value_to_json(statuses)
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
	return routes
end

if pcall(debug.getlocal, 4, 1) then return { make_routes = make_routes }
else
	local root = arg[1] or "."
	require("lib.http.server").server(
		require("lib.http.router.tablex").table_router(make_routes(root)),
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		tonumber(os.getenv("PORT") or os.getenv("port") or 8080)
	)
end

local json_to_value = require("dep.lunajson").json_to_value
local http = require("lib.https.client")

local mod = {}

--[[@class github_uri: string]]
--[[@class github_date_time: string]]

--[[@class github_commit]]
--[[@field sha string]]
--[[@field url github_uri]]

--[[@class github_required_status_check]]
--[[@field context string]]
--[[@field app_id integer|nil]]

--[[@class github_required_status_checks]]
--[[@field url? string]]
--[[@field enforcement_level? string]]
--[[@field contexts string[] ]]
--[[@field checks github_required_status_check[] ]]
--[[@field contexts_url? string]]
--[[@field strict? boolean]]

--[[@class github_enforce_admins]]
--[[@field url github_uri]]
--[[@field enabled boolean]]

--[[@class github_simple_user]]
--[[@field name? string|nil]]
--[[@field email? string|nil]]
--[[@field login string]]
--[[@field id integer]]
--[[@field node_id string]]
--[[@field avatar_url github_uri]]
--[[@field gravatar_id string|nil]]
--[[@field url github_uri]]
--[[@field html_url github_uri]]
--[[@field followers_url github_uri]]
--[[@field following_url string]]
--[[@field gists_url string]]
--[[@field starred_url string]]
--[[@field subscriptions_url github_uri]]
--[[@field organizations_url github_uri]]
--[[@field repos_url github_uri]]
--[[@field events_url string]]
--[[@field received_events_url github_uri]]
--[[@field type string]]
--[[@field site_admin boolean]]
--[[@field starred_at? string e.g. `2020-07-09T00:17:55Z`]]

--[[@class github_permissions]]
--[[@field pull boolean]]
--[[@field triage boolean]]
--[[@field push boolean]]
--[[@field maintain boolean]]
--[[@field admin boolean]]

--[[@class github_team_simple]]
--[[@field id integer]]
--[[@field node_id string]]
--[[@field url github_uri]]
--[[@field members_url string]]
--[[@field name string]]
--[[@field description string|nil]]
--[[@field permission string]]
--[[@field privacy? string]]
--[[@field html_url github_uri]]
--[[@field repositories_url github_uri]]
--[[@field slug string]]
--[[@field ldap_dn string]]

--[[@class github_team]]
--[[@field id integer]]
--[[@field node_id string]]
--[[@field name string]]
--[[@field slug string]]
--[[@field description string|nil]]
--[[@field privacy? string]]
--[[@field permission string]]
--[[@field permissions? github_permissions]]
--[[@field url github_uri]]
--[[@field html_url github_uri]]
--[[@field members_url string]]
--[[@field repositories_url github_uri]]
--[[@field parent github_team_simple|nil]]

--[[properties can be `read`/`write`... what else?]]
--[[@class github_app_permissions: { [string]: string }]]
--[[@field issues string]]
--[[@field checks string]]
--[[@field metadata string]]
--[[@field contents string]]
--[[@field deployments string]]

--[[@class github_app]]
--[[@field id integer]]
--[[@field slug? string]]
--[[@field node_id string]]
--[[@field owner github_simple_user|nil]]
--[[@field name string]]
--[[@field description string|nil]]
--[[@field external_url github_uri]]
--[[@field html_url github_uri]]
--[[@field created_at github_date_time]]
--[[@field updated_at github_date_time]]
--[[@field permissions github_app_permissions]]
--[[@field events string[] ]]
--[[@field installations_count? integer]]
--[[@field client_id? string]]
--[[@field client_secret? string]]
--[[@field webhook_secret? string|nil]]
--[[@field pem? string]]

--[[@class github_dismissal_restrictions]]
--[[@field users? github_simple_user[] ]]
--[[@field teams? github_team[] ]]
--[[@field apps? github_app[] ]]
--[[@field url? string]]
--[[@field users_url? string]]
--[[@field teams_url? string]]

--[[@class github_bypass_pull_request_allowances]]
--[[@field users? github_simple_user[] ]]
--[[@field teams? github_team[] ]]
--[[@field apps? github_app[] ]]

--[[@class github_required_pull_request_reviews]]
--[[@field url? github_uri]]
--[[@field dismissal_restrictions? github_dismissal_restrictions]]
--[[@field bypass_pull_request_allowances? github_bypass_pull_request_allowances]]
--[[@field dismiss_stale_reviews boolean]]
--[[@field require_code_owner_reviews boolean]]
--[[@field required_approving_review_count? integer `[0,6]`]]
--[[@field require_last_push_approval? boolean default `false`]]

--[[@class github_branch_restriction_policy]]
--[[@field url github_uri]]
--[[@field users_url github_uri]]
--[[@field teams_url github_uri]]
--[[@field apps_url github_uri]]
--[[@field users github_simple_user[] schema outdated compared to other instances]]
--[[@field teams github_team[] schema outdated compared to other instances]]
--[[@field apps github_app[] schema outdated compared to other instances]]

--[[@class github_feature]]
--[[@field enabled? boolean]]

--[[@class github_feature_default_false]]
--[[@field enabled? boolean default `false`]]

--[[@class github_required_signatures]]
--[[@field url github_uri]]
--[[@field enabled boolean]]

--[[@class github_branch_protection]]
--[[@field url? string]]
--[[@field enabled? boolean]]
--[[@field required_status_checks? github_required_status_checks]]
--[[@field enforce_admins? github_enforce_admins]]
--[[@field required_pull_request_reviews? github_required_pull_request_reviews]]
--[[@field restrictions? github_branch_restriction_policy]]
--[[@field required_linear_history? github_feature]]
--[[@field allow_force_pushes? github_feature]]
--[[@field allow_deletions? github_feature]]
--[[@field block_creations? github_feature]]
--[[@field required_conversation_resolution? github_feature]]
--[[@field name? string]]
--[[@field protection_url? string]]
--[[@field required_signatures? github_required_signatures]]
--[[@field lock_branch? github_feature_default_false]]
--[[@field allow_fork_syncing? github_feature_default_false]]

--[[@class github_short_branch]]
--[[@field name string]]
--[[@field commit github_commit]]
--[[@field protected boolean]]
--[[@field protection? github_branch_protection]]
--[[@field protection_url? github_uri]]

mod.api_host = "api.github.com"
mod.api_path = ""

mod.common_headers = {
	{ "Accept", { "application/vnd.github+json" } },
	--[[FIXME: { "Authorization", { "Bearer <YOUR-TOKEN>" } },]]
	{ "X-GitHub-Api-Version", { "2022-11-28" } },
}

local error = {
	[403] = "Forbidden",
	[404] = "Resource not found",
	[422] = "Validation failed, or the endpoint has been spammed",
}

--[[https://docs.github.com/en/rest/branches/branches?apiVersion=2022-11-28]]
--[[@return github_short_branch[]?, string? error]] --[[@param owner string]] --[[@param repo string]]
mod.list_branches = function (owner, repo)
	local res = http.request({
		method = "GET",
		host = mod.api_host,
		path = (mod.api_path .. "repos/%s/%s/branches"):format(owner, repo),
		headers = mod.common_headers,
	})
	if res.status == 200 then
		--[[@diagnostic disable-next-line: return-type-mismatch]]
		return json_to_value(res.body)
	else
		return error[res.status]
	end
end

--[[@return github_branch_with_protection, string? error]] --[[@param owner string]] --[[@param repo string]] --[[@param branch string]]
mod.get_branch = function (owner, repo, branch)
	local res = http.request({
		method = "GET",
		host = mod.api_host,
		path = (mod.api_path .. "repos/%s/%s/branches/%s"):format(owner, repo, branch),
		headers = mod.common_headers,
	})
	if res.status == 200 then
		--[[@diagnostic disable-next-line: return-type-mismatch]]
		return json_to_value(res.body)
	else
		return error[res.status]
	end
end

--[[@return github_branch_with_protection]] --[[@param owner string]] --[[@param repo string]] --[[@param branch string]] --[[@param new_name string]]
mod.rename_branch = function (owner, repo, branch, new_name)
	local res = http.request({
		method = "POST",
		host = mod.api_host,
		path = (mod.api_path .. "repos/%s/%s/branches/%s/rename"):format(owner, repo, branch),
		headers = mod.common_headers,
		body = new_name
	})
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	return json_to_value(res.body)
end

local sync_branch_error = {
	[409] = "The branch could not be synced because of a merge conflict",
	[422] = "The branch could not be synced, but not because of a merge conflict"
}

return mod

--[[IMPL]]

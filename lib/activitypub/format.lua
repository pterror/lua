local activitystreams = require("lib.activitystreams.format")
local t = require("lib.type")

--[[https://w3c.github.io/activitypub/]]

local mod = {}

--[[@class activitypub_like: activitystreams_object]]
--[[@field type "Like"]]
--[[@field actor string]]
--[[@field name string narrowed]]
--[[@field object string]]
--[[@field to string|string[] narrowed]]
--[[@field cc string|string[] narrowed]]

--[[wait this is like (has actor + object)]]
--[[@class activitypub_like_normalized: activitypub_like]]
--[[@field to string[] narrowed]]
--[[@field cc string[] narrowed]]

mod.namespace = activitystreams.namespace

mod.activity_schema = t.struct({
	["@context"] = t.any_of(
		t.literal(mod.namespace),
		t.tuple({ t.literal(mod.namespace), t.struct({
			["@language"] = t.string,
		}) })
	),
	type = t.string,
	actor = t.string, --[[url]]
	name = t.string,
	object = t.string, --[[url]]
	to = t.any_of(t.string, t.array(t.string)), --[[url]]
	cc = t.any_of(t.string, t.array(t.string)), --[[url]]
})

mod.activity_normalizers = {}

--[[@return activitypub_like_normalized]]
--[[@param activity activitypub_like]]
--[[mutates `activity`.]]
mod.activity_normalizers.like = function (activity)
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	if type(activity.to) ~= "table" then activity.to = { activity.to } end
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	if type(activity.cc) ~= "table" then activity.cc = { activity.cc } end
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	return activity
end

mod.activity_mimetype = [[application/ld+json; profile="https://www.w3.org/ns/activitystreams"]]
mod.is_activity_mimetype = {
	[mod.activity_mimetype] = true, ["application/activity+json"] = true,
}

local aaab = [[
	Activities addressed to this special URI shall be accessible to all users, without authentication.
	Implementations MUST NOT deliver to the "public" special collection; it is not capable of receiving actual activities.

	{
		"@context": "https://www.w3.org/ns/activitystreams",
		"id": "https://www.w3.org/ns/activitystreams#Public",
		"type": "Collection"
	}
]]

local aaaa = [[
POST /outbox/ HTTP/1.1
Host: dustycloud.org
Authorization: Bearer XXXXXXXXXXX
Content-Type: application/ld+json; profile="https://www.w3.org/ns/activitystreams"

activity_schema
]]

return mod

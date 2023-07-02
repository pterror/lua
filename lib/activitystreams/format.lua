local t = require("lib.type")

--[[TODO: everything]]

--[[https://www.w3.org/TR/activitystreams-vocabulary/]]

local mod = {}

mod.namespace = "https://www.w3.org/ns/activitystreams"

mod.type_cache = {}
mod.type_cache.string = t.string
mod.type_cache.string_arr = t.array(mod.type_cache.string)
mod.type_cache.string_or_arr = t.any_of(mod.type_cache.string, mod.type_cache.string_arr)
mod.type_cache.string_opt = t.optional(mod.type_cache.string)
mod.type_cache.string_or_arr_opt = t.optional(mod.type_cache.string_or_arr)
mod.type_cache.integer = t.integer
mod.type_cache.integer_opt = t.optional(mod.type_cache.integer)
mod.type_cache["nil"] = t["nil"]
mod.type_cache.nil_opt = t.optional(mod.type_cache["nil"])

--[[core types]]

local context_schema = t.any_of(
  t.literal(mod.namespace),
  t.tuple({ t.literal(mod.namespace), t.struct({
    ["@language"] = t.string,
  }) })
)

--[[@class activitystreams_object]]
--[[@field ["@context"] "https://www.w3.org/ns/activitystreams"|{[0]:"https://www.w3.org/ns/activitystreams",[1]?:{language:string}}]]
--[[@field type string]]
--[[@field attachment? string]]
--[[@field attributedTo? string]]
--[[@field audience? string]]
--[[@field content? string]]
--[[@field context? string]]
--[[@field contentMap? string]]
--[[@field name? string]]
--[[@field nameMap? string]]
--[[@field endTime? string]]
--[[@field generator? string]]
--[[@field icon? string]]
--[[@field image? string]]
--[[@field inReplyTo? string]]
--[[@field location? string]]
--[[@field preview? string]]
--[[@field published? string]]
--[[@field replies? string]]
--[[@field startTime? string]]
--[[@field summary? string]]
--[[@field summaryMap? string]]
--[[@field tag? string]]
--[[@field updated? string]]
--[[@field url? string]]
--[[@field to? string|string[] ]]
--[[@field bto? string|string[] ]]
--[[@field cc? string|string[] ]]
--[[@field bcc? string|string[] ]]
--[[@field mediaType? string]]
--[[@field duration? string]]

mod.activitystreams_any_object_schema = t.struct({
	["@context"] = context_schema,
  type = mod.type_cache.string_opt,
  attachment = mod.type_cache.string_opt,
  attributedTo = mod.type_cache.string_opt,
  audience = mod.type_cache.string_opt,
  content = mod.type_cache.string_opt,
  context = mod.type_cache.string_opt,
  contentMap = mod.type_cache.string_opt,
  name = mod.type_cache.string_opt,
  nameMap = mod.type_cache.string_opt,
  endTime = mod.type_cache.string_opt,
  generator = mod.type_cache.string_opt,
  icon = mod.type_cache.string_opt,
  image = mod.type_cache.string_opt,
  inReplyTo = mod.type_cache.string_opt,
  location = mod.type_cache.string_opt,
  preview = mod.type_cache.string_opt,
  published = mod.type_cache.string_opt,
  replies = mod.type_cache.string_opt,
  startTime = mod.type_cache.string_opt,
  summary = mod.type_cache.string_opt,
  summaryMap = mod.type_cache.string_opt,
  tag = mod.type_cache.string_opt,
  updated = mod.type_cache.string_opt,
  url = mod.type_cache.string_opt,
  to = mod.type_cache.string_or_arr_opt,
  bto = mod.type_cache.string_or_arr_opt,
  cc = mod.type_cache.string_or_arr_opt,
  bcc = mod.type_cache.string_or_arr_opt,
  mediaType = mod.type_cache.string_opt,
  duration = mod.type_cache.string_opt,
})

--[[@class activitystreams_link]]
--[[@field ["@context"] "https://www.w3.org/ns/activitystreams"|{[0]:"https://www.w3.org/ns/activitystreams",[1]?:{language:string}}]]
--[[@field type "Link"]]
--[[@field href? string]]
--[[@field rel? string]]
--[[@field mediaType? string]]
--[[@field name? string]]
--[[@field hreflang? string]]
--[[@field height? integer]]
--[[@field width? integer]]
--[[@field preview? string]]

mod.activitystreams_link_schema = t.struct({
	["@context"] = context_schema,
  type = t.literal("Link"),
  href = mod.type_cache.string_opt,
  rel = mod.type_cache.string_opt,
  mediaType = mod.type_cache.string_opt,
  name = mod.type_cache.string_opt,
  hreflang = mod.type_cache.string_opt,
  height = mod.type_cache.integer_opt,
  width = mod.type_cache.integer_opt,
  preview = mod.type_cache.string_opt,
})

--[[@class activitystreams_activity: activitystreams_object]]
--[[@field actor? activitystreams_object]]
--[[@field object? activitystreams_object]]
--[[@field target? activitystreams_object]]
--[[@field result? activitystreams_object]]
--[[@field origin? activitystreams_object]]
--[[@field instrument? string]]

mod.activitystreams_activity_schema = t.struct(setmetatable({
  type = t.literal("Activity")
}, { __index = t._unwrap_struct(mod.activitystreams_any_object_schema) }))

--[[@class activitystreams_intransitive_activity: activitystreams_activity]]
--[[@field object? nil]]
mod.activitystreams_activity_schema = t.struct(setmetatable({
  object = mod.type_cache.nil_opt,
}, { __index = t._unwrap_struct(mod.activitystreams_activity_schema) }))

--[[@class activitystreams_collection: activitystreams_object]]
--[[@field type "Collection"]]
--[[@field totalItems integer]]
--[[@field items activitystreams_object[] ]]
--[[@field first? activitystreams_object]]
--[[@field last? activitystreams_object]]
--[[@field current? activitystreams_object]]

--[[it says properties are inherited from `Collection` but it looks like items are renamed to orderedItems]]
--[[@class activitystreams_ordered_collection: activitystreams_object]]
--[[@field type "OrderedCollection"]]
--[[@field totalItems integer]]
--[[@field orderedItems activitystreams_object[] ]]
--[[@field first? activitystreams_object]]
--[[@field last? activitystreams_object]]
--[[@field current? activitystreams_object]]

local test = [[{
  "@context": "https://www.w3.org/ns/activitystreams",
  "summary": "Sally's notes",
  "type": "Collection",
  "totalItems": 2,
  "items": [
    {
      "type": "Note",
      "name": "A Simple Note"
    },
    {
      "type": "Note",
      "name": "Another Simple Note"
    }
  ]
}]]

return mod

local mod = {}

--[[@alias htaccess_rule_type string|"Header"]]

--[[@class htaccess_base_rule]]
--[[@field type string]]

--[[@alias htaccess_header_condition_type "onsuccess"|"always"]]
--[[@alias htaccess_header_action_type "add"|"append"|"echo"|"edit"|"edit*"|"merge"|"set"|"setifempty"|"unset"|"note"]]

--[[@class htaccess_header_rule: htaccess_base_rule]]
--[[@field type "Header"]]
--[[@field condition htaccess_header_condition_type]]
--[[@field action htaccess_header_action_type]]
--[[@field header string]]
--[[@field value string]]

--[[@alias htaccess_rule htaccess_base_rule|htaccess_header_rule]]

local header_rule_appliers = {} --[[@type table<htaccess_header_action_type, fun(rule: htaccess_header_rule, values: string[])>]]
header_rule_appliers.add = function (rule, values) values[#values+1] = rule.value end

local rule_appliers = {} --[[@type table<htaccess_rule_type, fun(rule: htaccess_rule, res: http_response)>]]
mod.rule_appliers = rule_appliers
rule_appliers.Header = function (rule, res) --[[@param rule htaccess_header_rule]]
  local header = rule.header
  local values = res.headers[header]
  if not values then values = {}; res.headers[header] = values
  elseif type(values) == "string" then values = { values }; res.headers[header] = values end
  header_rule_appliers[rule.action](rule, values)
end

mod.apply_rule = function ()
end

return mod

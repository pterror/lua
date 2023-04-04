-- IMPL
--[[https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#clientCapabilities]]

local lunajson = require("dep.lunajson")

local mod = {}

--[[@enum lsp_message_type]]
mod.message_type = { error = 1, warning = 2, info = 3, log = 4 }
--[[bitflags]]
--[[@enum lsp_watch_kind]]
mod.watch_kind = { create = 1, change = 2, delete = 4 }
--[[@enum lsp_file_operation_pattern_kind]]
mod.file_operation_pattern_kind = { file = "file", folder = "folder" }
--[[@enum lsp_symbol_kind]]
mod.symbol_kind = {
  file = 1, module = 2, namespace = 3, package = 4, class = 5, method = 6, property = 7, field = 8, constructor = 9,
  enum = 10, interface = 11, ["function"] = 12, variable = 13, constant = 14, string = 15, number = 16, boolean = 17,
  array = 18, object = 19, key = 20, null = 21, enum_member = 22, struct = 23, event = 24, operator = 25, type_parameter = 26,
}
--[[@deprecated]]
--[[@enum lsp_symbol_tag]]
mod.symbol_tag = { deprecated = 1 }
--[[@enum lsp_uniqueness_level]]
mod.uniqueness_level = { document = "document", project = "project", group = "group", scheme = "scheme", global = "global" }
--[[@enum lsp_moniker_kind]]
mod.moniker_kind = { import = "import", export = "export", local_ = "local" }
--[[@enum lsp_signature_help_trigger_kind]]
mod.signature_help_trigger_kind = { invoked = 1, trigger_character = 2, content_change = 3 }
--[[@enum lsp_markup_kind]]
mod.markup_kind = { plain_text = "plaintext", markdown = "markdown" }
--[[@enum lsp_document_highlight_kind]]
mod.document_highlight_kind = { text = 1, read = 2, write = 3 }
--[[@enum lsp_text_document_sync_kind]]
mod.text_document_sync_kind = { none = 0, full = 1, incremental = 2 }
-- open
--[[@enum lsp_folding_range_kind]]
mod.folding_range_kind = { comment = "comment", imports = "imports", region = "region" }
--[[@enum lsp_completion_item_kind]]
mod.completion_item_kind = {
  text = 1, method = 2, ["function"] = 3, constructor = 4, field = 5, variable = 6, class = 7, interface = 8, module = 9,
  property = 10, unit = 11, value = 12, enum = 13, keyword = 14, snippet = 15, color = 16, file = 17, reference = 18,
  folder = 19, enum_member = 20, constant = 21, struct = 22, event = 23, operator = 24, type_parameter = 25, 
}
--[[@deprecated]]
--[[@enum lsp_completion_item_tag]]
mod.completion_item_tag = { deprecated = 1 }
--[[@enum lsp_insert_text_format]]
mod.insert_text_format = { plain_text = 1, snippet = 2 }
--[[@enum lsp_insert_text_mode]]
mod.insert_text_mode = { as_is = 1, adjust_indentation = 2 }
--[[@enum lsp_semantic_token_types]]
mod.semantic_token_types = {
  namespace = "namespace", type = "type", class = "class", enum = "enum", interface = "interface", struct = "struct",
  type_parameter = "type_parameter", parameter = "parameter", variable = "variable", property = "property",
  enum_member = "enum_member", event = "event", function_ = "function", method = "method", macro = "macro", keyword = "keyword",
  modifier = "modifier", comment = "comment", string = "string", number = "number", regexp = "regexp", operator = "operator",
  decorator = "decorator",
}
--[[@enum lsp_semantic_token_modifiers]]
mod.semantic_token_modifiers = {
  declaration = "declaration", definition = "definition", readonly = "readonly", static = "static", deprecated = "deprecated",
  abstract = "abstract", async = "async", modification = "modification", documentation = "documentation", default_library = "default_library",
}
--[[@enum lsp_token_format]]
mod.token_format = { relative = "relative" }
--[[@enum lsp_inlay_hint_kind]]
mod.inlay_hint_kind = { type = 1, parameter = 2 }
--[[@enum lsp_diagnostic_severity]]
mod.diagnostic_severity = { error = 1, warning = 2, information = 3, hint = 4 }
--[[@enum lsp_diagnostic_tag]]
mod.diagnostic_tag = { unnecessary = 1, deprecated = 2 }
--[[@enum lsp_resource_operation_kind]]
mod.resource_operation_kind = { create = "create", rename = "rename", delete = "delete" }
--[[@enum lsp_failure_handling_kind]]
mod.failure_handling_kind = { abort = "abort", transactional = "transactional", text_only_transactional = "text_only_transactional", undo = "undo" }
-- open
--[[@enum lsp_code_action_kind]]
mod.code_action_kind = {
  empty = "", quick_fix = "quickfix", refactor = "refactor", refactor_extract = "refactor.extract", refactor_inline = "refactor.inline",
  refactor_rewrite = "refactor.rewrite", source = "source", source_organize_imports = "source.organize_imports", source_fix_all = "source.fix_all",
}
--[[@enum lsp_code_action_trigger_kind]]
mod.code_action_trigger_kind = { invoked = 1, automatic = 2 }
-- not an enum in the spec
--[[@enum lsp_trace_value]]
mod.trace_value = { off = "off", messages = "messages", verbose = "verbose" }
--[[@enum lsp_prepare_support_default_behavior]]
mod.prepare_support_default_behavior = { identifier = 1 }
--[[@enum lsp_completion_trigger_kind]]
mod.completion_trigger_kind = { invoked = 1, trigger_character = 2, trigger_for_incomplete_completions = 3 }
--[[@enum lsp_text_document_save_reason]]
mod.text_document_save_reason = { manual = 1, after_delay = 2, focus_out = 3 }
--[[@enum lsp_notebook_cell_kind]]
mod.notebook_cell_kind = { markup = 1, code = 2 }
--[[@enum lsp_position_encoding_kind]]
mod.position_encoding_kind = { utf8 = "utf-8", utf16 = "utf-16", utf32 = "utf-32" }

--[[@param s string]]
mod.string_to_lsp_message = function (s)
	--[[@type string, string]]
	local headers, body = s:match("(.*\r\n)\r\n(.*)")
	for a, b in headers:gmatch("(.-): (.*)") do
		--
	end
end

--[[@param msg lsp_message]]
mod.lsp_message_to_string = function (msg)
	local json = lunajson.value_to_json(msg)
	return "Content-Length: " .. (#json) .. "\r\nContent-Type: application/vscode-jsonrpc; charset=utf-8\r\n\r\n" .. json
end

return mod

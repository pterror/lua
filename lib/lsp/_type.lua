-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#client_capabilities
-- console.log([...document.query_selector_all("pre")].filter(e => /^(?:\/\*[\s\s]+?\*\/\n)?export interface /.test(e.inner_text)).map(e => e.inner_text).join("\n\n"))

local mod = {}

-- ^\};?\n
-- <empty>
-- string /\*\*? (.+?) \*/
-- $1
-- \n\s*/\*(.|\n)+?\*/
-- <empty>
-- (?:export )?interface (\w+)\s+extends\s+(.+?)\n?(.+?)?\n?(.+?)? \{
-- \n--[[@class lsp_$1: lsp_$2$3$4]]
-- (?:export )?interface (.+?)\n?(.+?)?\n?(.+?)? \{
-- \n--[[@class lsp_$1$2$3]]
-- ^\t(\w+)\?: (.+);$
-- --[[@field $1 $2?]]
-- ^\t(\w+): (.+);$
-- --[[@field $1 $2]]
-- \n\n\n
-- \n\n

-- base types
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#base_types
--[[@alias lsp_uinteger integer]]
--[[@alias lsp_decimal number]]
--[[@alias lsp_any {} | unknown[] | string | integer | lsp_uinteger | lsp_decimal | boolean | nil]]
--[[@alias lsp_object { [string]: lsp_any }]]
--[[@alias lsp_array lsp_any[] ]]

-- types (not classes) defined in spec
--[[@alias lsp_document_uri string]]
--[[@alias lsp_uri string]]
--[[@alias lsp_progress_token integer | string]]
--[[@alias lsp_pattern string]]
--[[@alias lsp_glob_pattern lsp_pattern | lsp_relative_pattern]]
--[[@alias lsp_change_annotation_identifier string]]
--[[@alias lsp_workspace_document_diagnostic_report lsp_workspace_full_document_diagnostic_report | lsp_workspace_unchanged_document_diagnostic_report]]
--[[@alias lsp_marked_string string | { language: string; value: string }]]
--[[@alias lsp_document_selector lsp_document_filter[] ]]

--[[@class lsp_text_document_content_change_event]]
--[[@field range lsp_range? if ommitted, `text` is the entire new document]]
--[[@field rangeLength? lsp_uinteger]]
--[[@field text string]]

-- fix manually:
-- remove first `hover_params` and `hover_result`
-- workspace_edit.document_changes
-- workspace_edit.change_annotations
-- workspace_edit_client_capabilities.change_annotation_support
-- initialize_params.client_info
-- ???
-- related_full_document_diagnostic_report.related_documents
-- related_unchanged_document_diagnostic_report.related_documents
-- document_diagnostic_report_partial_result.related_documents
-- ???
-- show_message_request_client_capabilities.message_action_item

--[[@class lsp_message]]
--[[@field jsonrpc string]]

--[[@class lsp_request_message: lsp_message]]
--[[@field id integer | string]]
--[[@field method string]]
--[[@field params? unknown[] | {}]]

--[[@class lsp_response_message: lsp_message]]
--[[@field id integer | string | nil]]
--[[@field result? string | number | boolean | {} | nil]]
--[[@field error? lsp_response_error]]

--[[@class lsp_response_error]]
--[[@field code integer]]
--[[@field message string]]
--[[@field data? string | number | boolean | unknown[] | {} | nil]]

--[[@class lsp_notification_message: lsp_message]]
--[[@field method string]]
--[[@field params? unknown[] | {}]]

--[[@class lsp_cancel_params]]
--[[@field id integer | string]]

--[[@class lsp_progress_params<t>: { value: t }]]
--[[@field token lsp_progress_token]]

--[[@class lsp_regular_expressions_client_capabilities]]
--[[@field engine string]]
--[[@field version? string]]

--[[@class lsp_position]]
--[[@field line lsp_uinteger]]
--[[@field character lsp_uinteger]]

--[[@class lsp_range]]
--[[@field start lsp_position]]
--[[@field end lsp_position]]

--[[@class lsp_text_document_item]]
--[[@field uri lsp_document_uri]]
--[[@field languageId string]]
--[[@field version integer]]
--[[@field text string]]

--[[@class lsp_text_document_identifier]]
--[[@field uri lsp_document_uri]]

--[[@class lsp_versioned_text_document_identifier: lsp_text_document_identifier]]
--[[@field version integer]]

--[[@class lsp_optional_versioned_text_document_identifier: lsp_text_document_identifier]]
--[[@field version integer | nil]]

--[[@class lsp_text_document_position_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field position lsp_position]]

--[[@class lsp_document_filter]]
--[[@field language? string]]
--[[@field scheme? string]]
--[[@field pattern? string]]

--[[@class lsp_text_edit]]
--[[@field range lsp_range]]
--[[@field newText string]]

--[[@class lsp_change_annotation]]
--[[@field label string]]
--[[@field needsConfirmation? boolean]]
--[[@field description? string]]

--[[@class lsp_annotated_text_edit: lsp_text_edit]]
--[[@field annotationId lsp_change_annotation_identifier]]

--[[@class lsp_text_document_edit]]
--[[@field textDocument lsp_optional_versioned_text_document_identifier]]
--[[@field edits (lsp_text_edit | lsp_annotated_text_edit)[] ]]

--[[@class lsp_location]]
--[[@field uri lsp_document_uri]]
--[[@field range lsp_range]]

--[[@class lsp_location_link]]
--[[@field originSelectionRange? lsp_range]]
--[[@field targetUri lsp_document_uri]]
--[[@field targetRange lsp_range]]
--[[@field targetSelectionRange lsp_range]]

--[[@class lsp_diagnostic]]
--[[@field range lsp_range]]
--[[@field severity? lsp_diagnostic_severity]]
--[[@field code? integer | string]]
--[[@field codeDescription? lsp_code_description]]
--[[@field source? string]]
--[[@field message string]]
--[[@field tags? lsp_diagnostic_tag[] ]]
--[[@field relatedInformation? lsp_diagnostic_related_information[] ]]
--[[@field data? unknown]]

--[[@class lsp_diagnostic_related_information]]
--[[@field location lsp_location]]
--[[@field message string]]

--[[@class lsp_code_description]]
--[[@field href lsp_uri]]

--[[@class lsp_command]]
--[[@field title string]]
--[[@field command string]]
--[[@field arguments? lsp_any[] ]]

--[[@class lsp_markup_content]]
--[[@field kind lsp_markup_kind]]
--[[@field value string]]

--[[@class lsp_markdown_client_capabilities]]
--[[@field parser string]]
--[[@field version? string]]
--[[@field allowedTags? string[] ]]

--[[@class lsp_create_file_options]]
--[[@field overwrite? boolean]]
--[[@field ignoreIfExists? boolean]]

--[[@class lsp_create_file]]
--[[@field kind "create"]]
--[[@field uri lsp_document_uri]]
--[[@field options? lsp_create_file_options]]
--[[@field annotationId? lsp_change_annotation_identifier]]

--[[@class lsp_rename_file_options]]
--[[@field overwrite? boolean]]
--[[@field ignoreIfExists? boolean]]

--[[@class lsp_rename_file]]
--[[@field kind "rename"]]
--[[@field oldUri lsp_document_uri]]
--[[@field newUri lsp_document_uri]]
--[[@field options? lsp_rename_file_options]]
--[[@field annotationId? lsp_change_annotation_identifier]]

--[[@class lsp_delete_file_options]]
--[[@field recursive? boolean]]
--[[@field ignoreIfNotExists? boolean]]

--[[@class lsp_delete_file]]
--[[@field kind "delete"]]
--[[@field uri lsp_document_uri]]
--[[@field options? lsp_delete_file_options]]
--[[@field annotationId? lsp_change_annotation_identifier]]

--[[@class lsp_workspace_edit_change_annotations: { [lsp_change_annotation_identifier]: lsp_change_annotation }]]

--[[@class lsp_workspace_edit]]
--[[@field changes? { [lsp_document_uri]: lsp_text_edit[]; }]]
--[[@field documentChanges? lsp_text_document_edit[] | (lsp_text_document_edit | lsp_create_file | lsp_rename_file | lsp_delete_file)[] ]]
--[[@field changeAnnotations? lsp_workspace_edit_change_annotations]]

--[[@class lsp_workspace_edit_client_capabilities_change_annotation_support]]
--[[@field groupsOnLabel? boolean]]

--[[@class lsp_workspace_edit_client_capabilities]]
--[[@field documentChanges? boolean]]
--[[@field resourceOperations? lsp_resource_operation_kind[] ]]
--[[@field failureHandling? lsp_failure_handling_kind]]
--[[@field normalizesLineEndings? boolean]]
--[[@field changeAnnotationSupport? lsp_workspace_edit_client_capabilities_change_annotation_support]]

--[[@class lsp_work_done_progress_begin]]
--[[@field kind "begin"]]
--[[@field title string]]
--[[@field cancellable? boolean]]
--[[@field message? string]]
--[[@field percentage? lsp_uinteger]]

--[[@class lsp_work_done_progress_report]]
--[[@field kind "report"]]
--[[@field cancellable? boolean]]
--[[@field message? string]]
--[[@field percentage? lsp_uinteger]]

--[[@class lsp_work_done_progress_end]]
--[[@field kind "end"]]
--[[@field message? string]]

--[[@class lsp_work_done_progress_params]]
--[[@field workDoneToken? lsp_progress_token]]

--[[@class lsp_work_done_progress_options]]
--[[@field workDoneProgress? boolean]]

--[[@class lsp_partial_result_params]]
--[[@field partialResultToken? lsp_progress_token]]

--[[@class lsp_initialize_params_client_info]]
--[[@field name string]]
--[[@field version? string]]

--[[@class lsp_initialize_params: lsp_work_done_progress_params]]
--[[@field processId integer | nil]]
--[[@field clientInfo? lsp_initialize_params_client_info]]
--[[@field locale? string]]
--[[@field rootPath? string | nil]]
--[[@field rootUri lsp_document_uri | nil]]
--[[@field initializationOptions? lsp_any]]
--[[@field capabilities lsp_client_capabilities]]
--[[@field trace? lsp_trace_value]]
--[[@field workspaceFolders? lsp_workspace_folder[] | nil]]

--[[@class lsp_text_document_client_capabilities]]
--[[@field synchronization? lsp_text_document_sync_client_capabilities]]
--[[@field completion? lsp_completion_client_capabilities]]
--[[@field hover? lsp_hover_client_capabilities]]
--[[@field signatureHelp? lsp_signature_help_client_capabilities]]
--[[@field declaration? lsp_declaration_client_capabilities]]
--[[@field definition? lsp_definition_client_capabilities]]
--[[@field typeDefinition? lsp_type_definition_client_capabilities]]
--[[@field implementation? lsp_implementation_client_capabilities]]
--[[@field references? lsp_reference_client_capabilities]]
--[[@field documentHighlight? lsp_document_highlight_client_capabilities]]
--[[@field documentSymbol? lsp_document_symbol_client_capabilities]]
--[[@field codeAction? lsp_code_action_client_capabilities]]
--[[@field codeLens? lsp_code_lens_client_capabilities]]
--[[@field documentLink? lsp_document_link_client_capabilities]]
--[[@field colorProvider? lsp_document_color_client_capabilities]]
--[[@field formatting? lsp_document_formatting_client_capabilities]]
--[[@field rangeFormatting? lsp_document_range_formatting_client_capabilities]]
--[[@field onTypeFormatting? lsp_document_on_type_formatting_client_capabilities]]
--[[@field rename? lsp_rename_client_capabilities]]
--[[@field publishDiagnostics? lsp_publish_diagnostics_client_capabilities]]
--[[@field foldingRange? lsp_folding_range_client_capabilities]]
--[[@field selectionRange? lsp_selection_range_client_capabilities]]
--[[@field linkedEditingRange? lsp_linked_editing_range_client_capabilities]]
--[[@field callHierarchy? lsp_call_hierarchy_client_capabilities]]
--[[@field semanticTokens? lsp_semantic_tokens_client_capabilities]]
--[[@field moniker? lsp_moniker_client_capabilities]]
--[[@field typeHierarchy? lsp_type_hierarchy_client_capabilities]]
--[[@field inlineValue? lsp_inline_value_client_capabilities]]
--[[@field inlayHint? lsp_inlay_hint_client_capabilities]]
--[[@field diagnostic? lsp_diagnostic_client_capabilities]]

--[[@class lsp_notebook_document_client_capabilities]]
--[[@field synchronization lsp_notebook_document_sync_client_capabilities]]

--[[@class lsp_client_capabilities_workspace_file_operations]]
--[[@field dynamicRegistration? boolean]]
--[[@field didCreate? boolean]]
--[[@field willCreate? boolean]]
--[[@field didRename? boolean]]
--[[@field willRename? boolean]]
--[[@field didDelete? boolean]]
--[[@field willDelete? boolean]]

--[[@class lsp_client_capabilities_workspace]]
--[[@field applyEdit? boolean]]
--[[@field workspaceEdit? lsp_workspace_edit_client_capabilities]]
--[[@field didChangeConfiguration? lsp_did_change_configuration_client_capabilities]]
--[[@field didChangeWatchedFiles? lsp_did_change_watched_files_client_capabilities]]
--[[@field symbol? lsp_workspace_symbol_client_capabilities]]
--[[@field executeCommand? lsp_execute_command_client_capabilities]]
--[[@field workspaceFolders? boolean]]
--[[@field configuration? boolean]]
--[[@field semanticTokens? lsp_semantic_tokens_workspace_client_capabilities]]
--[[@field codeLens? lsp_code_lens_workspace_client_capabilities]]
--[[@field fileOperations? lsp_client_capabilities_workspace_file_operations]]
--[[@field inlineValue? lsp_inline_value_workspace_client_capabilities]]
--[[@field inlayHint? lsp_inlay_hint_workspace_client_capabilities]]
--[[@field diagnostics? lsp_diagnostic_workspace_client_capabilities]]

--[[@class lsp_client_capabilities_window]]
--[[@field workDoneProgress? boolean]]
--[[@field showMessage? lsp_show_message_request_client_capabilities]]
--[[@field showDocument? lsp_show_document_client_capabilities]]

--[[@class lsp_client_capabilities_general_stale_request_support]]
--[[@field cancel boolean]]
--[[@field retryOnContentModified string[] ]]

--[[@class lsp_client_capabilities_general]]
--[[@field staleRequestSupport? lsp_client_capabilities_general_stale_request_support]]
--[[@field regularExpressions? lsp_regular_expressions_client_capabilities]]
--[[@field markdown? lsp_markdown_client_capabilities]]
--[[@field positionEncodings? lsp_position_encoding_kind[] ]]

--[[@class lsp_client_capabilities]]
--[[@field textDocument? lsp_text_document_client_capabilities]]
--[[@field notebookDocument? lsp_notebook_document_client_capabilities]]
--[[@field workspace? lsp_client_capabilities_workspace]]
--[[@field window? lsp_client_capabilities_window]]
--[[@field general? lsp_client_capabilities_general]]
--[[@field experimental? lsp_any]]

--[[@class lsp_initialize_result_server_info]]
--[[@field name string]]
--[[@field version? string]]

--[[@class lsp_initialize_result]]
--[[@field capabilities lsp_server_capabilities]]
--[[@field serverInfo? lsp_initialize_result_server_info]]

--[[@class lsp_initialize_error]]
--[[@field retry boolean]]

--[[@class lsp_server_capabilities_workspace_file_operations]]
--[[@field didCreate? lsp_file_operation_registration_options]]
--[[@field willCreate? lsp_file_operation_registration_options]]
--[[@field didRename? lsp_file_operation_registration_options]]
--[[@field willRename? lsp_file_operation_registration_options]]
--[[@field didDelete? lsp_file_operation_registration_options]]
--[[@field willDelete? lsp_file_operation_registration_options]]

--[[@class lsp_server_capabilities_workspace]]
--[[@field workspaceFolders? lsp_workspace_folders_server_capabilities]]
--[[@field fileOperations? lsp_server_capabilities_workspace_file_operations]]

--[[@class lsp_server_capabilities]]
--[[@field positionEncoding? lsp_position_encoding_kind]]
--[[@field textDocumentSync? lsp_text_document_sync_options | lsp_text_document_sync_kind]]
--[[@field notebookDocumentSync? lsp_notebook_document_sync_options | lsp_notebook_document_sync_registration_options]]
--[[@field completionProvider? lsp_completion_options]]
--[[@field hoverProvider? boolean | lsp_hover_options]]
--[[@field signatureHelpProvider? lsp_signature_help_options]]
--[[@field declarationProvider? boolean | lsp_declaration_options | lsp_declaration_registration_options]]
--[[@field definitionProvider? boolean | lsp_definition_options]]
--[[@field typeDefinitionProvider? boolean | lsp_type_definition_options | lsp_type_definition_registration_options]]
--[[@field implementationProvider? boolean | lsp_implementation_options | lsp_implementation_registration_options]]
--[[@field referencesProvider? boolean | lsp_reference_options]]
--[[@field documentHighlightProvider? boolean | lsp_document_highlight_options]]
--[[@field documentSymbolProvider? boolean | lsp_document_symbol_options]]
--[[@field codeActionProvider? boolean | lsp_code_action_options]]
--[[@field codeLensProvider? lsp_code_lens_options]]
--[[@field documentLinkProvider? lsp_document_link_options]]
--[[@field colorProvider? boolean | lsp_document_color_options | lsp_document_color_registration_options]]
--[[@field documentForServerCapabilitiesypeFormattingProvider? lsp_document_on_type_formatting_options]]
--[[@field renameProvider? boolean | lsp_rename_options]]
--[[@field foldingRangeProvider? boolean | lsp_folding_range_options | lsp_folding_range_registration_options]]
--[[@field executeCommandProvider? lsp_execute_command_options]]
--[[@field selectionRangeProvider? boolean | lsp_selection_range_options | lsp_selection_range_registration_options]]
--[[@field linkedEditingRangeProvider? boolean | lsp_linked_editing_range_options | lsp_linked_editing_range_registration_options]]
--[[@field callHierarchyProvider? boolean | lsp_call_hierarchy_options | lsp_call_hierarchy_registration_options]]
--[[@field semanticTokensProvider? lsp_semantic_tokens_options | lsp_semantic_tokens_registration_options]]
--[[@field monikerProvider? boolean | lsp_moniker_options | lsp_moniker_registration_options]]
--[[@field typeHierarchyProvider? boolean | lsp_type_hierarchy_options | lsp_type_hierarchy_registration_options]]
--[[@field inlineValueProvider? boolean | lsp_inline_value_options | lsp_inline_value_registration_options]]
--[[@field inlayHintProvider? boolean | lsp_inlay_hint_options | lsp_inlay_hint_registration_options]]
--[[@field diagnosticProvider? lsp_diagnostic_options | lsp_diagnostic_registration_options]]
--[[@field workspaceSymbolProvider? boolean | lsp_workspace_symbol_options]]
--[[@field workspace? lsp_server_capabilities_workspace]]
--[[@field experimental? lsp_any]]

--[[@class lsp_initialized_params]]

--[[@class lsp_registration]]
--[[@field id string]]
--[[@field method string]]
--[[@field registerOptions? lsp_any]]

--[[@class lsp_registration_params]]
--[[@field registrations lsp_registration[] ]]

--[[@class lsp_static_registration_options]]
--[[@field id? string]]

--[[@class lsp_text_document_registration_options]]
--[[@field documentSelector lsp_document_selector | nil]]

--[[@class lsp_unregistration]]
--[[@field id string]]
--[[@field method string]]

--[[@class lsp_unregistration_params]]
--[[@field unregisterations lsp_unregistration[] misspelt, but breaking change so will be fixed in 4.0]]

--[[@class lsp_set_trace_params]]
--[[@field value lsp_trace_value]]

--[[@class lsp_log_trace_params]]
--[[@field message string]]
--[[@field verbose? string]]

--[[@class lsp_did_open_text_document_params]]
--[[@field textDocument lsp_text_document_item]]

--[[@class lsp_text_document_change_registration_options: lsp_text_document_registration_options]]
--[[@field syncKind lsp_text_document_sync_kind]]

--[[@class lsp_did_change_text_document_params]]
--[[@field textDocument lsp_versioned_text_document_identifier]]
--[[@field contentChanges lsp_text_document_content_change_event[] ]]

--[[@class lsp_will_save_text_document_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field reason lsp_text_document_save_reason]]

--[[@class lsp_save_options]]
--[[@field includeText? boolean]]

--[[@class lsp_text_document_save_registration_options: lsp_text_document_registration_options]]
--[[@field includeText? boolean]]

--[[@class lsp_did_save_text_document_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field text? string]]

--[[@class lsp_did_close_text_document_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_text_document_sync_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field willSave? boolean]]
--[[@field willSaveWaitUntil? boolean]]
--[[@field didSave? boolean]]

--[[@class lsp_text_document_sync_options]]
--[[@field openClose? boolean]]
--[[@field change? lsp_text_document_sync_kind]]
--[[@field willSave? boolean]]
--[[@field willSaveWaitUntil? boolean]]
--[[@field save? boolean | lsp_save_options]]

--[[@class lsp_notebook_document]]
--[[@field uri lsp_uri]]
--[[@field notebookType string]]
--[[@field version integer]]
--[[@field metadata? lsp_object]]
--[[@field cells lsp_notebook_cell[] ]]

--[[@class lsp_notebook_cell]]
--[[@field kind lsp_notebook_cell_kind]]
--[[@field document lsp_document_uri]]
--[[@field metadata? lsp_object]]
--[[@field executionSummary? lsp_execution_summary]]

--[[@class lsp_execution_summary]]
--[[@field executionOrder lsp_uinteger]]
--[[@field success? boolean]]

--[[@class lsp_notebook_cell_text_document_filter]]
--[[@field notebook string | lsp_notebook_document_filter]]
--[[@field language? string]]

--[[@class lsp_notebook_document_filter at least one property must be present]]
--[[@field notebookType? string]]
--[[@field scheme? string]]
--[[@field pattern string]]

--[[@class lsp_notebook_document_sync_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field executionSummarySupport? boolean]]

--[[@class lsp_notebook_selector_with_notebook]]
--[[@field notebook string | lsp_notebook_document_filter]]
--[[@field cells? { language: string }[] ]]

--[[@class lsp_notebook_selector_with_cells]]
--[[@field notebook? string | lsp_notebook_document_filter]]
--[[@field cells { language: string }[] ]]

--[[@class lsp_notebook_document_sync_options]]
--[[@field notebookSelector (lsp_notebook_selector_with_notebook | lsp_notebook_selector_with_cells)[] ]]
--[[@field save? boolean]]

--[[@class lsp_notebook_document_sync_registration_options notebook_document_sync_options, static_registration_options]]

--[[@class lsp_did_open_notebook_document_params]]
--[[@field notebookDocument lsp_notebook_document]]
--[[@field cellTextDocuments lsp_text_document_item[] ]]

--[[@class lsp_did_change_notebook_document_params]]
--[[@field notebookDocument lsp_versioned_notebook_document_identifier]]
--[[@field change lsp_notebook_document_change_event]]

--[[@class lsp_versioned_notebook_document_identifier]]
--[[@field version integer]]
--[[@field uri lsp_uri]]

--[[@class lsp_notebook_document_change_event_cells_structure]]
--[[@field array lsp_notebook_cell_array_change]]
--[[@field didOpen? lsp_text_document_item[] ]]
--[[@field didClose? lsp_text_document_identifier[] ]]

--[[@class lsp_notebook_document_change_event_cells_text_content]]
--[[@field document lsp_versioned_text_document_identifier]]
--[[@field changes lsp_text_document_content_change_event[] ]]

--[[@class lsp_notebook_document_change_event_cells]]
--[[@field structure? lsp_notebook_document_change_event_cells_structure]]
--[[@field data? lsp_notebook_cell[] ]]
--[[@field textContent? lsp_notebook_document_change_event_cells_text_content]]

--[[@class lsp_notebook_document_change_event]]
--[[@field metadata? lsp_object]]
--[[@field cells? lsp_notebook_document_change_event_cells]]

--[[@class lsp_notebook_cell_array_change]]
--[[@field start lsp_uinteger]]
--[[@field deleteCount lsp_uinteger]]
--[[@field cells? lsp_notebook_cell[] ]]

--[[@class lsp_did_save_notebook_document_params]]
--[[@field notebookDocument lsp_notebook_document_identifier]]

--[[@class lsp_did_close_notebook_document_params]]
--[[@field notebookDocument lsp_notebook_document_identifier]]
--[[@field cellTextDocuments lsp_text_document_identifier[] ]]

--[[@class lsp_notebook_document_identifier]]
--[[@field uri lsp_uri]]

--[[@class lsp_declaration_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field linkSupport? boolean]]

--[[@class lsp_declaration_options: lsp_work_done_progress_options]]

--[[@class lsp_declaration_registration_options: lsp_declaration_options, lsp_text_document_registration_options, lsp_static_registration_options]]

--[[@class lsp_declaration_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_definition_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field linkSupport? boolean]]

--[[@class lsp_definition_options: lsp_work_done_progress_options]]

--[[@class lsp_definition_registration_options: lsp_text_document_registration_options, lsp_definition_options]]

--[[@class lsp_definition_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_type_definition_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field linkSupport? boolean]]

--[[@class lsp_type_definition_options: lsp_work_done_progress_options]]

--[[@class lsp_type_definition_registration_options: lsp_text_document_registration_options, lsp_type_definition_options, lsp_static_registration_options]]

--[[@class lsp_type_definition_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_implementation_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field linkSupport? boolean]]

--[[@class lsp_implementation_options: lsp_work_done_progress_options]]

--[[@class lsp_implementation_registration_options: lsp_text_document_registration_options, lsp_implementation_options, lsp_static_registration_options]]

--[[@class lsp_implementation_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_reference_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_reference_options: lsp_work_done_progress_options]]

--[[@class lsp_reference_registration_options: lsp_text_document_registration_options, lsp_reference_options]]

--[[@class lsp_reference_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field context lsp_reference_context]]

--[[@class lsp_reference_context]]
--[[@field includeDeclaration boolean]]

--[[@class lsp_call_hierarchy_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_call_hierarchy_options: lsp_work_done_progress_options]]

--[[@class lsp_call_hierarchy_registration_options: lsp_text_document_registration_options, lsp_call_hierarchy_options, lsp_static_registration_options]]

--[[@class lsp_call_hierarchy_prepare_params: lsp_text_document_position_params, lsp_work_done_progress_params]]

--[[@class lsp_call_hierarchy_item]]
--[[@field name string]]
--[[@field kind lsp_symbol_kind]]
--[[@field tags? lsp_symbol_tag[] ]]
--[[@field detail? string]]
--[[@field uri lsp_document_uri]]
--[[@field range lsp_range]]
--[[@field selectionRange lsp_range]]
--[[@field data? unknown]]

--[[@class lsp_call_hierarchy_incoming_calls_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field item lsp_call_hierarchy_item]]

--[[@class lsp_call_hierarchy_incoming_call]]
--[[@field from lsp_call_hierarchy_item]]
--[[@field fromRanges lsp_range[] ]]

--[[@class lsp_call_hierarchy_outgoing_calls_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field item lsp_call_hierarchy_item]]

--[[@class lsp_call_hierarchy_outgoing_call]]
--[[@field to lsp_call_hierarchy_item]]
--[[@field fromRanges lsp_range[] ]]

--[[@class lsp_type_hierarchy_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_type_hierarchy_options: lsp_work_done_progress_options]]

--[[@class lsp_type_hierarchy_registration_options: lsp_text_document_registration_options, lsp_type_hierarchy_options, lsp_static_registration_options]]

--[[@class lsp_type_hierarchy_prepare_params: lsp_text_document_position_params, lsp_work_done_progress_params]]

--[[@class lsp_type_hierarchy_item]]
--[[@field name string]]
--[[@field kind lsp_symbol_kind]]
--[[@field tags? lsp_symbol_tag[] ]]
--[[@field detail? string]]
--[[@field uri lsp_document_uri]]
--[[@field range lsp_range]]
--[[@field selectionRange lsp_range]]
--[[@field data? lsp_any]]

--[[@class lsp_type_hierarchy_supertypes_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field item lsp_type_hierarchy_item]]

--[[@class lsp_type_hierarchy_subtypes_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field item lsp_type_hierarchy_item]]

--[[@class lsp_document_highlight_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_document_highlight_options: lsp_work_done_progress_options]]

--[[@class lsp_document_highlight_registration_options: lsp_text_document_registration_options, lsp_document_highlight_options]]

--[[@class lsp_document_highlight_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_document_highlight]]
--[[@field range lsp_range]]
--[[@field kind? lsp_document_highlight_kind]]

--[[@class lsp_document_link_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field tooltipSupport? boolean]]

--[[@class lsp_document_link_options: lsp_work_done_progress_options]]
--[[@field resolveProvider? boolean]]

--[[@class lsp_document_link_registration_options: lsp_text_document_registration_options, lsp_document_link_options]]

--[[@class lsp_document_link_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_document_link]]
--[[@field range lsp_range]]
--[[@field target? lsp_document_uri]]
--[[@field tooltip? string]]
--[[@field data? lsp_any]]

--[[@class lsp_hover_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field contentFormat? lsp_markup_kind[] ]]

--[[@class lsp_hover_options: lsp_work_done_progress_options]]

--[[@class lsp_hover_registration_options: lsp_text_document_registration_options, lsp_hover_options]]

--[[@class lsp_hover_params: lsp_text_document_position_params, lsp_work_done_progress_params]]

--[[@class lsp_hover]]
--[[@field contents lsp_marked_string | lsp_marked_string[] | lsp_markup_content]]
--[[@field range? lsp_range]]

--[[@class lsp_code_lens_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_code_lens_options: lsp_work_done_progress_options]]
--[[@field resolveProvider? boolean]]

--[[@class lsp_code_lens_registration_options: lsp_text_document_registration_options, lsp_code_lens_options]]

--[[@class lsp_code_lens_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_code_lens]]
--[[@field range lsp_range]]
--[[@field command? lsp_command]]
--[[@field data? lsp_any]]

--[[@class lsp_code_lens_workspace_client_capabilities]]
--[[@field refreshSupport? boolean]]

--[[@class lsp_folding_range_client_capabilities_folding_range_kind]]
--[[@field valueSet? lsp_folding_range_kind[] ]]

--[[@class lsp_folding_range_client_capabilities_folding_range]]
--[[@field collapsedText? boolean]]

--[[@class lsp_folding_range_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field rangeLimit? lsp_uinteger]]
--[[@field lineFoldingOnly? boolean]]
--[[@field foldingRangeKind? lsp_folding_range_client_capabilities_folding_range_kind]]
--[[@field foldingRange? lsp_folding_range_client_capabilities_folding_range]]

--[[@class lsp_folding_range_options: lsp_work_done_progress_options]]

--[[@class lsp_folding_range_registration_options: lsp_text_document_registration_options, lsp_folding_range_options, lsp_static_registration_options]]

--[[@class lsp_folding_range_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_folding_range]]
--[[@field startLine lsp_uinteger]]
--[[@field startCharacter? lsp_uinteger]]
--[[@field endLine lsp_uinteger]]
--[[@field endCharacter? lsp_uinteger]]
--[[@field kind? lsp_folding_range_kind]]
--[[@field collapsedText? string]]

--[[@class lsp_selection_range_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_selection_range_options: lsp_work_done_progress_options]]

--[[@class lsp_selection_range_registration_options: lsp_selection_range_options, lsp_text_document_registration_options, lsp_static_registration_options]]

--[[@class lsp_selection_range_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field positions lsp_position[] ]]

--[[@class lsp_selection_range]]
--[[@field range lsp_range]]
--[[@field parent? lsp_selection_range]]

--[[@class lsp_document_symbol_client_capabilities_symbol_kind]]
--[[@field valueSet? lsp_symbol_kind[] ]]

--[[@class lsp_document_symbol_client_capabilities_tag_support]]
--[[@field valueSet lsp_symbol_tag[] ]]

--[[@class lsp_document_symbol_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field symbolKind? lsp_document_symbol_client_capabilities_symbol_kind]]
--[[@field hierarchicalDocumentSymbolSupport? boolean]]
--[[@field tagSupport? lsp_document_symbol_client_capabilities_tag_support]]
--[[@field labelSupport? boolean]]

--[[@class lsp_document_symbol_options: lsp_work_done_progress_options]]
--[[@field label? string]]

--[[@class lsp_document_symbol_registration_options: lsp_text_document_registration_options, lsp_document_symbol_options]]

--[[@class lsp_document_symbol_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_document_symbol]]
--[[@field name string]]
--[[@field detail? string]]
--[[@field kind lsp_symbol_kind]]
--[[@field tags? lsp_symbol_tag[] ]]
--[[@field deprecated? boolean]]
--[[@field range lsp_range]]
--[[@field selectionRange lsp_range]]
--[[@field children? lsp_document_symbol[] ]]

--[[@class lsp_symbol_information]]
--[[@field name string]]
--[[@field kind lsp_symbol_kind]]
--[[@field tags? lsp_symbol_tag[] ]]
--[[@field deprecated? boolean]]
--[[@field location lsp_location]]
--[[@field containerName? string]]

--[[@class lsp_semantic_tokens_legend]]
--[[@field tokenTypes string[] ]]
--[[@field tokenModifiers string[] ]]

--[[@class lsp_semantic_tokens_client_capabilities_requests]]
--[[@field range? boolean | {}]]
--[[@field full? boolean | { delta: boolean? }]]

--[[@class lsp_semantic_tokens_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field requests lsp_semantic_tokens_client_capabilities_requests]]
--[[@field tokenTypes string[] ]]
--[[@field tokenModifiers string[] ]]
--[[@field formats lsp_token_format[] ]]
--[[@field overlappingTokenSupport? boolean]]
--[[@field multilineTokenSupport? boolean]]
--[[@field serverCancelSupport? boolean]]
--[[@field augmentsSyntaxTokens? boolean]]

--[[@class lsp_semantic_tokens_options: lsp_work_done_progress_options]]
--[[@field legend lsp_semantic_tokens_legend]]
--[[@field range? boolean | {}]]
--[[@field full? boolean | { delta: boolean? }]]

--[[@class lsp_semantic_tokens_registration_options: lsp_text_document_registration_options, lsp_semantic_tokens_options, lsp_static_registration_options]]

--[[@class lsp_semantic_tokens_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_semantic_tokens]]
--[[@field resultId? string]]
--[[@field data lsp_uinteger[] ]]

--[[@class lsp_semantic_tokens_partial_result]]
--[[@field data lsp_uinteger[] ]]

--[[@class lsp_semantic_tokens_delta_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field previousResultId string]]

--[[@class lsp_semantic_tokens_delta]]
--[[@field resultId string? (readonly)]]
--[[@field edits lsp_semantic_tokens_edit[] ]]

--[[@class lsp_semantic_tokens_edit]]
--[[@field start lsp_uinteger]]
--[[@field deleteCount lsp_uinteger]]
--[[@field data? lsp_uinteger[] ]]

--[[@class lsp_semantic_tokens_delta_partial_result]]
--[[@field edits lsp_semantic_tokens_edit[] ]]

--[[@class lsp_semantic_tokens_range_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field range lsp_range]]

--[[@class lsp_semantic_tokens_workspace_client_capabilities]]
--[[@field refreshSupport? boolean]]

--[[@class lsp_inlay_hint_client_capabilities_resolve_support]]
--[[@field properties string[] ]]

--[[@class lsp_inlay_hint_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field resolveSupport? lsp_inlay_hint_client_capabilities_resolve_support]]

--[[@class lsp_inlay_hint_options: lsp_work_done_progress_options]]
--[[@field resolveProvider? boolean]]

--[[@class lsp_inlay_hint_registration_options: lsp_inlay_hint_options, lsp_text_document_registration_options, lsp_static_registration_options]]

--[[@class lsp_inlay_hint_params: lsp_work_done_progress_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field range lsp_range]]

--[[@class lsp_inlay_hint]]
--[[@field position lsp_position]]
--[[@field label string | lsp_inlay_hint_label_part[] ]]
--[[@field kind? lsp_inlay_hint_kind]]
--[[@field textEdits? lsp_text_edit[] ]]
--[[@field tooltip? string | lsp_markup_content]]
--[[@field paddingLeft? boolean]]
--[[@field paddingRight? boolean]]
--[[@field data? lsp_any]]

--[[@class lsp_inlay_hint_label_part]]
--[[@field value string]]
--[[@field tooltip? string | lsp_markup_content]]
--[[@field location? lsp_location]]
--[[@field command? lsp_command]]

--[[@class lsp_inlay_hint_workspace_client_capabilities]]
--[[@field refreshSupport? boolean]]

--[[@class lsp_inline_value_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_inline_value_options: lsp_work_done_progress_options]]

--[[@class lsp_inline_value_registration_options: lsp_inline_value_options, lsp_text_document_registration_options, lsp_static_registration_options]]

--[[@class lsp_inline_value_params: lsp_work_done_progress_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field range lsp_range]]
--[[@field context lsp_inline_value_context]]

--[[@class lsp_inline_value_context]]
--[[@field frameId integer]]
--[[@field stoppedLocation lsp_range]]

--[[@class lsp_inline_value_text]]
--[[@field range lsp_range]]
--[[@field text string]]

--[[@class lsp_inline_value_variable_lookup]]
--[[@field range lsp_range]]
--[[@field variableName? string]]
--[[@field caseSensitiveLookup boolean]]

--[[@class lsp_inline_value_evaluatable_expression]]
--[[@field range lsp_range]]
--[[@field expression? string]]

--[[@class lsp_inline_value_workspace_client_capabilities]]
--[[@field refreshSupport? boolean]]

--[[@class lsp_moniker_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_moniker_options: lsp_work_done_progress_options]]

--[[@class lsp_moniker_registration_options: lsp_text_document_registration_options, lsp_moniker_options]]

--[[@class lsp_moniker_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]

--[[@class lsp_moniker]]
--[[@field scheme string]]
--[[@field identifier string]]
--[[@field unique lsp_uniqueness_level]]
--[[@field kind? lsp_moniker_kind]]

--[[@class lsp_completion_client_capabilities_completion_item_tag_support]]
--[[@field valueSet lsp_completion_item_tag[] ]]

--[[@class lsp_completion_client_capabilities_completion_item_resolve_support]]
--[[@field properties string[] ]]

--[[@class lsp_completion_client_capabilities_completion_item_insert_text_mode_support]]
--[[@field valueSet lsp_completion_item_tag[] ]]

--[[@class lsp_completion_client_capabilities_completion_item]]
--[[@field snippetSupport? boolean]]
--[[@field commitCharactersSupport? boolean]]
--[[@field documentationFormat? lsp_markup_kind[] ]]
--[[@field deprecatedSupport? boolean]]
--[[@field preselectSupport? boolean]]
--[[@field tagSupport? lsp_completion_client_capabilities_completion_item_tag_support]]
--[[@field insertReplaceSupport? boolean]]
--[[@field resolveSupport? lsp_completion_client_capabilities_completion_item_resolve_support]]
--[[@field insertTextModeSupport? lsp_completion_client_capabilities_completion_item_insert_text_mode_support]]
--[[@field labelDetailsSupport? boolean]]

--[[@class lsp_completion_client_capabilities_completion_item_kind]]
--[[@field valueSet? lsp_completion_item_kind[] ]]

--[[@class lsp_completion_client_capabilities_completion_list]]
--[[@field itemDefaults? string[] ]]

--[[@class lsp_completion_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field completionItem? lsp_completion_client_capabilities_completion_item]]
--[[@field completionItemKind lsp_completion_client_capabilities_completion_item_kind?  ]]
--[[@field contextSupport? boolean]]
--[[@field insertTextMode? lsp_insert_text_mode]]
--[[@field completionList? lsp_completion_client_capabilities_completion_list]]

--[[@class lsp_completion_options_completion_item]]
--[[@field labelDetailsSupport? boolean]]

--[[@class lsp_completion_options: lsp_work_done_progress_options]]
--[[@field triggerCharacters? string[] ]]
--[[@field allCommitCharacters? string[] ]]
--[[@field resolveProvider? boolean]]
--[[@field completionItem? lsp_completion_options_completion_item]]

--[[@class lsp_completion_registration_options: lsp_text_document_registration_options, lsp_completion_options]]

--[[@class lsp_completion_params: lsp_text_document_position_params, lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field context? lsp_completion_context]]

--[[@class lsp_completion_context]]
--[[@field triggerKind lsp_completion_trigger_kind]]
--[[@field triggerCharacter? string]]

--[[@class lsp_completion_list_item_defaults]]
--[[@field commitCharacters? string[] ]]
--[[@field editRange? lsp_range | { insert: lsp_range, replace: lsp_range }]]
--[[@field insertTextFormat lsp_insert_text_format]]
--[[@field insertTextMode lsp_insert_text_mode]]
--[[@field data? lsp_any]]

--[[@class lsp_completion_list]]
--[[@field isIncomplete boolean]]
--[[@field itemDefaults? lsp_completion_list_item_defaults]]
--[[@field items lsp_completion_item[] ]]

--[[@class lsp_insert_replace_edit]]
--[[@field newText string]]
--[[@field insert lsp_range]]
--[[@field replace lsp_range]]

--[[@class lsp_completion_item_label_details]]
--[[@field detail? string]]
--[[@field description? string]]

--[[@class lsp_completion_item]]
--[[@field label string]]
--[[@field labelDetails? lsp_completion_item_label_details]]
--[[@field kind? lsp_completion_item_kind]]
--[[@field tags? lsp_completion_item_tag[] ]]
--[[@field detail? string]]
--[[@field documentation? string | lsp_markup_content]]
--[[@field deprecated? boolean]]
--[[@field preselect? boolean]]
--[[@field sortText? string]]
--[[@field filterText? string]]
--[[@field insertText? string]]
--[[@field insertTextFormat? lsp_insert_text_format]]
--[[@field insertTextMode? lsp_insert_text_mode]]
--[[@field textEdit? lsp_text_edit | lsp_insert_replace_edit]]
--[[@field textEditText? string]]
--[[@field additionalTextEdits? lsp_text_edit[] ]]
--[[@field commitCharacters? string[] ]]
--[[@field command? lsp_command]]
--[[@field data? lsp_any]]

--[[@class lsp_publish_diagnostics_client_capabilities_tag_support]]
--[[@field valueSet lsp_diagnostic_tag[] ]]

--[[@class lsp_publish_diagnostics_client_capabilities]]
--[[@field relatedInformation? boolean]]
--[[@field tagSupport? lsp_publish_diagnostics_client_capabilities_tag_support]]
--[[@field versionSupport? boolean]]
--[[@field codeDescriptionSupport? boolean]]
--[[@field dataSupport? boolean]]

--[[@class lsp_publish_diagnostics_params]]
--[[@field uri lsp_document_uri]]
--[[@field version? integer]]
--[[@field diagnostics lsp_diagnostic[] ]]

--[[@class lsp_diagnostic_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field relatedDocumentSupport? boolean]]

--[[@class lsp_diagnostic_options: lsp_work_done_progress_options]]
--[[@field identifier? string]]
--[[@field interFileDependencies boolean]]
--[[@field workspaceDiagnostics boolean]]

--[[@class lsp_diagnostic_registration_options: lsp_text_document_registration_options, lsp_diagnostic_options, lsp_static_registration_options]]

--[[@class lsp_document_diagnostic_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field identifier? string]]
--[[@field previousResultId? string]]

--[[@class lsp_full_document_diagnostic_report]]
--[[@field kind "full"]]
--[[@field resultId? string]]
--[[@field items lsp_diagnostic[] ]]

--[[@class lsp_unchanged_document_diagnostic_report]]
--[[@field kind "unchanged"]]
--[[@field resultId string]]

--[[@class lsp_related_documents: { [lsp_document_uri]: lsp_full_document_diagnostic_report | lsp_unchanged_document_diagnostic_report }]]

--[[@class lsp_related_full_document_diagnostic_report: lsp_full_document_diagnostic_report]]
--[[@field relatedDocuments? lsp_related_documents]]

--[[@class lsp_related_unchanged_document_diagnostic_report: lsp_unchanged_document_diagnostic_report]]
--[[@field relatedDocuments? lsp_related_documents]]

--[[@class lsp_document_diagnostic_report_partial_result]]
--[[@field relatedDocuments lsp_related_documents]]

--[[@class lsp_diagnostic_server_cancellation_data]]
--[[@field retriggerRequest boolean]]

--[[@class lsp_workspace_diagnostic_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field identifier? string]]
--[[@field previousResultIds lsp_previous_result_id[] ]]

--[[@class lsp_previous_result_id]]
--[[@field uri lsp_document_uri]]
--[[@field value string]]

--[[@class lsp_workspace_diagnostic_report]]
--[[@field items lsp_workspace_document_diagnostic_report[] ]]

--[[@class lsp_workspace_full_document_diagnostic_report: lsp_full_document_diagnostic_report]]
--[[@field uri lsp_document_uri]]
--[[@field version integer | nil]]

--[[@class lsp_workspace_unchanged_document_diagnostic_report: lsp_unchanged_document_diagnostic_report]]
--[[@field uri lsp_document_uri]]
--[[@field version integer | nil]]

--[[@class lsp_workspace_diagnostic_report_partial_result]]
--[[@field items lsp_workspace_document_diagnostic_report[] ]]

--[[@class lsp_diagnostic_workspace_client_capabilities]]
--[[@field refreshSupport? boolean]]

--[[@class lsp_signature_help_client_capabilities_signature_information_parameter_information]]
--[[@field labelOffsetSupport? boolean]]

--[[@class lsp_signature_help_client_capabilities_signature_information]]
--[[@field documentationFormat? lsp_markup_kind[] ]]
--[[@field parameterInformation? lsp_signature_help_client_capabilities_signature_information_parameter_information]]
--[[@field activeParameterSupport? boolean]]

--[[@class lsp_signature_help_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field signatureInformation? lsp_signature_help_client_capabilities_signature_information]]
--[[@field contextSupport? boolean]]

--[[@class lsp_signature_help_options: lsp_work_done_progress_options]]
--[[@field triggerCharacters? string[] ]]
--[[@field retriggerCharacters? string[] ]]

--[[@class lsp_signature_help_registration_options: lsp_text_document_registration_options, lsp_signature_help_options]]

--[[@class lsp_signature_help_params: lsp_text_document_position_params, lsp_work_done_progress_params]]
--[[@field context? lsp_signature_help_context]]

--[[@class lsp_signature_help_context]]
--[[@field triggerKind lsp_signature_help_trigger_kind]]
--[[@field triggerCharacter? string]]
--[[@field isRetrigger boolean]]
--[[@field activeSignatureHelp? lsp_signature_help]]

--[[@class lsp_signature_help]]
--[[@field signatures lsp_signature_information[] ]]
--[[@field activeSignature? lsp_uinteger]]
--[[@field activeParameter? lsp_uinteger]]

--[[@class lsp_signature_information]]
--[[@field label string]]
--[[@field documentation? string | lsp_markup_content]]
--[[@field parameters? lsp_parameter_information[] ]]
--[[@field activeParameter? lsp_uinteger]]

--[[@class lsp_parameter_information]]
--[[@field label string | { [1]: lsp_uinteger, [2]: lsp_uinteger } ]]
--[[@field documentation? string | lsp_markup_content]]

--[[@class lsp_code_action_client_capabilities_code_action_literal_support_code_action_kind]]
--[[@field valueSet lsp_code_action_kind[] ]]

--[[@class lsp_code_action_client_capabilities_code_action_literal_support]]
--[[@field codeActionKind lsp_code_action_client_capabilities_code_action_literal_support_code_action_kind]]

--[[@class lsp_code_action_client_capabilities_resolve_support]]
--[[@field properties string[] ]]

--[[@class lsp_code_action_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field codeActionLiteralSupport? lsp_code_action_client_capabilities_code_action_literal_support]]
--[[@field isPreferredSupport? boolean]]
--[[@field disabledSupport? boolean]]
--[[@field dataSupport? boolean]]
--[[@field resolveSupport? lsp_code_action_client_capabilities_resolve_support]]
--[[@field honorsChangeAnnotations? boolean]]

--[[@class lsp_code_action_options: lsp_work_done_progress_options]]
--[[@field codeActionKinds? lsp_code_action_kind[] ]]
--[[@field resolveProvider? boolean]]

--[[@class lsp_code_action_registration_options: lsp_text_document_registration_options, lsp_code_action_options]]

--[[@class lsp_code_action_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field range lsp_range]]
--[[@field context lsp_code_action_context]]

--[[@class lsp_code_action_context]]
--[[@field diagnostics lsp_diagnostic[] ]]
--[[@field only? lsp_code_action_kind[] ]]
--[[@field triggerKind? lsp_code_action_trigger_kind]]

--[[@class lsp_code_action_disabled]]
--[[@field reason string]]

--[[@class lsp_code_action]]
--[[@field title string]]
--[[@field kind? lsp_code_action_kind]]
--[[@field diagnostics? lsp_diagnostic[] ]]
--[[@field isPreferred? boolean]]
--[[@field disabled? lsp_code_action_disabled]]
--[[@field edit? lsp_workspace_edit]]
--[[@field command? lsp_command]]
--[[@field data? lsp_any]]

--[[@class lsp_document_color_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_document_color_options: lsp_work_done_progress_options]]

--[[@class lsp_document_color_registration_options: lsp_text_document_registration_options, lsp_static_registration_options, lsp_document_color_options]]

--[[@class lsp_document_color_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]

--[[@class lsp_color_information]]
--[[@field range lsp_range]]
--[[@field color lsp_color]]

--[[@class lsp_color]]
--[[@field red lsp_decimal (readonly)]]
--[[@field green lsp_decimal (readonly)]]
--[[@field blue lsp_decimal (readonly)]]
--[[@field alpha lsp_decimal (readonly)]]

--[[@class lsp_color_presentation_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field color lsp_color]]
--[[@field range lsp_range]]

--[[@class lsp_color_presentation]]
--[[@field label string]]
--[[@field textEdit? lsp_text_edit]]
--[[@field additionalTextEdits? lsp_text_edit[] ]]

--[[@class lsp_document_formatting_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_document_formatting_options: lsp_work_done_progress_options]]

--[[@class lsp_document_formatting_registration_options: lsp_text_document_registration_options, lsp_document_formatting_options]]

--[[@class lsp_document_formatting_params: lsp_work_done_progress_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field options lsp_formatting_options]]

--[[@class lsp_formatting_options: { [string]: boolean | integer | string }]]
--[[@field tabSize lsp_uinteger]]
--[[@field insertSpaces boolean]]
--[[@field trimTrailingWhitespace? boolean]]
--[[@field insertFinalNewline? boolean]]
--[[@field trimFinalNewlines? boolean]]

--[[@class lsp_document_range_formatting_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_document_range_formatting_options: lsp_work_done_progress_options]]

--[[@class lsp_document_range_formatting_registration_options: lsp_text_document_registration_options, lsp_document_range_formatting_options]]

--[[@class lsp_document_range_formatting_params: lsp_work_done_progress_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field range lsp_range]]
--[[@field options lsp_formatting_options]]

--[[@class lsp_document_on_type_formatting_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_document_on_type_formatting_options]]
--[[@field firstTriggerCharacter string]]
--[[@field moreTriggerCharacter? string[] ]]

--[[@class lsp_document_on_type_formatting_registration_options: lsp_text_document_registration_options, lsp_document_on_type_formatting_options]]

--[[@class lsp_document_on_type_formatting_params]]
--[[@field textDocument lsp_text_document_identifier]]
--[[@field position lsp_position]]
--[[@field ch string]]
--[[@field options lsp_formatting_options]]

--[[@class lsp_rename_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field prepareSupport? boolean]]
--[[@field prepareSupportDefaultBehavior? lsp_prepare_support_default_behavior]]
--[[@field honorsChangeAnnotations? boolean]]

--[[@class lsp_rename_options: lsp_work_done_progress_options]]
--[[@field prepareProvider? boolean]]

--[[@class lsp_rename_registration_options: lsp_text_document_registration_options, lsp_rename_options]]

--[[@class lsp_rename_params: lsp_text_document_position_params, lsp_work_done_progress_params]]
--[[@field newName string]]

--[[@class lsp_prepare_rename_params: lsp_text_document_position_params, lsp_work_done_progress_params]]

--[[@class lsp_linked_editing_range_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_linked_editing_range_options: lsp_work_done_progress_options]]

--[[@class lsp_linked_editing_range_registration_options: lsp_text_document_registration_options, lsp_linked_editing_range_options, lsp_static_registration_options]]

--[[@class lsp_linked_editing_range_params: lsp_text_document_position_params, lsp_work_done_progress_params]]

--[[@class lsp_linked_editing_ranges]]
--[[@field ranges lsp_range[] ]]
--[[@field wordPattern? string]]

--[[@class lsp_workspace_symbol_client_capabilities_symbol_kind]]
--[[@field valueSet? lsp_symbol_kind[] ]]

--[[@class lsp_workspace_symbol_client_capabilities_tag_support]]
--[[@field valueSet? lsp_symbol_tag[] ]]

--[[@class lsp_workspace_symbol_client_capabilities_resolve_support]]
--[[@field properties string[] ]]

--[[@class lsp_workspace_symbol_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field symbolKind? lsp_workspace_symbol_client_capabilities_symbol_kind]]
--[[@field tagSupport? lsp_workspace_symbol_client_capabilities_tag_support]]
--[[@field resolveSupport? lsp_workspace_symbol_client_capabilities_resolve_support]]

--[[@class lsp_workspace_symbol_options: lsp_work_done_progress_options]]
--[[@field resolveProvider? boolean]]

--[[@class lsp_workspace_symbol_registration_options: lsp_workspace_symbol_options]]

--[[@class lsp_workspace_symbol_params: lsp_work_done_progress_params, lsp_partial_result_params]]
--[[@field query string]]

--[[@class lsp_workspace_symbol]]
--[[@field name string]]
--[[@field kind lsp_symbol_kind]]
--[[@field tags? lsp_symbol_tag[] ]]
--[[@field containerName? string]]
--[[@field location lsp_location | { uri: lsp_document_uri }]]
--[[@field data? lsp_any]]

--[[@class lsp_configuration_params]]
--[[@field items lsp_configuration_item[] ]]

--[[@class lsp_configuration_item]]
--[[@field scopeUri? lsp_document_uri]]
--[[@field section? string]]

--[[@class lsp_did_change_configuration_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_did_change_configuration_params]]
--[[@field settings lsp_any]]

--[[@class lsp_workspace_folders_server_capabilities]]
--[[@field supported? boolean]]
--[[@field changeNotifications? string | boolean]]

--[[@class lsp_workspace_folder]]
--[[@field uri lsp_document_uri]]
--[[@field name string]]

--[[@class lsp_did_change_workspace_folders_params]]
--[[@field event lsp_workspace_folders_change_event]]

--[[@class lsp_workspace_folders_change_event]]
--[[@field added lsp_workspace_folder[] ]]
--[[@field removed lsp_workspace_folder[] ]]

--[[@class lsp_file_operation_registration_options]]
--[[@field filters lsp_file_operation_filter[] ]]

--[[@class lsp_file_operation_pattern_options]]
--[[@field ignoreCase? boolean]]

--[[@class lsp_file_operation_pattern]]
--[[@field glob string]]
--[[@field matches? lsp_file_operation_pattern_kind]]
--[[@field options? lsp_file_operation_pattern_options]]

--[[@class lsp_file_operation_filter]]
--[[@field scheme? string]]
--[[@field pattern lsp_file_operation_pattern]]

--[[@class lsp_create_files_params]]
--[[@field files lsp_file_create[] ]]

--[[@class lsp_file_create]]
--[[@field uri string]]

--[[@class lsp_rename_files_params]]
--[[@field files lsp_file_rename[] ]]

--[[@class lsp_file_rename]]
--[[@field oldUri string]]
--[[@field newUri string]]

--[[@class lsp_delete_files_params]]
--[[@field files lsp_file_delete[] ]]

--[[@class lsp_file_delete]]
--[[@field uri string]]

--[[@class lsp_did_change_watched_files_client_capabilities]]
--[[@field dynamicRegistration? boolean]]
--[[@field relativePatternSupport? boolean]]

--[[@class lsp_did_change_watched_files_registration_options]]
--[[@field watchers lsp_file_system_watcher[] ]]

--[[@class lsp_relative_pattern]]
--[[@field baseUri lsp_workspace_folder | lsp_uri]]
--[[@field pattern lsp_pattern]]

--[[@class lsp_file_system_watcher]]
--[[@field globPattern lsp_glob_pattern]]
--[[@field kind? lsp_watch_kind]]

--[[@class lsp_did_change_watched_files_params]]
--[[@field changes lsp_file_event[] ]]

--[[@class lsp_file_event]]
--[[@field uri lsp_document_uri]]
--[[@field type lsp_uinteger]]

--[[@class lsp_execute_command_client_capabilities]]
--[[@field dynamicRegistration? boolean]]

--[[@class lsp_execute_command_options: lsp_work_done_progress_options]]
--[[@field commands string[] ]]

--[[@class lsp_execute_command_registration_options: lsp_execute_command_options]]

--[[@class lsp_execute_command_params: lsp_work_done_progress_params]]
--[[@field command string]]
--[[@field arguments? lsp_any[] ]]

--[[@class lsp_apply_workspace_edit_params]]
--[[@field label? string]]
--[[@field edit lsp_workspace_edit]]

--[[@class lsp_apply_workspace_edit_result]]
--[[@field applied boolean]]
--[[@field failureReason? string]]
--[[@field failedChange? lsp_uinteger]]

--[[@class lsp_show_message_params]]
--[[@field type lsp_message_type]]
--[[@field message string]]

--[[@class lsp_show_message_request_client_capabilities_message_action_item]]
--[[@field additionalPropertiesSupport? boolean]]

--[[@class lsp_show_message_request_client_capabilities]]
--[[@field messageActionItem? lsp_show_message_request_client_capabilities_message_action_item]]

--[[@class lsp_show_message_request_params]]
--[[@field type lsp_message_type]]
--[[@field message string]]
--[[@field actions? lsp_message_action_item[] ]]

--[[@class lsp_message_action_item]]
--[[@field title string]]

--[[@class lsp_show_document_client_capabilities]]
--[[@field support boolean]]

--[[@class lsp_show_document_params]]
--[[@field uri lsp_uri]]
--[[@field external? boolean]]
--[[@field takeFocus? boolean]]
--[[@field selection? lsp_range]]

--[[@class lsp_show_document_result]]
--[[@field success boolean]]

--[[@class lsp_log_message_params]]
--[[@field type lsp_message_type]]
--[[@field message string]]

--[[@class lsp_work_done_progress_create_params]]
--[[@field token lsp_progress_token]]

--[[@class lsp_work_done_progress_cancel_params]]
--[[@field token lsp_progress_token]]

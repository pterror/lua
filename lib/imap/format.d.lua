--[[@class imap_flag: string]]
--[[@class imap_capability: string]]
--[[@class imap_mailbox: string]]
--[[@class imap_message: string]]
--[[@class imap_message_id: string]]

--[[@alias imap_command_type "capability"|"logout"|"noop"|"append"|"create"|"delete"|"enable"|"starttls"|"close"|"unselect"|"expunge"]]

--[[@class imap_command]]
--[[@field tag string distinguishes between commands, not necessarily unique]]
--[[@field type string case insensitive]]

--[[TODO: is this right?]]
--[[@class imap_authenticate_command: imap_command]]
--[[@field type "authenticate" case insensitive]]

--[[@class imap_capability_command: imap_command]]
--[[@field type "capability" case insensitive]]

--[[@class imap_logout_command: imap_command]]
--[[@field type "logout" case insensitive]]

--[[@class imap_noop_command: imap_command]]
--[[@field type "noop" case insensitive]]

--[[@class imap_append_command: imap_command]]
--[[@field type "append" case insensitive]]
--[[@field mailbox imap_mailbox]]
--[[@field flags imap_flag[] ]]
--[[@field date_time imap_date_time?]]
--[[@field messsage imap_message]]

--[[@class imap_create_command: imap_command]]
--[[@field type "create" case insensitive]]
--[[@field mailbox imap_mailbox]]

--[[@class imap_delete_command: imap_command]]
--[[@field type "delete" case insensitive]]
--[[@field mailbox imap_mailbox]]

--[[@class imap_enable_command: imap_command]]
--[[@field type "enable" case insensitive]]

--[[@class imap_examine_command: imap_command]]
--[[@field type "examine" case insensitive]]

--[[@class imap_list_command: imap_command]]
--[[@field type "list" case insensitive]]

--[[@class imap_namespace_command: imap_command]]
--[[@field type "namespace" case insensitive]]

--[[@class imap_rename_command: imap_command]]
--[[@field type "rename" case insensitive]]

--[[@class imap_select_command: imap_command]]
--[[@field type "select" case insensitive]]

--[[@class imap_status_command: imap_command]]
--[[@field type "status" case insensitive]]

--[[@class imap_subscribe_command: imap_command]]
--[[@field type "subscribe" case insensitive]]

--[[@class imap_unsubscribe_command: imap_command]]
--[[@field type "unsubscribe" case insensitive]]

--[[@class imap_idle_command: imap_command]]
--[[@field type "idle" case insensitive]]

--[[@class imap_login_command: imap_command]]
--[[@field type "login" case insensitive]]

--[[@class imap_authentiate_command: imap_command]]
--[[@field type "authentiate" case insensitive]]

--[[@class imap_starttls_command: imap_command]]
--[[@field type "starttls" case insensitive]]

--[[@class imap_close_command: imap_command]]
--[[@field type "close" case insensitive]]

--[[@class imap_unselect_command: imap_command]]
--[[@field type "unselect" case insensitive]]

--[[@class imap_expunge_command: imap_command]]
--[[@field type "expunge" case insensitive]]

--[[@class imap_copy_command: imap_command]]
--[[@field type "copy" case insensitive]]
--[[@field message_ids imap_message_id[] ]]
--[[@field mailbox imap_mailbox]]

--[[@class imap_move_command: imap_command]]
--[[@field type "move" case insensitive]]

--[[@class imap_fetch_command: imap_command]]
--[[@field type "fetch" case insensitive]]

--[[@class imap_store_command: imap_command]]
--[[@field type "store" case insensitive]]

--[[@class imap_search_command: imap_command]]
--[[@field type "search" case insensitive]]

--[[@class imap_uid_command: imap_command]]
--[[@field type "uid" case insensitive]]

--[["CAPABILITY" / "LOGOUT" / "NOOP"]]
--[[@alias imap_any_any_command imap_capability_command | imap_logout_command | imap_noop_command]]
--[[valid only in authenticated or selected state]]
--[[@alias imap_any_auth_command imap_append_command | imap_create_command | imap_delete_command | imap_enable_command | imap_examine_command | imap_list_command | imap_namespace_command | imap_rename_command | imap_select_command | imap_status_command | imap_subscribe_command | imap_unsubscribe_command | imap_idle_command]]
--[[valid only in not authenticated state]]
--[[@alias imap_any_nonauth_command imap_login_command | imap_authenticate_command | imap_starttls_command]]
--[[valid only in slected state]]
--[[@alias imap_any_select_command imap_close_command | imap_unselect_command | imap_expunge_command | imap_copy_command | imap_move_command | imap_fetch_command | imap_store_command | imap_search_command | imap_uid_command]]
--[[@alias imap_any_command imap_any_any_command | imap_any_auth_command | imap_any_nonauth_command | imap_any_select_command]]

--[[@class matrix_server]]
--[[@field host string]]

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixclient]]
--[[@class matrix_server_discovery_info]]
--[[@field m.homeserver matrix_homeserver_info]]
--[[@field m.identity_server matrix_identity_server_info]]

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixclient]]
--[[@class matrix_homeserver_info]]
--[[@field base_url string base url for the homeserver for client-server connections]]

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixclient]]
--[[@class matrix_identity_server_info]]
--[[@field base_url string base url for the identity server for client-server connections]]

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixclient]]
--[[@class matrix_server_support_info]]
--[[@field contacts? matrix_contact[] either `contacts` or `support_page` is required]]
--[[@field support_page? string either `contacts` or `support_page` is required]]

--[[https://spec.matrix.org/v1.11/client-server-api/#getwell-knownmatrixsupport]]
--[[@class matrix_contact]]
--[[@field email_address? string either `email_address` or `matrix_id` is required]]
--[[@field matrix_id? string either `email_address` or `matrix_id` is required]]
--[[@field role matrix_role]]

--[[@enum matrix_role]]
local matrix_role = { admin = "m.role.admin", security = "m.role.security" }

--[[https://spec.matrix.org/v1.11/client-server-api/#get_matrixclientversions]]
--[[@class matrix_versions]]
--[[@field unstable_features? table<string, boolean> experimental features the server supports]]
--[[@field versions string[] supported versions]]

--[[https://spec.matrix.org/v1.11/client-server-api/#authentication-types]]
--[[@alias matrix_authentication_request matrix_password_authentication_request|matrix_recaptcha_authentication_request|matrix_sso_authentication_request|matrix_email_authentication_request|matrix_msisdn_authentication_request|matrix_dummy_authentication_request]]


--[[@enum matrix_authentication_type]]
local matrix_authentication_type = {
	password = "m.login.password",
	recaptcha = "m.login.recaptcha",
}

--[[@class matrix_session_id: string]]

--[[https://spec.matrix.org/v1.11/client-server-api/#password-based]]
--[[@class matrix_password_authentication_request]]
--[[@field type "m.login.password"]]
--[[@field identifier matrix_identifier]]
--[[@field password string]]
--[[@field session matrix_session_id]]

--[[https://spec.matrix.org/v1.11/client-server-api/#google-recaptcha]]
--[[@class matrix_recaptcha_authentication_request]]
--[[@field type "m.login.recaptcha"]]
--[[@field respoonse string]]
--[[@field session matrix_session_id]]

--[[https://spec.matrix.org/v1.11/client-server-api/#single-sign-on]]
--[[@class matrix_sso_authentication_request]]
--[[@field type "m.login.sso"]]

--[[https://spec.matrix.org/v1.11/client-server-api/#email-based-identity--homeserver]]
--[[@class matrix_email_authentication_request]]
--[[@field type "m.login.email.identity"]]
--[[@field threepid_creds matrix_threepid_credentials]]
--[[@field session matrix_session_id]]

--[[@class matrix_threepid_credentials]]
--[[@field sid string]]
--[[@field client_secret string]]
--[[@field id_server? string optional if it was not sent in the `/requestToken` request]]
--[[@field id_access_token? string optional if it was not sent in the `/requestToken` request]]

--[[https://spec.matrix.org/v1.11/client-server-api/#phone-numbermsisdn-based-identity--homeserver]]
--[[@class matrix_msisdn_authentication_request]]
--[[@field type "m.login.msisdn"]]
--[[@field threepid_creds matrix_threepid_credentials]]
--[[@field session matrix_session_id]]

--[[https://spec.matrix.org/v1.11/client-server-api/#dummy-auth]]
--[[@class matrix_dummy_authentication_request]]
--[[@field type "m.login.dummy"]]

--[[https://spec.matrix.org/v1.11/client-server-api/#token-authenticated-registration  ]]
--[[only valid on the [register](https://spec.matrix.org/v1.11/client-server-api/#post_matrixclientv3register)]]
--[[endpoint]]
--[[@class matrix_registration]]
--[[@field token string]]
--[[@field session matrix_session_id]]

--[[Documentation taken from https://discord.com/developers/docs/intro]]
--[[WIP]]

local mod = {}

--[=[  (.+)\t(.+)\t(.+)       ]=]
--[=[  --[[@field $1 $2 $3]]  ]=]

--[[@class discord_snowflake]]

--[[@class discord_application]]
--[[@field id discord_snowflake the id of the app]]
--[[@field name string the name of the app]]
--[[@field icon ?string the icon hash of the app]]
--[[@field description string the description of the app]]
--[[@field rpc_origins? string[] an array of rpc origin urls, if rpc is enabled]]
--[[@field bot_public boolean when false only app owner can join the app's bot to guilds]]
--[[@field bot_require_code_grant boolean when true the app's bot will only join upon completion of the full oauth2 code grant flow]]
--[[@field terms_of_service_url? string the url of the app's terms of service]]
--[[@field privacy_policy_url? string the url of the app's privacy policy]]
--[[@field owner? discord_user_partial partial user object containing info on the owner of the application]]
--[[@field summary string **deprecated and will be removed in v11.** An empty string.]]
--[[@field verify_key string the hex encoded key for verification in interactions and the GameSDK's GetTicket]]
--[[@field team? discord_team if the application belongs to a team, this will be a list of the members of that team]]
--[[@field guild_id? discord_snowflake if this application is a game sold on Discord, this field will be the guild to which it has been linked]]
--[[@field primary_sku_id? discord_snowflake if this application is a game sold on Discord, this field will be the id of the "Game SKU" that is created, if exists]]
--[[@field slug? string if this application is a game sold on Discord, this field will be the URL slug that links to the store page]]
--[[@field cover_image? string the application's default rich presence invite cover image hash]]
--[[@field flags? integer the application's public flags]]
--[[@field tags? string[] up to 5 tags describing the content and functionality of the application]]
--[[@field install_params? discord_install_params settings for the application's default in-app authorization link, if enabled]]
--[[@field custom_install_url? string the application's default custom authorization link, if enabled]]
--[[@field role_connections_verification_url? string the application's role connection verification entry point, which when configured will render the app as a verification method in the guild role verification configuration]]

--[[@class discord_team]]
--[[@field icon? string a hash of the image of the team's icon]]
--[[@field id discord_snowflake the unique id of the team]]
--[[@field members discord_team_member[] the members of the team]]
--[[@field name string the name of the team]]
--[[@field owner_user_id discord_snowflake the user id of the current team owner]]

--[[@class discord_team_member]]
--[[@field membership_state discord_membership_state the user's membership state on the team]]
--[[@field permissions {[1]:"*"} will always be ["*"] ]]
--[[@field team_id discord_snowflake the id of the parent team of which they are a member]]
--[[@field user {avatar?:string;discriminator:string;id:discord_snowflake;} the avatar, discriminator, id, and username of the user]]

--[[@class discord_user]]
--[[@field id	discord_snowflake the user's id]]
--[[@field username string the user's username, not unique across the platform]]
--[[@field discriminator string the user's 4-digit discord-tag]]
--[[@field avatar? string the user's avatar hash]]
--[[@field bot? boolean whether the user belongs to an OAuth2 application]]
--[[@field system? boolean whether the user is an Official Discord System user (part of the urgent message system)]]
--[[@field mfa_enabled? boolean whether the user has two factor enabled on their account]]
--[[@field banner? string the user's banner hash]]
--[[@field accent_color? integer the user's banner color encoded as an integer representation of hexadecimal color code]]
--[[@field locale? string the user's chosen language option]]
--[[@field flags? discord_user_flag the flags on a user's account]]
--[[@field premium_type? discord_premium_type the type of Nitro subscription on a user's account]]
--[[@field public_flags? discord_user_flag the public flags on a user's account]]

--[[@class discord_user_email: discord_user]]
--[[@field verified? boolean whether the email on this account has been verified]]
--[[@field email? string the user's email]]

--[[@class discord_connection]]
--[[@field id string id of the connection account]]
--[[@field name string the username of the connection account]]
--[[@field type discord_service_type the service of this connection]]
--[[@field revoked? boolean whether the connection is revoked]]
--[[@field integrations? discord_integration_partial[] an array of partial server integrations]]
--[[@field verified boolean whether the connection is verified]]
--[[@field friend_sync boolean whether friend sync is enabled for this connection]]
--[[@field show_activity boolean whether activities related to this connection will be shown in presence updates]]
--[[@field two_way_link boolean whether this connection has a corresponding third party OAuth2 token]]
--[[@field visibility integer visibility of this connection]]

--[[@class discord_application_role_connection]]
--[[@field platform_name? string the vanity name of the platform a bot has connected (max 50 characters)]]
--[[@field platform_username? string the username on the platform a bot has connected (max 100 characters)]]
--[[@field metadata table<string,string> object mapping application role connection metadata keys to their string-ified value (max 100 characters) for the user on the platform a bot has connected]]

--[[@class discord_application_role_connection_metadata]]
--[[@field type discord_application_role_connection_metadata_type type of metadata value]]
--[[@field key string dictionary key for the metadata field (must be a-z, 0-9, or _ characters; 1-50 characters)]]
--[[@field name string name of the metadata field (1-100 characters)]]
--[[@field name_localizations? table<discord_locale,string> dictionary with keys in available locales translations of the name]]
--[[@field description string description of the metadata field (1-200 characters)]]
--[[@field description_localizations? table<discord_locale,string> dictionary with keys in available locales translations of the description]]

--[[@enum discord_membership_state]]
mod.membership_state = { INVITED = 1, ACCEPTED = 2 }

--[[LINT: flag enums]]
--[[@enum discord_user_flag]]
mod.user_flags = {
	STAFF = 0x1,	--[[Discord Employee]]
	PARTNER = 0x2,	--[[Partnered Server Owner]]
	HYPESQUAD = 0x4,	--[[HypeSquad Events Member]]
	BUG_HUNTER_LEVEL_1 = 0x8,	--[[Bug Hunter Level 1]]
	HYPESQUAD_ONLINE_HOUSE_1 = 0x40,	--[[House Bravery Member]]
	HYPESQUAD_ONLINE_HOUSE_2 = 0x80,	--[[House Brilliance Member]]
	HYPESQUAD_ONLINE_HOUSE_3 = 0x100,	--[[House Balance Member]]
	PREMIUM_EARLY_SUPPORTER = 0x200,	--[[Early Nitro Supporter]]
	TEAM_PSEUDO_USER = 0x400,	--[[User is a team]]
	BUG_HUNTER_LEVEL_2 = 0x4000,	--[[Bug Hunter Level 2]]
	VERIFIED_BOT = 0x10000,	--[[Verified Bot]]
	VERIFIED_DEVELOPER = 0x20000,	--[[Early Verified Bot Developer]]
	CERTIFIED_MODERATOR = 0x40000,	--[[Moderator Programs Alumni]]
	BOT_HTTP_INTERACTIONS = 0x80000,	--[[Bot uses only HTTP interactions and is shown in the online member list]]
	ACTIVE_DEVELOPER = 0x400000,	--[[User is an Active Developer]]
}

--[[@enum discord_premium_type]]
mod.premium_type = { NONE = 0, NITRO_CLASSIC = 1, NITRO = 2, NITRO_BASIC = 3 }

--[[@enum discord_service_type]]
mod.service_type = {
	BATTLENET = "battlenet",	--[[Battle.net]]
	EBAY = "ebay",	--[[eBay]]
	EPICGAMES = "epicgames",	--[[Epic Games]]
	FACEBOOK = "facebook",	--[[Facebook]]
	GITHUB = "github",	--[[GitHub]]
	LEAGUEOFLEGENDS = "leagueoflegends",	--[[League of Legends]]
	PAYPAL = "paypal",	--[[PayPal]]
	PLAYSTATION = "playstation",	--[[PlayStation Network]]
	REDDIT = "reddit",	--[[Reddit]]
	RIOTGAMES = "riotgames",	--[[Riot Games]]
	SPOTIFY = "spotify",	--[[Spotify]]
	SKYPE = "skype",	--[[Skype]]
	STEAM = "steam",	--[[Steam]]
	TIKTOK = "tiktok",	--[[TikTok]]
	TWITCH = "twitch",	--[[Twitch]]
	TWITTER = "twitter",	--[[Twitter]]
	XBOX = "xbox",	--[[Xbox]]
	YOUTUBE = "youtube",	--[[YouTube]]
}

--[[@enum discord_visibility_type]]
mod.visibility_type = {
	NONE = 0, --[[invisible to everyone except the user themselves]]
	EVERYONE = 1, --[[Everyone	visible to everyone]]
}

--[[@enum discord_locale]]
mod.locale = {
	ID = "id", --[[Indonesian]]
	DA = "da", --[[Danish]]
	DE = "de", --[[German]]
	EN_GB = "en-GB", --[[English, UK]]
	EN_US = "en-US", --[[English, US]]
	ES_ES = "es-ES", --[[Spanish]]
	FR = "fr", --[[French]]
	HR = "hr", --[[Croatian]]
	IT = "it", --[[Italian]]
	LT = "lt", --[[Lithuanian]]
	HU = "hu", --[[Hungarian]]
	NL = "nl", --[[Dutch]]
	NO = "no", --[[Norwegian]]
	PL = "pl", --[[Polish]]
	PT_BR = "pt-BR", --[[Portuguese, Brazilian]]
	RO = "ro", --[[Romanian, Romania]]
	FI = "fi", --[[Finnish]]
	SV_SE = "sv-SE", --[[Swedish]]
	VI = "vi", --[[Vietnamese]]
	TR = "tr", --[[Turkish]]
	CS = "cs", --[[Czech]]
	EL = "el", --[[Greek]]
	BG = "bg", --[[Bulgarian]]
	RU = "ru", --[[Russian]]
	UK = "uk", --[[Ukrainian]]
	HI = "hi", --[[Hindi]]
	TH = "th", --[[Thai]]
	ZH_CN = "zh-CN", --[[Chinese, China]]
	JA = "ja",--[[Japanese]]
	ZH_TW = "zh-TW", --[[Chinese, Taiwan]]
	KO = "ko", --[[Korean]]
}

--[[@enum discord_application_role_connection_metadata_type]]
mod.application_role_connection_metadata_type = {
	INTEGER_LESS_THAN_OR_EQUAL = 1, --[[the metadata value (integer) is less than or equal to the guild's configured value (integer)]]
	INTEGER_GREATER_THAN_OR_EQUAL = 2, --[[the metadata value (integer) is greater than or equal to the guild's configured value (integer)]]
	INTEGER_EQUAL = 3, --[[the metadata value (integer) is equal to the guild's configured value (integer)]]
	INTEGER_NOT_EQUAL = 4, --[[the metadata value (integer) is not equal to the guild's configured value (integer)]]
	DATETIME_LESS_THAN_OR_EQUAL = 5, --[[the metadata value (ISO8601 string) is less than or equal to the guild's configured value (integer; days before current date)]]
	DATETIME_GREATER_THAN_OR_EQUAL = 6, --[[the metadata value (ISO8601 string) is greater than or equal to the guild's configured value (integer; days before current date)]]
	BOOLEAN_EQUAL = 7, --[[the metadata value (integer) is equal to the guild's configured value (integer; 1)]]
	BOOLEAN_NOT_EQUAL = 8, --[[the metadata value (integer) is not equal to the guild's configured value (integer; 1)]]
}

return mod

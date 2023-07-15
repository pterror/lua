-- Internet Relay Chat Protocol
-- https://www.rfc-editor.org/rfc/rfc1459
-- Internet Relay Chat: Client Protocol (update to RFC1459)
-- https://www.rfc-editor.org/rfc/rfc2812
-- Internet Relay Chat: Server Protocol (update to RFC1459)
-- https://www.rfc-editor.org/rfc/rfc2813

local mod = {}

local sub = string.sub; local find = string.find

mod.codes = {
	-- client <-> server
	-- The server sends Replies 001 to 004 to a user upon successful registration.
	[001] = { name = "RPL_WELCOME", string = "Welcome to the Internet Relay Network <nick>!<user>@<host>" },
	[002] = { name = "RPL_YOURHOST", string = "Your host is <servername>, running version <ver>" },
	[003] = { name = "RPL_CREATED", string = "This server was created <date>" },
	[004] = { name = "RPL_MYINFO", string = "<servername> <version> <available user modes> <available channel modes>" },
	-- Sent by the server to a user to suggest an alternative server.
	-- This is often used when the connection is refused because the server is already full.
	[005] = { name = "RPL_BOUNCE", string = "Try server <server name>, port <port number>" },
	-- responses
	[200] = { name = "RPL_TRACELINK", string = "Link <version & debug level> <destination> <next server> V<protocol version> <link uptime in seconds> <backstream sendq> <upstream sendq>" },
	[201] = { name = "RPL_TRACECONNECTING", string = "Try. <class> <server>" },
	[202] = { name = "RPL_TRACEHANDSHAKE", string = "H.S. <class> <server>" },
	[203] = { name = "RPL_TRACEUNKNOWN", string = "???? <class> [<client IP address in dot form>]" },
	[204] = { name = "RPL_TRACEOPERATOR", string = "Oper <class> <nick>" },
	[205] = { name = "RPL_TRACEUSER", string = "User <class> <nick>" },
	[206] = { name = "RPL_TRACESERVER", string = "Serv <class> <int>S <int>C <server> <nick!user|*!*>@<host|server> V<protocol version>" },
	[207] = { name = "RPL_TRACESERVICE", string = "Service <class> <name> <type> <active type>" },
	[208] = { name = "RPL_TRACENEWTYPE", string = "<newtype> 0 <client name>" },
	[209] = { name = "RPL_TRACECLASS", string = "Class <class> <count>" },
	[210] = { name = "RPL_TRACERECONNECT", string = "Unused." }, -- unused.
	[211] = { name = "RPL_STATSLINKINFO", string = "<linkname> <sendq> <sent messages> <sent Kbytes> <received messages> <received Kbytes> <time open>" },
	[212] = { name = "RPL_STATSCOMMANDS", string = "<command> <count> <byte count> <remote count>" },
	--[[@deprecated]]
	[213] = { name = "RPL_STATSCLINE", string = "C <host> * <name> <port> <class>" },
	--[[@deprecated]]
	[214] = { name = "RPL_STATSNLINE", string = "N <host> * <name> <port> <class>" },
	--[[@deprecated]]
	[215] = { name = "RPL_STATSILINE", string = "I <host> * <host> <port> <class>" },
	--[[@deprecated]]
	[216] = { name = "RPL_STATSKLINE", string = "K <host> * <username> <port> <class>" },
	--[[@deprecated]]
	[217] = { name = "RPL_STATSQLINE", string = "Q unknown" }, -- unknown string
	--[[@deprecated]]
	[218] = { name = "RPL_STATSYLINE", string = "Y <class> <ping frequency> <connect frequency> <max sendq>" },
	[219] = { name = "RPL_ENDOFSTATS", string = "<stats letter> :End of STATS report" },
	[221] = { name = "RPL_UMODEIS", string = "<user mode string>" },
	--[[@deprecated]]
	[231] = { name = "RPL_SERVICEINFO", string = "Service info" }, -- unknown string
	--[[@deprecated]]
	[232] = { name = "RPL_ENDOFSERVICES", string = ":End of SERVICES" }, -- unknown string
	--[[@deprecated]]
	[233] = { name = "RPL_SERVICE", string = "Service" }, -- unknown string
	[234] = { name = "RPL_SERVLIST", string = "<name> <server> <mask> <type> <hopcount> <info>" },
	[235] = { name = "RPL_SERVLISTEND", string = "<mask> <type> :End of service listing" },
	--[[@deprecated]]
	[240] = { name = "RPL_STATSVLINE", string = "Unknown" }, -- unknown string
	--[[@deprecated]]
	[241] = { name = "RPL_STATSLLINE", string = "L <hostmask> * <servername> <maxdepth>" },
	[242] = { name = "RPL_STATSUPTIME", string = ":Server Up %d days %d:%02d:%02d" },
	[243] = { name = "RPL_STATSOLINE", string = "O <hostmask> * <name>" },
	--[[@deprecated]]
	[244] = { name = "RPL_STATSHLINE", string = "H <hostmask> * <servername>" },
	--[[@deprecated]]
	[245] = { name = "RPL_STATSSLINE", string = "S <hostmask> * <servicename>" }, -- unknown string
	--[[@deprecated]]
	[246] = { name = "RPL_STATSPING", string = "Unknown" }, -- unknown string
	--[[@deprecated]]
	[247] = { name = "RPL_STATSBLINE", string = "Unknown" }, -- unknown string
	--[[@deprecated]]
	[250] = { name = "RPL_STATSDLINE", string = "Unknown" }, -- unknown string
	[251] = { name = "RPL_LUSERCLIENT", string = ":There are <integer> users and <integer> services on <integer> servers" },
	[252] = { name = "RPL_LUSEROP", string = "<integer> :operator(s) online" },
	[253] = { name = "RPL_LUSERUNKNOWN", string = "<integer> :unknown connection(s)" },
	[254] = { name = "RPL_LUSERCHANNELS", string = "<integer> :channels formed" },
	[255] = { name = "RPL_LUSERME", string = ":I have <integer> clients and <integer> servers" },
	[256] = { name = "RPL_ADMINME", string = "<server> :Administrative info" },
	[257] = { name = "RPL_ADMINLOC1", string = ":<admin info>" },
	[258] = { name = "RPL_ADMINLOC2", string = ":<admin info>" },
	[259] = { name = "RPL_ADMINEMAIL", string = ":<admin info>" },
	[261] = { name = "RPL_TRACELOG", string = "File <logfile> <debug level>" },
	[262] = { name = "RPL_TRACEEND", string = "<server name> <version & debug level> :End of TRACE" },
	-- When a server drops a command without processing it,
	-- it MUST use the reply RPL_TRYAGAIN to inform the originating client.
	[263] = { name = "RPL_TRYAGAIN", string = "<command> :Please wait a while and try again." },
	--[[@deprecated]]
	[300] = { name = "RPL_NONE", string = "unknown" }, -- unknown string
	[301] = { name = "RPL_AWAY", string = "<nick> :<away message>" },
	[302] = { name = "RPL_USERHOST", string = ":*1<reply> ( <reply>)*" },
	[303] = { name = "RPL_ISON", string = ":*1<nick> ( <nick>)*"},
	[305] = { name = "RPL_UNAWAY", string = ":You are no longer marked as being away" },
	[306] = { name = "RPL_NOWAWAY", string = ":You have been marked as being away" },
	[311] = { name = "RPL_WHOISUSER", string = "<nick> <user> <host> * :<real name>" },
	[312] = { name = "RPL_WHOISSERVER", string = "<nick> <server> :<server info>" },
	[313] = { name = "RPL_WHOISOPERATOR", string = "<nick> :is an IRC operator" },
	[314] = { name = "RPL_WHOWASUSER", string = "<nick> <user> <host> * :<real name>" },
	[315] = { name = "RPL_ENDOFWHO", string = "<name> :End of WHO list" },
	--[[@deprecated]]
	[316] = { name = "RPL_WHOISCHANOP", string = "unknown" }, -- unknown string
	[317] = { name = "RPL_WHOISIDLE", string = "<nick> <integer> :seconds idle" },
	[318] = { name = "RPL_ENDOFWHOIS", string = "<nick> :End of WHOIS list" },
	[319] = { name = "RPL_WHOISCHANNELS", string = "<nick> :([@+]<channel> )*" },
	--[[@deprecated]]
	[321] = { name = "RPL_LISTSTART", string = "Obsolete" },
	[322] = { name = "RPL_LIST", string = "<channel> <# visible> :<topic>" },
	[323] = { name = "RPL_LISTEND", string = ":End of LIST" },
	[324] = { name = "RPL_CHANNELMODEIS", string = "<channel> <mode> <mode params>" },
	[325] = { name = "RPL_UNIQOPIS", string = "<channel> <nickname>" },
	[331] = { name = "RPL_NOTOPIC", string = "<channel> :No topic is set" },
	[332] = { name = "RPL_TOPIC", string = "<channel> :<topic>" },
	[341] = { name = "RPL_INVITING", string = "<channel> <nick>" },
	[342] = { name = "RPL_SUMMONING", string = "<user> :Summoning user to IRC" },
	[346] = { name = "RPL_INVITELIST", string = "<channel> <invitemask>" },
	[347] = { name = "RPL_ENDOFINVITELIST", string = "<channel> :End of channel invite list" },
	[348] = { name = "RPL_EXCEPTLIST", string = "<channel> <exceptionmask>" },
	[349] = { name = "RPL_ENDOFEXCEPTLIST", string = "<channel> :End of channel exception list" },
	[351] = { name = "RPL_VERSION", string = "<version>.<debuglevel> <server> :<comments>" },
	[352] = { name = "RPL_WHOREPLY", string = "<channel> <user> <host> <server> <nick> [HG] > %*?[@+]? :<hopcount> <real name>" },
	[353] = { name = "RPL_NAMREPLY", string = "[=*@]<channel> :[@+]?<nick> ( [@+]?<nick>)*" },
	[364] = { name = "RPL_LINKS", string = "<mask> <server> :<hopcount> <server info>" },
	--[[@deprecated]]
	[361] = { name = "RPL_KILLDONE", string = "unknown" }, -- unknown string
	--[[@deprecated]]
	[362] = { name = "RPL_CLOSING", string = "unknown" }, -- unknown string
	--[[@deprecated]]
	[363] = { name = "RPL_CLOSEEND", string = "unknown" }, -- unknown string
	[365] = { name = "RPL_ENDOFLINKS", string = "<mask> :End of LINKS list" },
	[366] = { name = "RPL_ENDOFNAMES", string = "<channel> :End of NAMES list" },
	[367] = { name = "RPL_BANLIST", string = "<channel> <banmask>" },
	[368] = { name = "RPL_ENDOFBANLIST", string = "<channel> :End of channel ban list" },
	[369] = { name = "RPL_ENDOFWHOWAS", string = "<nick> :End of WHOWAS" },
	[371] = { name = "RPL_INFO", string = ":<string>" },
	[372] = { name = "RPL_MOTD", string = ":- <text>" },
	--[[@deprecated]]
	[373] = { name = "RPL_INFOSTART", string = "unknown" }, -- unknown string
	[374] = { name = "RPL_ENDOFINFO", string = ":End of INFO list" },
	[375] = { name = "RPL_MOTDSTART", string = ":- <server> Message of the day - " },
	[376] = { name = "RPL_ENDOFMOTD", string = ":End of MOTD command" },
	[381] = { name = "RPL_YOUREOPER", string = ":You are now an IRC operator" },
	[382] = { name = "RPL_REHASHING", string = "<config file> :Rehashing" },
	[383] = { name = "RPL_YOURESERVICE", string = "You are service <servicename>" },
	--[[@deprecated]]
	[384] = { name = "RPL_MYPORTIS", string = ":My port is <port>" }, -- unknown string
	[391] = { name = "RPL_TIME", string = "<server> :<string showing server's local time>" },
	[392] = { name = "RPL_USERSSTART", string = ":UserID   Terminal  Host" },
	[393] = { name = "RPL_USERS", string = ":<username> <ttyline> <hostname>" },
	[394] = { name = "RPL_ENDOFUSERS", string = ":End of users" },
	[395] = { name = "RPL_NOUSERS", string = ":Nobody logged in" },
	-- errors
	[401] = { name = "ERR_NOSUCHNICK", string = "<nickname> :No such nick/channel" },
	[402] = { name = "ERR_NOSUCHSERVER", string = "<server name> :No such server" },
	[403] = { name = "ERR_NOSUCHCHANNEL", string = "<channel name> :No such channel" },
	[404] = { name = "ERR_CANNOTSENDTOCHAN", string = "<channel name> :Cannot send to channel" },
	[405] = { name = "ERR_TOOMANYCHANNELS", string = "<channel name> :You have joined too many channels" },
	[406] = { name = "ERR_WASNOSUCHNICK", string = "<nickname> :There was no such nickname" },
	[407] = { name = "ERR_TOOMANYTARGETS", string = "<target> :<error code> recipients. <abort message>" },
	[408] = { name = "ERR_NOSUCHSERVICE", string = "<service name> :No such service" },
	[409] = { name = "ERR_NOORIGIN", string = ":No origin specified" },
	[411] = { name = "ERR_NORECIPIENT", string = ":No recipient given (<command>)" },
	[412] = { name = "ERR_NOTEXTTOSEND", string = ":No text to send" },
	[413] = { name = "ERR_NOTOPLEVEL", string = "<mask> :No toplevel domain specified" },
	[414] = { name = "ERR_WILDTOPLEVEL", string = "<mask> :Wildcard in toplevel domain" },
	[415] = { name = "ERR_BADMASK", string = "<mask> :Bad Server/host mask" },
	[421] = { name = "ERR_UNKNOWNCOMMAND", string = "<command> :Unknown command" },
	[422] = { name = "ERR_NOMOTD", string = ":MOTD File is missing" },
	[423] = { name = "ERR_NOADMININFO", string = "<server> :No administrative info available" },
	[424] = { name = "ERR_FILEERROR", string = ":File error doing <file op> on <file>" },
	[431] = { name = "ERR_NONICKNAMEGIVEN", string = ":No nickname given" },
	[432] = { name = "ERR_ERRONEUSNICKNAME", string = "<nick> :Erroneous nickname" },
	[433] = { name = "ERR_NICKNAMEINUSE", string = "<nick> :Nickname is already in use" },
	[436] = { name = "ERR_NICKCOLLISION", string = "<nick> :Nickname collision KILL from <user>@<host>" },
	[437] = { name = "ERR_UNAVAILRESOURCE", string = "<nick/channel> :Nick/channel is temporarily unavailable" },
	[441] = { name = "ERR_USERNOTINCHANNEL", string = "<nick> <channel> :They aren't on that channel" },
	[442] = { name = "ERR_NOTONCHANNEL", string = "<channel> :You're not on that channel" },
	[443] = { name = "ERR_USERONCHANNEL", string = "<user> <channel> :is already on channel" },
	[444] = { name = "ERR_NOLOGIN", string = "<user> :User not logged in" },
	[445] = { name = "ERR_SUMMONDISABLED", string = ":SUMMON has been disabled" },
	[446] = { name = "ERR_USERSDISABLED", string = ":USERS has been disabled" },
	[451] = { name = "ERR_NOTREGISTERED", string = ":You have not registered" },
	[461] = { name = "ERR_NEEDMOREPARAMS", string = "<command> :Not enough parameters" },
	[462] = { name = "ERR_ALREADYREGISTRED", string = ":Unauthorized command (already registered)" },
	[463] = { name = "ERR_NOPERMFORHOST", string = ":Your host isn't among the privileged" },
	[464] = { name = "ERR_PASSWDMISMATCH", string = ":Password incorrect" },
	[465] = { name = "ERR_YOUREBANNEDCREEP", string = ":You are banned from this server" },
	--[[@deprecated]]
	[466] = { name = "ERR_YOUWILLBEBANNED", string = ":You will be banned" }, -- unknown string
	[467] = { name = "ERR_KEYSET", string = "<channel> :Channel key already set" },
	[471] = { name = "ERR_CHANNELISFULL", string = "<channel> :Cannot join channel (+l)" },
	[472] = { name = "ERR_UNKNOWNMODE", string = "<char> :is unknown mode char to me for <channel>" },
	[473] = { name = "ERR_INVITEONLYCHAN", string = "<channel> :Cannot join channel (+i)" },
	[474] = { name = "ERR_BANNEDFROMCHAN", string = "<channel> :Cannot join channel (+b)" },
	[475] = { name = "ERR_BADCHANNELKEY", string = "<channel> :Cannot join channel (+k)" },
	[476] = { name = "ERR_BADCHANMASK", string = "<channel> :Bad Channel Mask" },
	[477] = { name = "ERR_NOCHANMODES", string = "<channel> :Channel doesn't support modes" },
	[478] = { name = "ERR_BANLISTFULL", string = "<channel> <char> :Channel list is full" },
	[481] = { name = "ERR_NOPRIVILEGES", string = ":Permission Denied- You're not an IRC operator" },
	[482] = { name = "ERR_CHANOPRIVSNEEDED", string = "<channel> :You're not channel operator" },
	[483] = { name = "ERR_CANTKILLSERVER", string = ":You can't kill a server!" },
	[484] = { name = "ERR_RESTRICTED", string = ":Your connection is restricted!" },
	[485] = { name = "ERR_UNIQOPPRIVSNEEDED", string = ":You're not the original channel operator" },
	[491] = { name = "ERR_NOOPERHOST", string = ":No O-lines for your host" },
	[492] = { name = "ERR_NOSERVICEHOST", string = ":No S-lines for your host" },
	[501] = { name = "ERR_UMODEUNKNOWNFLAG", string = ":Unknown MODE flag" },
	[502] = { name = "ERR_USERSDONTMATCH", string = ":Cannot change mode for other users" },
}
if false --[[delete_code_name]] then
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	for k in pairs(mod.codes) do mod.codes[k] = mod.codes[k].string end
end
if true --[[delete_reserved]] then
	for _, k in ipairs({ 231, 232, 233, 300, 316, 361, 362, 363, 373, 384, 213, 214, 215, 216, 217, 218, 240, 241, 244, 245, 246, 247, 250, 492 }) do
		mod.codes[k] = nil
	end
end

	--[[FIXME:]]
--[[@param s string]] --[[@param i integer]]
mod.read_targets = function (s, i)
	i = i or 1
	local ret = {}
	while true do break end
	return ret
end

--[[@param s string]] --[[@param i integer]]
local messages_iter = function (s, i)
	while sub(s, i, i + 1) == "\r\n" do i = i + 2 end
	local start, end_, servername, nick, user, host
	--[[check parsing of a@b@c]]
	start, end_, nick, _, user, _, host = find(s, "(:(%a[%w%[%]\\`^{}-]*)(!([^%z \r\n][^%z \r\n]-))(@(?????????))? +)")
	if not start then
		start, end_, servername = find(s, ":(?????????) +(?????????)\r\n", i)
	end
	if end_ then i = end_ + 1 end
	local command
	start, end_, command = find(s, "(%a+)", i)
	if not start then
		start, end_, command = find(s, "(%d%d%d)", i)
	end
	if not command then return nil, "irc: invalid command" end
	i = end_ + 1
	local params = {}
	while true do
		local param
		start, end_, param = find(s, ":([^%z\r\n]*)")
		if param then params[#params+1] = param; i = end_ + 1; break end
		start, end_, param = find(s, "([^%z \r\n])")
		if not start then break end
		params[#params+1] = param
		i = end_ + 1
	end
end

--[[@param s string]]
mod.messages = function (s)
	return messages_iter, s, 1
end

return mod

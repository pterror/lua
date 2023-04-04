-- https://www.ietf.org/rfc/rfc1035.txt
-- section 4

local mod = {}

local empty_table = {}

local lshift = bit.lshift; local rshift = bit.rshift; local band = bit.band
local bor = bit.bor; local char = string.char; local byte = string.byte
local sub = string.sub; local concat = table.concat

-- LINT: disallow duplicate values

-- 3.2.2
--[[@enum dns_type]]
mod.type = {
	A = 1, --[[a host address - see RFC1035]]
	NS = 2, --[[an authoritative name server - see RFC1035]]
	MD = 3, --[[@deprecated use MX]] --[[a mail destination - see RFC883, obsoleted by RFC973]]
	MF = 4, --[[@deprecated use MX]] --[[a mail forwarder - see RFC883, obsoleted by RFC973]]
	CNAME = 5, --[[the canonical name for an alias - see RFC1035]]
	SOA = 6, --[[marks the start of a zone of authority - see RFC1035]]
	MB = 7, --[[@deprecated perpetually experimental]] --[[a mailbox domain name (EXPERIMENTAL) - see RFC883]]
	MG = 8, --[[@deprecated perpetually experimental]] --[[a mail group member (EXPERIMENTAL) - see RFC883]]
	MR = 9, --[[@deprecated perpetually experimental]] --[[a mail rename domain name (EXPERIMENTAL) - see RFC883]]
	NULL = 10, --[[@deprecated]] --[[a null RR - see RFC883, obsoleted by RFC1035]]
	WKS = 11, --[[@deprecated not to be relied upon]] --[[a well known service description - see RFC883, obsoleted by RFC1123, RFC1127]]
	PTR = 12, --[[a domain name pointer - see RFC1035]]
	HINFO = 13, --[[host information - used by cloudflare in response to TXT since it is plaintext - see RFC883, unobsoleted by RFC8482]]
	MINFO = 14, --[[@deprecated perpetually experimental?]] --[[mailbox or mail list information - see RFC883]]
	MX = 15, --[[mail exchange - see RFC1035]]
	TXT = 16, --[[text strings - see RFC1035]]
	-- https://en.wikipedia.org/wiki/List_of_DNS_record_types#Resource_records

	RP = 17, --[[@deprecated]] --[[responsible person for the domain - see RFC1183]]
	AFSDB = 18, --[[AFS database record - see RFC1183]]
	X25 = 19, --[[@deprecated]] --[[see RFC1183]]
	ISDN = 20, --[[@deprecated]] --[[see RFC1183]]
	RT = 21, --[[@deprecated]] --[[see RFC1183]]
	NSAP = 22, --[[@deprecated]] --[[see RFC1183]]
	["NSAP-PTR"] = 23, --[[@deprecated]] --[[see RFC1183]]
	SIG = 24, --[[@deprecated]] --[[signature - see RFC2065, RFC2930, RCE2931, obsoleted by RFC3755]]
	KEY = 25, --[[@deprecated]] --[[key - see RFC2065, RFC2930, RCE2931, obsoleted by RFC3445, RFC3755, RFC4025]]
	PX = 26, --[[@deprecated is not used]] --[[see RFC2163]]
	GPOS = 27, --[[@deprecated superseded by LOC]] --[[see RFC1712]]
	AAAA = 28, --[[an IPv6 host address - see RFC3596]]
	LOC = 29, --[[geographical location - see RFC1876]]
	NXT = 30, --[[@deprecated]] --[[see RFC2065, obsoleted by RFC3755]]
	EID = 31, --[[@deprecated never became RFC]] --[[Nimrod DNS - see https://datatracker.ietf.org/doc/html/draft-ietf-nimrod-dns-00]]
	NIMLOC = 32, --[[@deprecated never became RFC]] --[[Nimrod DNS - see https://datatracker.ietf.org/doc/html/draft-ietf-nimrod-dns-00]]
	SRV = 33, --[[general services - see RFC2782]]
	ATMA = 34, --[[@deprecated]] --[[]]
	NAPTR = 35, --[[naming authority pointer - see RFC3403]]
	KX = 36, --[[key exchanger - see RFC2230]]
	CERT = 37, --[[certificate (PKIX, SPXI, PGP etc.) - see RFC4398]]
	A6 = 38, --[[@deprecated historic]] --[[part of early IPv6 - see RFC2874, obsoleted by RFC6563]]
	DNAME = 39, --[[delegation name - see RFC6672]]
	SINK = 40, --[[@deprecated never became RFC]] --[[kitchen sink for structured data - see https://datatracker.ietf.org/doc/html/draft-eastlake-kitchen-sink]]
	OPT = 41, --[[option - pseudo-record used in EDNS - see RFC6891]]
	APL = 42, --[[@deprecated experimental]] --[[address prefix list - see RFC3123]]
	DS = 43, --[[delegation signer - see RFC4034]]
	SSHFP = 44, --[[ssh public key fingerprint - see RFC4255]]
	IPSECKEY = 45, --[[IPsec key - see RFC4025]]
	RRSIG = 46, --[[DNSSEC signature - see RFC4034]]
	NSEC = 47, --[[Next Secure - see RFC4034]]
	DNSKEY = 48, --[[DNS key - see RFC4034]]
	DHCID = 49, --[[DHCP identifier - see RFC4701]]
	NSEC3 = 50, --[[Next Secure version 3 - see RFC5155]]
	NSEC3PARAM = 51, --[[NSEC3 parameters - see RFC5155]]
	TLSA = 52, --[[TLSA certificate association - see RFC6698]]
	SMIMEA = 53, --[[S/MIME certificate association - see RFC8162]]
	HIP = 55, --[[Host Identity Protocol - see RFC8005]]
	NINFO = 56, --[[@deprecated expired without adoption]] --[[zone status information - see https://datatracker.ietf.org/doc/draft-reid-dnsext-zs/]]
	RKEY = 57, --[[@deprecated expired without adoption]] --[[see https://datatracker.ietf.org/doc/draft-reid-dnsext-rkey/]]
	TALINK = 58, --[[@deprecated never became RFC]] --[[see https://datatracker.ietf.org/doc/html/draft-wijngaards-dnsop-trust-history-02]]
	CDS = 59, --[[child DS - see RFC7344]]
	CDNSKEY = 60, --[[child DNSKEY - see RFC7344]]
	OPENPGPKEY = 61, --[[OpenPGP public key - see RFC7929]]
	CSYNC = 62, --[[child-to-parent synchronization - see RFC7477]]
	ZONEMD = 63, --[[cryptographic message digests for DNS zones - see RFC8976]]
	SVCB = 64, --[[service binding - see https://datatracker.ietf.org/doc/draft-ietf-dnsop-svcb-https/00/]]
	HTTPS = 65, --[[HTTPS binding - see https://datatracker.ietf.org/doc/draft-ietf-dnsop-svcb-https/00/]]
	SPF = 99, --[[@deprecated lack of support]] --[[Sender Policy Framework - see RFC4408, obsoleted in RFC7208]]
	UINFO = 100, --[[@deprecated IANA reserved]]
	UID = 101, --[[@deprecated IANA reserved]]
	GID = 102, --[[@deprecated IANA reserved]]
	UNSPEC = 103, --[[@deprecated IANA reserved]]
	NID = 104, --[[@deprecated not in use]]
	L32 = 105, --[[@deprecated not in use]]
	L64 = 106, --[[@deprecated not in use]]
	LP = 107, --[[@deprecated not in use]]
	EUI48 = 108, --[[EUI-48 MAC address - see RFC7043]]
	EUI64 = 109, --[[EUI-64 MAC address - see RFC7043]]
	TKEY = 249, --[[Transaction Key - see RFC2930]]
	TSIG = 250, --[[Transaction Signature - see RFC2845]]
	IXFR = 251, --[[Questions only. A request for a transfer of an entire zone]]
	AXFR = 252, --[[Questions only. A request for a transfer of an entire zone - see RFC1035]]
	MAILB = 253, --[[@deprecated perpetually experimental?]] --[[Questions only. A request for mailbox-related records (`MB`, `MG` or `MR`) - see RFC883]]
	MAILA = 254, --[[@deprecated see MX]] --[[Questions only. A request for mail agent RRs - see RFC883]]
	["*"] = 255, --[[Questions only. A request for all records - see RFC1035]]
	URI = 256, --[[Uniform Resource Identifier - see RFC7553]]
	CAA = 257, --[[Certification Authority Authorization - see RFC6844]]
	DOA = 259, --[[@deprecated never became RFC]] --[[Digital Object Architecture - see https://datatracker.ietf.org/doc/html/draft-durand-doa-over-dns-03]]
	TA = 32768, --[[DNSSEC Trust Authorities]]
	DLV = 32769, --[[DNSSEC Lookaside Validation - see RFC4431, RFC5074]]
}
if false --[[ignore_deprecated]] then
	for _, k in ipairs({
		"MD", "MF", "MB", "MG", "MR", "NULL", "WKS", --[[HINFO unobsoleted]] "MINFO", "RP", "X25", "ISDN", "RT", "NSAP", "NSAP-PTR",
		"SIG", "KEY", "PX", "GPOS", "NXT", "EID", "NIMLOC", "ATMA", "A6", "SINK", "APL", "NINFO", "RKEY",
		"TALINK", "SPF", "UINFO", "UID", "GID", "UNSPEC", "NID", "L32", "L64", "LP", "DOA"
	}) do mod.type[k] = nil end
end
--[[@type table<dns_type, string>]]
mod.type_name = {}
for k, v in pairs(mod.type) do mod.type_name[v] = k end

mod.string_to_domain_name = function (s, i) --[[@param s string]] --[[@param i integer]]
	i = i or 1
	local length = byte(s, i)
	local parts = {} --[[@type string[] ]]
	while length > 0 and length <= 0x3f do
		parts[#parts+1] = sub(s, i + 1, i + length)
		i = i + length + 1
		length = byte(s, i)
	end
	i = i + (length > 0x3f and 2 or 1)
	local l = i - 2
	while length > 0x3f do -- pointer
		l = bor(lshift(band(length, 0x3f), 8), byte(s, l + 1)) + 1
		length = byte(s, l)
		while length > 0 and length <= 0x3f do
			parts[#parts+1] = sub(s, l + 1, l + length)
			l = l + length + 1
			length = byte(s, l)
		end
	end
	parts[#parts+1] = ""
	return parts, i
end

mod.decoders = {
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.1]]
	[mod.type.CNAME] = mod.string_to_domain_name,
		--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.2]]
	[mod.type.HINFO] = function (s, i) --[[@param s string]]
		i = i or 1
		local length = s:byte(i)
		local cpu = s:sub(i + 1, i + length)
		i = i + length + 1
		length = s:byte(i)
		local os = s:sub(i + 1, i + length)
		i = i + length + 1
		return { cpu = cpu, os = os }, i
	end,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.3]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MB] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.4]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MD] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.5]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MF] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.6]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MG] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.7]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MINFO] = function (s, i)
		local rmailbx, emailbx
		rmailbx, i = mod.string_to_domain_name(s, i)
		emailbx, i = mod.string_to_domain_name(s, i)
		return { rmailbx = rmailbx, emailbx = emailbx }, i
	end,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.8]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.MR] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.9]]
	[mod.type.MX] = function (s, i)
		i = i or 1
		local b1, b2 = s:byte(i, i + 1)
		local preference = bor(lshift(b1, 8), b2)
		local exchange
		exchange, i = mod.string_to_domain_name(s, i + 2)
		return { preference = preference, exchange = exchange }, i
	end,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.10]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.NULL] = function (s, i, length) i = i or 1; return s:sub(i, i + length - 1), i + length end,
	--[[s must be the full string for ns to return the correct values]]
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.11]]
	[mod.type.NS] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.12]]
	[mod.type.PTR] = mod.string_to_domain_name,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.13]]
	[mod.type.SOA] = function (s, i) --[[@param s string]] --[[@param i integer]]
		i = i or 1
		local mname, rname
		mname, i = mod.string_to_domain_name(s, i)
		rname, i = mod.string_to_domain_name(s, i)
		local b1, b2, b3, b4 = s:byte(i, i + 3)
		local serial = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 4, i + 7)
		local refresh = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 8, i + 11)
		local retry = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 12, i + 15)
		local expire = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 16, i + 19)
		local minimum = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		return { mname = mname, rname = rname, serial = serial, refresh = refresh, retry = retry, expire = expire, minimum = minimum }, i + 20
	end,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.3.14]]
	[mod.type.TXT] = function (s, i, length) --[[@param s string]]
		i = i or 1
		local end_ = i + length - 1
		local ret = {}
		while i <= end_ do
			local length2 = s:byte(i)
			ret[#ret+1] = s:sub(i + 1, i + length2)
			i = i + length + 1
		end
		return ret, length
	end,
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.4.1]]
	[mod.type.A] = function (s, i) i = i or 1; return { s:byte(i, i + 3) }, i + 4 end, --[[@param s string]]
	--[[https://www.rfc-editor.org/rfc/rfc1035#section-3.4.2]] --[[@diagnostic disable-next-line: deprecated]]
	[mod.type.WKS] = function (s, i, length) --[[@param s string]] --[[@param length integer]]
		i = i or 1; return { address = { s:byte(i, i + 3) }, protocol = s:byte(i + 4), bitmap = s:sub(i + 5, i + length - 1) }, i + length
	end,
	[mod.type.AAAA] = function (s, i) i = i or 1; return { s:byte(i, i + 15) }, i + 16 end, --[[@param s string]]
	--[[https://www.rfc-editor.org/rfc/rfc4034#section-5]]
	[mod.type.DS] = function (s, i, length) --[[@param s string]]
		i = i or 1
		local b1, b2 = s:byte(i, i + 1)
		local key_tag = bor(lshift(b1, 8), b2)
		local algorithm = s:byte(i + 2)
		local digest_type = s:byte(i + 3)
		local digest = s:sub(i + 4, i + length - 1)
		return { key_tag = key_tag, algorithm = algorithm, digest_type = digest_type, digest = digest }, i + length
	end,
	--[[https://www.rfc-editor.org/rfc/rfc4034#section-3]]
	[mod.type.RRSIG] = function (s, i, length) --[[@param s string]]
		local end_ = i + length
		i = i or 1
		local b1, b2 = s:byte(i, i + 1)
		local type_covered = bor(lshift(b1, 8), b2)
		local algorithm = s:byte(i + 2)
		local labels = s:byte(i + 3)
		local b3, b4
		b1, b2, b3, b4 = s:byte(i + 4, i + 7)
		local original_ttl = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 8, i + 11)
		local signature_expiration = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2, b3, b4 = s:byte(i + 12, i + 15)
		local signature_inception = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
		b1, b2 = s:byte(i + 16, i + 17)
		local key_tag = bor(lshift(b1, 8), b2)
		local signers_name
		signers_name, i = mod.string_to_domain_name(s, i + 18)
		local signature = s:sub(i, end_ - 1)
		return {
			type_covered = type_covered, algorithm = algorithm, labels = labels, original_ttl = original_ttl,
			signature_expiration = signature_expiration, signature_inception = signature_inception, key_tag = key_tag,
			signers_name = signers_name, signature = signature,
		}, end_
	end,
	--[[https://www.rfc-editor.org/rfc/rfc4034#section-4]]
	[mod.type.NSEC] = function (s, i, length) --[[@param s string]]
		i = i or 1
		local end_ = i + length
		local next_domain_name
		next_domain_name, i = mod.string_to_domain_name(s, i)
		local types = {}
		while i < end_ do
			local upper_bits = lshift(s:byte(i), 8)
			local length2 = s:byte(i + 1)
			if length2 == 0 then break end
			i = i + 2
			for j = 0, length2 - 1 do
				local type_start = bor(upper_bits, lshift(j, 3))
				local n = s:byte(i + j)
				if n ~= 0 then
					if band(n, 0x80) ~= 0 then types[#types+1] = type_start + 0 end
					if band(n, 0x40) ~= 0 then types[#types+1] = type_start + 1 end
					if band(n, 0x20) ~= 0 then types[#types+1] = type_start + 2 end
					if band(n, 0x10) ~= 0 then types[#types+1] = type_start + 3 end
					if band(n, 0x08) ~= 0 then types[#types+1] = type_start + 4 end
					if band(n, 0x04) ~= 0 then types[#types+1] = type_start + 5 end
					if band(n, 0x02) ~= 0 then types[#types+1] = type_start + 6 end
					if band(n, 0x01) ~= 0 then types[#types+1] = type_start + 7 end
				end
			end
			i = i + length2
		end
		return { next_domain_name = next_domain_name, types = types }, end_
	end,
	--[[https://www.rfc-editor.org/rfc/rfc4034#section-2]]
	[mod.type.DNSKEY] = function (s, i, length)
		i = i or 1
		local b1, b2 = s:byte(i, i + 1)
		local flags = bor(lshift(b1, 8), b2)
		return {
			is_zone_key = band(flags, 0x0100) ~= 0, is_secure_entry_point = band(flags, 0x0001) ~= 0,
			protocol = s:byte(i + 2), --[[for backward compatibility only. MUST be 3.]]
			algorithm = s:byte(i + 3),
			public_key = s:sub(i + 4, i + length - 1),
		}, i + length
	end,
}

--[[https://www.rfc-editor.org/rfc/rfc4034#appendix-A.1]]
--[[@enum dnssec_algorithm]]
mod.dnssec_algorithm = {
	RSAMD5 = 1, --[[RSA/MD5. NOT RECOMMENDED. - see RFC2537]]
	DH = 2, --[[Diffie-Hellman - see RFC2539]]
	DSA = 3, --[[DSA/SHA-1. OPTIONAL. - see RFC2536]]
	ECC = 4, --[[Elliptic Curve]]
	RSASHA1 = 5, --[[RSA/SHA-1. MANDATORY. - see RFC3110]]
	INDIRECT = 252,
	PRIVATEDNS = 253, --[[algorithm depends on domain name. OPTIONAL.]]
	PRIVATEOID = 254, --[[length byte + BER encoded ISO OID + algorithm data. OPTIONAL.]]
}
--[[@type table<dnssec_algorithm, string>]]
mod.dnssec_algorithm_name = {}
for k, v in pairs(mod.dnssec_algorithm) do mod.dnssec_algorithm_name[v] = k end

--[[https://www.rfc-editor.org/rfc/rfc4034#appendix-A.2]]
--[[@enum dnssec_digest_type]]
mod.dnssec_digest_type = {
	["SHA-1"] = 1, --[[MANDATORY]]
}
--[[@type table<dnssec_digest_type, string>]]
mod.dnssec_digest_type_name = {}

-- TODO: mod.encoders

-- 3.2.4
--[[@enum dns_class]]
mod.class = {
	IN = 1, --[[the Internet]]
	CS = 2, --[[the CSNET class (Obsolete - used only for examples in some obsolete RFCs)]]
	CH = 3, --[[the CHAOS class]]
	HS = 4, --[[Hesiod [Dyer 87]]
}
--[[@type table<dns_class, string>]]
mod.class_name = {}
for k, v in pairs(mod.class) do mod.class_name[v] = k end

--[[@enum dns_opcode]]
mod.opcode = {
	QUERY = 0, --[[a standard query]]
	IQUERY = 1, --[[an inverse query]]
	STATUS = 2, --[[a server status request]]
}
--[[@type table<dns_opcode, string>]]
mod.opcode_name = {}
for k, v in pairs(mod.opcode) do mod.opcode_name[v] = k end

-- unofficial names
--[[@enum dns_response_code]]
mod.response_code = { OK = 0, EINVAL = 1, ESERVFAIL = 2, ENAME = 3, ENOTIMPL = 4, EREFUSED = 5 }
--[[@type table<dns_response_code, string>]]
mod.response_code_name = {}
for k, v in pairs(mod.response_code) do mod.response_code_name[v] = k end

-- TODO: encoding queries, using compression

-- remember all names must end with the root ("")
--[[@param msg dns_message]]
mod.dns_message_to_string = function (msg)
	local question_count = #(msg.questions or empty_table)
	local answer_count = #(msg.answers or empty_table)
	local nameserver_count = #(msg.nameservers or empty_table)
	local additional_count = #(msg.additional or empty_table)
	local parts = {}
	local i = 1
	local next = char(
		rshift(msg.id or 0, 8), band(msg.id or 0, 0xff),
		bor(
			(msg.is_response or (msg.is_query == false)) and 0x80 or 0,
			lshift(msg.opcode or mod.opcode.QUERY, 3),
			msg.is_authoritative and 0x4 or 0,
			msg.is_truncated and 0x2 or 0,
			msg.is_recursion_desired and 0x1 or 0
		),
		bor(msg.is_recursion_available and 0x80 or 0, msg.response_code or 0),
		rshift(question_count, 8), band(question_count, 0xff),
		rshift(answer_count, 8), band(answer_count, 0xff),
		rshift(nameserver_count, 8), band(nameserver_count, 0xff),
		rshift(additional_count, 8), band(additional_count, 0xff)
	)
	parts[#parts+1] = next
	i = i + #next
	for _, q in ipairs(msg.questions or empty_table) do
		local parts2 = {}
		for _, part in ipairs(q.name) do
			assert(#part <= 0x3f, "dns_message_to_string: name part too long")
			parts2[#parts2+1] = char(#part) .. part
		end
		parts2[#parts2+1] = char(rshift(q.type, 8), band(q.type, 0xff), rshift(q.class, 8), band(q.class, 0xff))
		next = concat(parts2)
		parts[#parts+1] = next
		i = i + #next
	end
	local name_cache = {} --[[@type table<string, integer>]]
	for _, resources in ipairs({ msg.answers, msg.nameservers, msg.additional }) do
		for _, res in ipairs(resources) do
			local parts2 = {}
			local name_rest = concat(res.name, ".")
			local j = i
			for _, part in ipairs(res.name) do
				assert(#part <= 0x3f, "dns_message_to_string: name part too long")
				local cached_i = name_cache[name_rest]
				if cached_i then
					parts2[#parts2+1] = char(bor(0xc0, rshift(cached_i, 8)), band(cached_i, 0xff))
					break
				else
					name_cache[name_rest] = j - 1
					parts2[#parts2+1] = char(#part) .. part
				end
				j = j + #part + 1
				name_rest = sub(name_rest, #part + 1)
			end
			local length = #res.data
			parts2[#parts2+1] = char(
				rshift(res.type, 8), band(res.type, 0xff), rshift(res.class, 8), band(res.class, 0xff),
				rshift(res.ttl, 24), band(rshift(res.ttl, 16), 0xff), band(rshift(res.ttl, 8), 0xff), band(res.ttl, 0xff),
				rshift(length, 8), band(length, 0xff)
			)
			next = concat(parts2)
			parts[#parts+1] = next
			i = i + #next
			parts[#parts+1] = res.data
			i = i + length
		end
	end
	return concat(parts)
end

--[[@param s string]]
mod.string_to_dns_message = function (s)
	assert(#s >= 12, "string_to_dns_message: message too short, length was " .. #s)
	--[[@class dns_message]]
	local ret = {}
	local b1, b2
	b1, b2 = byte(s, 1, 2)
	ret.id = bor(lshift(b1, 8), b2)
	b1 = byte(s, 3)
	local qr = band(b1, 0x80)
	ret.is_query = qr == 0
	ret.is_response = qr ~= 0
	ret.opcode = band(rshift(b1, 3), 0xf) --[[@type dns_opcode]]
	ret.is_authoritative = band(b1, 0x4) ~= 0
	ret.is_truncated = band(b1, 0x2) ~= 0
	ret.is_recursion_desired = band(b1, 0x1) ~= 0
	b1 = byte(s, 4) -- LINT: sequential, consecutive byte()
	ret.is_recursion_available = band(b1, 0x80) ~= 0
	-- band(b, 0x70) must be 0 - we will ignore

	ret.response_code = band(b1, 0xf) --[[@type dns_response_code]]
	b1, b2 = byte(s, 5, 6)
	-- LINT: unconditional reassignment without usage of previous value
	-- and unconditional reassignment in general
	local question_count = bor(lshift(b1, 8), b2) -- usually 1
	b1, b2 = byte(s, 7, 8)
	local answer_count = bor(lshift(b1, 8), b2)
	b1, b2 = byte(s, 9, 10)
	local nameserver_count = bor(lshift(b1, 8), b2)
	b1, b2 = byte(s, 11, 12)
	local additional_count = bor(lshift(b1, 8), b2)
	local i = 13
	local questions = {} --[[@type dns_question[] ]]
	local b3, b4
	for j = 1, question_count do
		local parts = {} --[[@type string[] ]]
		local length = byte(s, i)
		while length > 0 do
			parts[#parts+1] = sub(s, i + 1, i + length)
			i = i + length + 1
			length = byte(s, i)
		end
		parts[#parts+1] = ""
		b1, b2, b3, b4 = byte(s, i + 1, i + 4)
		-- LINT: linear values - @usages 1, @usages 2, @maxusages 1
		--[[@class dns_question]]
		questions[j] = {
			name = parts,
			type = bor(lshift(b1, 8), b2), --[[@type dns_type]]
			class = bor(lshift(b3, 8), b4), --[[@type dns_class]]
		}
		i = i + 5
	end
	ret.questions = questions
	local resources = { {}, {}, {} } --[[@type dns_resource[][] ]]
	for j, count in ipairs({ answer_count, nameserver_count, additional_count }) do
		local arr = resources[j]
		for k = 1, count do
			local parts
			parts, i = mod.string_to_domain_name(s, i)
			b1, b2, b3, b4 = byte(s, i, i + 3)
			local type = bor(lshift(b1, 8), b2)
			local class = bor(lshift(b3, 8), b4)
			b1, b2, b3, b4 = byte(s, i + 4, i + 7)
			local ttl = bor(lshift(b1, 24), lshift(b2, 16), lshift(b3, 8), b4)
			if bit.band(ttl, 0x80000000) ~= 0 then ttl = ttl - 0x100000000 end
			b1, b2 = byte(s, i + 8, i + 9)
			local length = bor(lshift(b1, 8), b2)
			local data_i = i + 10
			i = data_i + length
			--[[@class dns_resource]]
			arr[k] = {
				name = parts,
				type = type, --[[@type dns_type]]
				class = class, --[[@type dns_class]]
				ttl = ttl, data = mod.decoders[type] and mod.decoders[type](s, data_i, length) or s:sub(data_i, data_i + length - 1),
			}
		end
	end
	ret.answers, ret.nameservers, ret.additional = resources[1], resources[2], resources[3]
	return ret
end

return mod

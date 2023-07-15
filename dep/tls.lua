local ffi = require("ffi")

--[[TODO: better typings]]
--[[@type table<string, function>]]
local tls_c = assert(ffi.load("tls"))
ffi.cdef [[
	struct tls {};
	struct tls_config {};
	const char* tls_peer_ocsp_url(struct tls*);
	int tls_config_set_dheparams(struct tls_config*, const char*);
	int tls_config_set_keypair_file(struct tls_config*, const char*, const char*);
	const char* tls_conn_version(struct tls*);
	int tls_conn_session_resumed(struct tls*);
	int tls_config_set_ca_file(struct tls_config*, const char*);
	int tls_config_set_ciphers(struct tls_config*, const char*);
	int tls_ocsp_process_response(struct tls*, const unsigned char*, unsigned long);
	int tls_peer_ocsp_cert_status(struct tls*);
	void tls_config_insecure_noverifytime(struct tls_config*);
	int tls_config_add_keypair_mem(struct tls_config*, const unsigned char*, unsigned long, const unsigned char*, unsigned long);
	int tls_config_set_cert_mem(struct tls_config*, const unsigned char*, unsigned long);
	const char* tls_config_error(struct tls_config*);
	int tls_config_set_ocsp_staple_file(struct tls_config*, const char*);
	const char* tls_peer_ocsp_result(struct tls*);
	void tls_config_verify_client(struct tls_config*);
	int tls_config_add_keypair_ocsp_mem(struct tls_config*, const unsigned char*, unsigned long, const unsigned char*, unsigned long, const unsigned char*, unsigned long);
	int tls_connect_cbs(struct tls*, long (*_read_cb)(struct tls*, void*, unsigned long, void*), long (*_write_cb)(struct tls*, const void*, unsigned long, void*), void*, const char*);
	struct tls_config* tls_config_new();
	void tls_config_insecure_noverifycert(struct tls_config*);
	int tls_config_set_key_file(struct tls_config*, const char*);
	long tls_peer_ocsp_next_update(struct tls*);
	int tls_config_set_cert_file(struct tls_config*, const char*);
	int tls_handshake(struct tls*);
	struct tls* tls_server();
	int tls_config_set_crl_mem(struct tls_config*, const unsigned char*, unsigned long);
	void tls_config_ocsp_require_stapling(struct tls_config*);
	int tls_config_parse_protocols(unsigned int*, const char*);
	void tls_config_verify_client_optional(struct tls_config*);
	void tls_config_verify(struct tls_config*);
	int tls_config_set_alpn(struct tls_config*, const char*);
	int tls_connect_fds(struct tls*, int, int, const char*);
	void tls_config_free(struct tls_config*);
	int tls_config_set_ocsp_staple_mem(struct tls_config*, const unsigned char*, unsigned long);
	void tls_free(struct tls*);
	int tls_config_set_verify_depth(struct tls_config*, int);
	int tls_config_set_ecdhecurve(struct tls_config*, const char*);
	long tls_peer_ocsp_this_update(struct tls*);
	long tls_peer_ocsp_revocation_time(struct tls*);
	const char* tls_conn_cipher(struct tls*);
	int tls_peer_ocsp_response_status(struct tls*);
	void tls_unload_file(unsigned char*, unsigned long);
	int tls_connect(struct tls*, const char*, const char*);
	int tls_peer_ocsp_crl_reason(struct tls*);
	unsigned char* tls_load_file(const char*, unsigned long*, char*);
	const char* tls_default_ca_cert_file();
	const char* tls_conn_alpn_selected(struct tls*);
	const char* tls_peer_cert_hash(struct tls*);
	int tls_config_add_ticket_key(struct tls_config*, unsigned int, unsigned char*, unsigned long);
	int tls_config_set_ecdhecurves(struct tls_config*, const char*);
	void tls_config_prefer_ciphers_client(struct tls_config*);
	int tls_accept_fds(struct tls*, struct tls**, int, int);
	long tls_peer_cert_notafter(struct tls*);
	long tls_peer_cert_notbefore(struct tls*);
	int tls_peer_cert_provided(struct tls*);
	int tls_accept_cbs(struct tls*, struct tls**, long (*_read_cb)(struct tls*, void*, unsigned long, void*), long (*_write_cb)(struct tls*, const void*, unsigned long, void*), void*);
	const char* tls_peer_cert_subject(struct tls*);
	int tls_config_add_keypair_ocsp_file(struct tls_config*, const char*, const char*, const char*);
	int tls_accept_socket(struct tls*, struct tls**, int);
	const char* tls_peer_cert_issuer(struct tls*);
	int tls_init();
	int tls_peer_cert_contains_name(struct tls*, const char*);
	int tls_connect_servername(struct tls*, const char*, const char*, const char*);
	const char* tls_error(struct tls*);
	int tls_close(struct tls*);
	long tls_write(struct tls*, const void*, unsigned long);
	long tls_read(struct tls*, void*, unsigned long);
	int tls_connect_socket(struct tls*, int, const char*);
	int tls_config_set_crl_file(struct tls_config*, const char*);
	struct tls* tls_client();
	int tls_configure(struct tls*, struct tls_config*);
	int tls_config_set_keypair_mem(struct tls_config*, const unsigned char*, unsigned long, const unsigned char*, unsigned long);
	int tls_config_set_ca_path(struct tls_config*, const char*);
	void tls_config_insecure_noverifyname(struct tls_config*);
	const char* tls_conn_servername(struct tls*);
	int tls_config_set_keypair_ocsp_mem(struct tls_config*, const unsigned char*, unsigned long, const unsigned char*, unsigned long, const unsigned char*, unsigned long);
	int tls_config_add_keypair_file(struct tls_config*, const char*, const char*);
	int tls_config_set_protocols(struct tls_config*, unsigned int);
	void tls_reset(struct tls*);
	int tls_config_set_key_mem(struct tls_config*, const unsigned char*, unsigned long);
	const unsigned char* tls_peer_cert_chain_pem(struct tls*, unsigned long*);
	int tls_config_set_session_lifetime(struct tls_config*, int);
	int tls_config_set_keypair_ocsp_file(struct tls_config*, const char*, const char*, const char*);
	void tls_config_prefer_ciphers_server(struct tls_config*);
	int tls_config_set_ca_mem(struct tls_config*, const unsigned char*, unsigned long);
	int tls_config_set_session_id(struct tls_config*, const unsigned char*, unsigned long);
	int tls_config_set_session_fd(struct tls_config*, int);
	void tls_config_clear_keys(struct tls_config*);
]]

--[[@class tls_config_c]]
--[[@class tls_c]]

--[[@type fun(): { [0]: tls_c }]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local tls_c_ptr = ffi.typeof("struct tls*[1]")

--[[FIXME: wrap returned strings in ffi.string]]
local library = {
	--[[@type fun(tls: tls_c): string_c]]
	peer_ocsp_url = tls_c.tls_peer_ocsp_url,
	--[[@type fun(config: tls_config_c, params: string): error_c]]
	config_set_dheparams = tls_c.tls_config_set_dheparams,
	--[[@type fun(config: tls_config_c, cert_file: string, key_file: string): error_c]]
	config_set_keypair_file = tls_c.tls_config_set_keypair_file,
	--[[@type fun(tls: tls_c): string_c]]
	conn_version = tls_c.tls_conn_version,
	--[[@type fun(tls: tls_c): error_c]]
	conn_session_resumed = tls_c.tls_conn_session_resumed,
	--[[@type fun(config: tls_config_c, ca_file: string): error_c]]
	config_set_ca_file = tls_c.tls_config_set_ca_file,
	--[[@type fun(config: tls_config_c, ciphers: string): error_c]]
	config_set_ciphers = tls_c.tls_config_set_ciphers,
	--[[@type fun(tls: tls_c, response: string, size: integer): error_c]]
	ocsp_process_response = tls_c.tls_ocsp_process_response,
	--[[@type fun(tls: tls_c): error_c]]
	peer_ocsp_cert_status = tls_c.tls_peer_ocsp_cert_status,
	config_insecure_noverifytime = tls_c.tls_config_insecure_noverifytime,
	config_add_keypair_mem = tls_c.tls_config_add_keypair_mem,
	config_set_cert_mem = tls_c.tls_config_set_cert_mem,
	config_error = tls_c.tls_config_error,
	config_set_ocsp_staple_file = tls_c.tls_config_set_ocsp_staple_file,
	peer_ocsp_result = tls_c.tls_peer_ocsp_result,
	__debugbreak = tls_c.__debugbreak,
	config_verify_client = tls_c.tls_config_verify_client,
	config_add_keypair_ocsp_mem = tls_c.tls_config_add_keypair_ocsp_mem,
	connect_cbs = tls_c.tls_connect_cbs,
	--[[@type fun(): tls_config_c]]
	config_new = tls_c.tls_config_new,
	config_insecure_noverifycert = tls_c.tls_config_insecure_noverifycert,
	--[[@type fun(config: tls_config_c, key_file: string): error_c]]
	config_set_key_file = tls_c.tls_config_set_key_file,
	peer_ocsp_next_update = tls_c.tls_peer_ocsp_next_update,
	--[[@type fun(config: tls_config_c, cert_file: string): error_c]]
	config_set_cert_file = tls_c.tls_config_set_cert_file,
	handshake = tls_c.tls_handshake,
	--[[@type fun(): tls_c]]
	server = tls_c.tls_server,
	config_set_crl_mem = tls_c.tls_config_set_crl_mem,
	config_ocsp_require_stapling = tls_c.tls_config_ocsp_require_stapling,
	config_parse_protocols = tls_c.tls_config_parse_protocols,
	config_verify_client_optional = tls_c.tls_config_verify_client_optional,
	config_verify = tls_c.tls_config_verify,
	config_set_alpn = tls_c.tls_config_set_alpn,
	connect_fds = tls_c.tls_connect_fds,
	--[[@type fun(config: tls_config_c)]]
	config_free = tls_c.tls_config_free,
	config_set_ocsp_staple_mem = tls_c.tls_config_set_ocsp_staple_mem,
	--[[@type fun(tls: tls_c)]]
	free = tls_c.tls_free,
	config_set_verify_depth = tls_c.tls_config_set_verify_depth,
	config_set_ecdhecurve = tls_c.tls_config_set_ecdhecurve,
	_errno = tls_c._errno,
	peer_ocsp_this_update = tls_c.tls_peer_ocsp_this_update,
	peer_ocsp_revocation_time = tls_c.tls_peer_ocsp_revocation_time,
	conn_cipher = tls_c.tls_conn_cipher,
	peer_ocsp_response_status = tls_c.tls_peer_ocsp_response_status,
	unload_file = tls_c.tls_unload_file,
	connect = tls_c.tls_connect,
	peer_ocsp_crl_reason = tls_c.tls_peer_ocsp_crl_reason,
	load_file = tls_c.tls_load_file,
	default_ca_cert_file = tls_c.tls_default_ca_cert_file,
	__threadhandle = tls_c.__threadhandle,
	conn_alpn_selected = tls_c.tls_conn_alpn_selected,
	peer_cert_hash = tls_c.tls_peer_cert_hash,
	config_add_ticket_key = tls_c.tls_config_add_ticket_key,
	config_set_ecdhecurves = tls_c.tls_config_set_ecdhecurves,
	config_prefer_ciphers_client = tls_c.tls_config_prefer_ciphers_client,
	accept_fds = tls_c.tls_accept_fds,
	peer_cert_notafter = tls_c.tls_peer_cert_notafter,
	peer_cert_notbefore = tls_c.tls_peer_cert_notbefore,
	peer_cert_provided = tls_c.tls_peer_cert_provided,
	accept_cbs = tls_c.tls_accept_cbs,
	peer_cert_subject = tls_c.tls_peer_cert_subject,
	config_add_keypair_ocsp_file = tls_c.tls_config_add_keypair_ocsp_file,
	--[[@type fun(tls: tls_c, cctx: { [0]: tls_c }, socket: fd_c): error_c]]
	accept_socket = tls_c.tls_accept_socket,
	peer_cert_issuer = tls_c.tls_peer_cert_issuer,
	--[[@type fun(): error_c]]
	init = tls_c.tls_init,
	peer_cert_contains_name = tls_c.tls_peer_cert_contains_name,
	connect_servername = tls_c.tls_connect_servername,
	--[[@type fun(tls: tls_c): string_c]]
	error = tls_c.tls_error,
	--[[@type fun(tls: tls_c): error_c]]
	close = tls_c.tls_close,
	--[[@type fun(tls: tls_c, buf: string, buflen: integer): integer]]
	write = tls_c.tls_write,
	--[[@type fun(tls: tls_c, buf: string_c, buflen: integer): integer]]
	read = tls_c.tls_read,
	connect_socket = tls_c.tls_connect_socket,
	config_set_crl_file = tls_c.tls_config_set_crl_file,
	--[[@type fun(): tls_c]]
	client = tls_c.tls_client,
	--[[@type fun(tls: tls_c, config: tls_config_c): error_c]]
	configure = tls_c.tls_configure,
	_set_errno = tls_c._set_errno,
	config_set_keypair_mem = tls_c.tls_config_set_keypair_mem,
	_get_errno = tls_c._get_errno,
	config_set_ca_path = tls_c.tls_config_set_ca_path,
	config_insecure_noverifyname = tls_c.tls_config_insecure_noverifyname,
	conn_servername = tls_c.tls_conn_servername,
	config_set_keypair_ocsp_mem = tls_c.tls_config_set_keypair_ocsp_mem,
	config_add_keypair_file = tls_c.tls_config_add_keypair_file,
	config_set_protocols = tls_c.tls_config_set_protocols,
	--[[@type fun(tls: tls_c)]]
	reset = tls_c.tls_reset,
	config_set_key_mem = tls_c.tls_config_set_key_mem,
	peer_cert_chain_pem = tls_c.tls_peer_cert_chain_pem,
	config_set_session_lifetime = tls_c.tls_config_set_session_lifetime,
	config_set_keypair_ocsp_file = tls_c.tls_config_set_keypair_ocsp_file,
	__mingw_get_crt_info = tls_c.__mingw_get_crt_info,
	config_prefer_ciphers_server = tls_c.tls_config_prefer_ciphers_server,
	__threadid = tls_c.__threadid,
	config_set_ca_mem = tls_c.tls_config_set_ca_mem,
	config_set_session_id = tls_c.tls_config_set_session_id,
	config_set_session_fd = tls_c.tls_config_set_session_fd,
	--[[@type fun(tls: tls_c)]]
	config_clear_keys = tls_c.tls_config_clear_keys,

	tls_c_ptr = tls_c_ptr,
}
library.e = {
	HEADER_TLS_H = 1,
	TLS_API = 20180210,
	TLS_PROTOCOL_TLSv1_0 = 2,
	TLS_PROTOCOL_TLSv1_1 = 4,
	TLS_PROTOCOL_TLSv1_2 = 8,
	TLS_PROTOCOLS_DEFAULT = 8,
	TLS_WANT_POLLIN = -2,
	TLS_WANT_POLLOUT = -3,
	TLS_OCSP_RESPONSE_SUCCESSFUL = 0,
	TLS_OCSP_RESPONSE_MALFORMED = 1,
	TLS_OCSP_RESPONSE_INTERNALERROR = 2,
	TLS_OCSP_RESPONSE_TRYLATER = 3,
	TLS_OCSP_RESPONSE_SIGREQUIRED = 4,
	TLS_OCSP_RESPONSE_UNAUTHORIZED = 5,
	TLS_OCSP_CERT_GOOD = 0,
	TLS_OCSP_CERT_REVOKED = 1,
	TLS_OCSP_CERT_UNKNOWN = 2,
	TLS_CRL_REASON_UNSPECIFIED = 0,
	TLS_CRL_REASON_KEY_COMPROMISE = 1,
	TLS_CRL_REASON_CA_COMPROMISE = 2,
	TLS_CRL_REASON_AFFILIATION_CHANGED = 3,
	TLS_CRL_REASON_SUPERSEDED = 4,
	TLS_CRL_REASON_CESSATION_OF_OPERATION = 5,
	TLS_CRL_REASON_CERTIFICATE_HOLD = 6,
	TLS_CRL_REASON_REMOVE_FROM_CRL = 8,
	TLS_CRL_REASON_PRIVILEGE_WITHDRAWN = 9,
	TLS_CRL_REASON_AA_COMPROMISE = 10,
	TLS_MAX_SESSION_ID_LENGTH = 32,
	TLS_TICKET_KEY_SIZE = 48,
}
return library

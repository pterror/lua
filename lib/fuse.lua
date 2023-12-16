local ffi = require("ffi")

ffi.cdef [[
	struct fuse;
	enum fuse_readdir_flags { FUSE_READDIR_PLUS = (1 << 0) };
	enum fuse_fill_dir_flags { FUSE_FILL_DIR_PLUS = (1 << 1) };
	typedef int (*fuse_fill_dir_t)(void *buf, const char *name, const struct stat *stbuf, off_t off, enum fuse_fill_dir_flags flags);

	struct fuse_config {
		int set_gid;
		unsigned int gid;
		int set_uid;
		unsigned int uid;
		int set_mode;
		unsigned int umask;
		double entry_timeout;
		double negative_timeout;
		double attr_timeout;
		int intr;
		int intr_signal;
		int remember;
		int hard_remove;
		int use_ino;
		int readdir_ino;
		int direct_io;
		int kernel_cache;
		int auto_cache;
		int no_rofd_flush;
		int ac_attr_timeout_set;
		double ac_attr_timeout;
		int nullpath_ok;
		int parallel_direct_writes;
		int show_help;
		char *modules;
		int debug;
	};

	struct fuse_operations {
		int (*getattr)(const char *, struct stat *, info: fuse_file_info_c);
		int (*readlink)(const char *, char *, size_t);
		int (*mknod)(const char *, mode_t, dev_t);
		int (*mkdir)(const char *, mode_t);
		int (*unlink)(const char *);
		int (*rmdir)(const char *);
		int (*symlink)(const char *, const char *);
		int (*rename)(const char *, const char *, unsigned int flags);
		int (*link)(const char *, const char *);
		int (*chmod)(const char *, mode_t, info: fuse_file_info_c);
		int (*chown)(const char *, uid_t, gid_t, info: fuse_file_info_c);
		int (*truncate)(const char *, off_t, info: fuse_file_info_c);
		int (*open)(const char *, info: fuse_file_info_c);
		int (*read)(const char *, char *, size_t, off_t, info: fuse_file_info_c);
		int (*write)(const char *, const char *, size_t, off_t, info: fuse_file_info_c);
		int (*statfs)(const char *, struct statvfs *);
		int (*flush)(const char *, info: fuse_file_info_c);
		int (*release)(const char *, info: fuse_file_info_c);
		int (*fsync)(const char *, datasync: integer, info: fuse_file_info_c);
		int (*setxattr)(const char *, const char *, const char *, size_t, int);
		int (*getxattr)(const char *, const char *, char *, size_t);
		int (*listxattr)(const char *, char *, size_t);
		int (*removexattr)(const char *, const char *);
		int (*opendir)(const char *, info: fuse_file_info_c);
		int (*readdir)(const char *, void *, fuse_fill_dir_t, off_t, info: fuse_file_info_c, enum fuse_readdir_flags);
		int (*releasedir)(const char *, info: fuse_file_info_c);
		int (*fsyncdir)(const char *, datasync: integer, info: fuse_file_info_c);
		void *(*init)(struct fuse_conn_info *conn, struct fuse_config *cfg);
		void (*destroy)(void *private_data);
		int (*access)(const char *, int);
		int (*create)(const char *, mode_t, info: fuse_file_info_c);
		int (*lock)(const char *, info: fuse_file_info_c, int cmd, struct flock *);
		int (*utimens)(const char *, const struct timespec tv[2], info: fuse_file_info_c);
		int (*bmap)(const char *, size_t blocksize, uint64_t *idx);
		//#if FUSE_USE_VERSION < 35
		//int (*ioctl)(const char *, int cmd, void *arg, info: fuse_file_info_c, unsigned int flags, void *data);
		//#else
		int (*ioctl)(const char *, unsigned int cmd, void *arg, info: fuse_file_info_c, unsigned int flags, void *data);
		//#endif
		int (*poll)(const char *, info: fuse_file_info_c, struct fuse_pollhandle *ph, unsigned *reventsp);
		int (*write_buf)(const char *, struct fuse_bufvec *buf, off_t off, info: fuse_file_info_c);
		int (*read_buf)(const char *, struct fuse_bufvec **bufp, size_t size, off_t off, info: fuse_file_info_c);
		int (*flock)(const char *, info: fuse_file_info_c, int op);
		int (*fallocate)(const char *, datasync: integer, off_t, off_t, info: fuse_file_info_c);
		ssize_t (*copy_file_range)(const char *path_in, info: fuse_file_info_c_in, off_t offset_in, const char *path_out, info: fuse_file_info_c_out, off_t offset_out, size_t size, int flags);
		off_t (*lseek)(const char *, off_t off, int whence, info: fuse_file_info_c);
	};

	struct fuse_context {
		struct fuse *fuse;
		uid_t uid;
		gid_t gid;
		pid_t pid;
		void *private_data;
		mode_t umask;
	};

	/*
					int fuse_main(int argc, char *argv[], const struct fuse_operations *op, void *private_data);
	*/
	//#define fuse_main(argc, argv, op, private_data) fuse_main_real(argc, argv, op, sizeof(*(op)), private_data)


	void fuse_lib_help(struct fuse_args *args);

	//#if FUSE_USE_VERSION == 30
	struct fuse *fuse_new_30(struct fuse_args *args, const struct fuse_operations *op, size_t op_size, void *private_data);
	//#define fuse_new(args, op, size, data) fuse_new_30(args, op, size, data)
	//#else
	//#if (defined(LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS))
	struct fuse *fuse_new(struct fuse_args *args, const struct fuse_operations *op, size_t op_size, void *private_data);
	//#else /* LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS */
	struct fuse *fuse_new_31(struct fuse_args *args, const struct fuse_operations *op, size_t op_size, void *private_data);
	//#define fuse_new(args, op, size, data) fuse_new_31(args, op, size, data)
	//#endif /* LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS */
	//#endif

	int fuse_mount(struct fuse *f, const char *mountpoint);
	void fuse_unmount(struct fuse *f);
	void fuse_destroy(struct fuse *f);
	int fuse_loop(struct fuse *f);
	void fuse_exit(struct fuse *f);

	//#if FUSE_USE_VERSION < 32
	int fuse_loop_mt_31(struct fuse *f, int clone_fd);
	//#define fuse_loop_mt(f, clone_fd) fuse_loop_mt_31(f, clone_fd)
	//#elif FUSE_USE_VERSION < FUSE_MAKE_VERSION(3, 12)
	int fuse_loop_mt_32(struct fuse *f, struct fuse_loop_config *config);
	//#define fuse_loop_mt(f, config) fuse_loop_mt_32(f, config)
	//#else
	//#if (defined(LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS))
	int fuse_loop_mt(struct fuse *f, struct fuse_loop_config *config);
	//#else
	//#define fuse_loop_mt(f, config) fuse_loop_mt_312(f, config)
	//#endif /* LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS */
	//#endif

	struct fuse_context *fuse_get_context(void);

	int fuse_getgroups(int size, gid_t list[]);
	int fuse_interrupted(void);
	int fuse_invalidate_path(struct fuse *f, const char *path);
	int fuse_main_real(int argc, char *argv[], const struct fuse_operations *op, size_t op_size, void *private_data);
	int fuse_start_cleanup_thread(struct fuse *fuse);
	void fuse_stop_cleanup_thread(struct fuse *fuse);
	int fuse_clean_cache(struct fuse *fuse);

	struct fuse_fs;

	/*
	 * These functions call the relevant filesystem operation, and return
	 * the result.
	 *
	 * If the operation is not defined, they return -ENOSYS, with the
	 * exception of fuse_fs_open, fuse_fs_release, fuse_fs_opendir, * fuse_fs_releasedir and fuse_fs_statfs, which return 0.
	 */

	int fuse_fs_getattr(struct fuse_fs *fs, const char *path, struct stat *buf, info: fuse_file_info_c);
	int fuse_fs_rename(struct fuse_fs *fs, const char *oldpath, const char *newpath, unsigned int flags);
	int fuse_fs_unlink(struct fuse_fs *fs, const char *path);
	int fuse_fs_rmdir(struct fuse_fs *fs, const char *path);
	int fuse_fs_symlink(struct fuse_fs *fs, const char *linkname, const char *path);
	int fuse_fs_link(struct fuse_fs *fs, const char *oldpath, const char *newpath);
	int fuse_fs_release(struct fuse_fs *fs, const char *path, info: fuse_file_info_c);
	int fuse_fs_open(struct fuse_fs *fs, const char *path, info: fuse_file_info_c);
	int fuse_fs_read(struct fuse_fs *fs, const char *path, char *buf, size_t size, off_t off, info: fuse_file_info_c);
	int fuse_fs_read_buf(struct fuse_fs *fs, const char *path, struct fuse_bufvec **bufp, size_t size, off_t off, info: fuse_file_info_c);
	int fuse_fs_write(struct fuse_fs *fs, const char *path, const char *buf, size_t size, off_t off, info: fuse_file_info_c);
	int fuse_fs_write_buf(struct fuse_fs *fs, const char *path, struct fuse_bufvec *buf, off_t off, info: fuse_file_info_c);
	int fuse_fs_fsync(struct fuse_fs *fs, const char *path, int datasync, info: fuse_file_info_c);
	int fuse_fs_flush(struct fuse_fs *fs, const char *path, info: fuse_file_info_c);
	int fuse_fs_statfs(struct fuse_fs *fs, const char *path, struct statvfs *buf);
	int fuse_fs_opendir(struct fuse_fs *fs, const char *path, info: fuse_file_info_c);
	int fuse_fs_readdir(struct fuse_fs *fs, const char *path, void *buf, fuse_fill_dir_t filler, off_t off, info: fuse_file_info_c, enum fuse_readdir_flags flags);
	int fuse_fs_fsyncdir(struct fuse_fs *fs, const char *path, int datasync, info: fuse_file_info_c);
	int fuse_fs_releasedir(struct fuse_fs *fs, const char *path, info: fuse_file_info_c);
	int fuse_fs_create(struct fuse_fs *fs, const char *path, mode_t mode, info: fuse_file_info_c);
	int fuse_fs_lock(struct fuse_fs *fs, const char *path, info: fuse_file_info_c, int cmd, struct flock *lock);
	int fuse_fs_flock(struct fuse_fs *fs, const char *path, info: fuse_file_info_c, int op);
	int fuse_fs_chmod(struct fuse_fs *fs, const char *path, mode_t mode, info: fuse_file_info_c);
	int fuse_fs_chown(struct fuse_fs *fs, const char *path, uid_t uid, gid_t gid, info: fuse_file_info_c);
	int fuse_fs_truncate(struct fuse_fs *fs, const char *path, off_t size, info: fuse_file_info_c);
	int fuse_fs_utimens(struct fuse_fs *fs, const char *path, const struct timespec tv[2], info: fuse_file_info_c);
	int fuse_fs_access(struct fuse_fs *fs, const char *path, int mask);
	int fuse_fs_readlink(struct fuse_fs *fs, const char *path, char *buf, size_t len);
	int fuse_fs_mknod(struct fuse_fs *fs, const char *path, mode_t mode, dev_t rdev);
	int fuse_fs_mkdir(struct fuse_fs *fs, const char *path, mode_t mode);
	int fuse_fs_setxattr(struct fuse_fs *fs, const char *path, const char *name, const char *value, size_t size, int flags);
	int fuse_fs_getxattr(struct fuse_fs *fs, const char *path, const char *name, char *value, size_t size);
	int fuse_fs_listxattr(struct fuse_fs *fs, const char *path, char *list, size_t size);
	int fuse_fs_removexattr(struct fuse_fs *fs, const char *path, const char *name);
	int fuse_fs_bmap(struct fuse_fs *fs, const char *path, size_t blocksize, uint64_t *idx);
	//#if FUSE_USE_VERSION < 35
	//int fuse_fs_ioctl(struct fuse_fs *fs, const char *path, int cmd, void *arg, info: fuse_file_info_c, unsigned int flags, void *data);
	//#else
	int fuse_fs_ioctl(struct fuse_fs *fs, const char *path, unsigned int cmd, void *arg, info: fuse_file_info_c, unsigned int flags, void *data);
	//#endif
	int fuse_fs_poll(struct fuse_fs *fs, const char *path, info: fuse_file_info_c, struct fuse_pollhandle *ph, unsigned *reventsp);
	int fuse_fs_fallocate(struct fuse_fs *fs, const char *path, int mode, off_t offset, off_t length, info: fuse_file_info_c);
	ssize_t fuse_fs_copy_file_range(struct fuse_fs *fs, const char *path_in, info: fuse_file_info_c_in, off_t off_in, const char *path_out, info: fuse_file_info_c_out, off_t off_out, size_t len, int flags);
	off_t fuse_fs_lseek(struct fuse_fs *fs, const char *path, off_t off, int whence, info: fuse_file_info_c);
	void fuse_fs_init(struct fuse_fs *fs, struct fuse_conn_info *conn, struct fuse_config *cfg);
	void fuse_fs_destroy(struct fuse_fs *fs);

	int fuse_notify_poll(struct fuse_pollhandle *ph);
	struct fuse_fs *fuse_fs_new(const struct fuse_operations *op, size_t op_size, void *private_data);
	typedef struct fuse_fs *(*fuse_module_factory_t)(struct fuse_args *args, struct fuse_fs *fs[]);
	struct fuse_session *fuse_get_session(struct fuse *f);
	int fuse_open_channel(const char *mountpoint, const char *options);
]]

--[[@class fuse_ffi]]
--[[@field fuse_mount fun(fuse: ptr_c<fuse_c>, mountpoint: string): fuse_error]]
--[[@field fuse_unmount fun(fuse: ptr_c<fuse_c>)]]
--[[@field fuse_destroy fun(fuse: ptr_c<fuse_c>)]]
--[[@field fuse_loop fun(fuse: ptr_c<fuse_c>): fuse_error]]
--[[@field fuse_exit fun(fuse: ptr_c<fuse_c>)]]
--[[@field fuse_fs_new fun(ops: fuse_operations_c, op_size: integer, private_data: ptr_c?): fuse_fs_c]]
--[[@field fuse_get_session fun(fuse: fuse_c): fuse_session_c]]
--[[@field fuse_open_channel fun(mountpoint: string, options: string): fuse_error]]

--[[@type fuse_ffi]]
local fuse_ffi = require("fuse")

--[[@alias fuse_model_factory fun(args: fuse_args_c, fs: fuse_fs_c[]): fuse_fs_c]]
--[[@class fuse_session_c]]
--[[@class fuse_args_c]]
--[[@class fuse_fs_c]]
--[[@class fuse_c]]
--[[@class fuse_conn_info_c]]
--[[@class fuse_file_info_c]]
--[[@class fuse_mode]]
--[[@class fuse_rename_flags]]
--[[@class fuse_copy_flags]]
--[[@class fuse_lock_cmd]]
--[[@class flock_c]]
--[[@class timespec_c]]
--[[@class fuse_ioctl_cmd]]
--[[@class fuse_ioctl_flags]]
--[[@class fuse_config_c]]
--[[@class statvfs_c]]
--[[@class fuse_fill_dir]]
--[[@class fuse_readdir_flags]]
--[[@class fuse_pollhandle_c]]
--[[@class fuse_bufvec_c]]

--[[@class fuse_config_c]]
--[[@field set_gid integer]]
--[[@field gid integer]]
--[[@field set_uid integer]]
--[[@field uid integer]]
--[[@field set_mode integer]]
--[[@field umask integer]]
--[[@field entry_timeout integer]]
--[[@field negative_timeout integer]]
--[[@field attr_timeout integer]]
--[[@field intr integer]]
--[[@field intr_signal integer]]
--[[@field remember integer]]
--[[@field hard_remove integer]]
--[[@field use_ino integer]]
--[[@field readdir_ino integer]]
--[[@field direct_io integer]]
--[[@field kernel_cache integer]]
--[[@field auto_cache integer]]
--[[@field no_rofd_flush integer]]
--[[@field ac_attr_timeout_set integer]]
--[[@field ac_attr_timeout integer]]
--[[@field nullpath_ok integer]]
--[[@field parallel_direct_writes integer]]
--[[@field show_help integer]]
--[[@field modules string]]
--[[@field debug integer]]

--[[@class fuse_context_c]]
--[[@field fuse ptr_c<fuse_c>]]
--[[@field uid integer]]
--[[@field gid integer]]
--[[@field pid integer]]
--[[@field private_data ptr_c]]
--[[@field umask fuse_mode]]

--[[@class fuse_operations_c]]
--[[@field getattr ?fun(path: string_c, out: ptr_c<stat_c>, info: fuse_file_info_c): fuse_error]]
--[[@field readlink ?fun(path: string_c, target: string_c, size: integer): fuse_error]]
--[[@field mknod ?fun(path: string_c, mode_t, dev_t): fuse_error]]
--[[@field mkdir ?fun(path: string_c, mode_t): fuse_error]]
--[[@field unlink ?fun(path: string_c): fuse_error]]
--[[@field rmdir ?fun(path: string_c): fuse_error]]
--[[@field symlink ?fun(source: string_c, target: string_c): fuse_error]]
--[[@field rename ?fun(old_path: string_c, new_path: string_c, flags: fuse_rename_flags): fuse_error]]
--[[@field link ?fun(source: string_c, target: string_c): fuse_error]]
--[[@field chmod ?fun(path: string_c, mode_t, info: fuse_file_info_c): fuse_error]]
--[[@field chown ?fun(path: string_c, uid_t, gid_t, info: fuse_file_info_c): fuse_error]]
--[[@field truncate ?fun(path: string_c, off_t, info: fuse_file_info_c): fuse_error]]
--[[@field open ?fun(path: string_c, info: fuse_file_info_c): fuse_error]]
--[[@field read ?fun(path: string_c, but: string_c, size: integer, offset: integer, info: fuse_file_info_c): fuse_error]]
--[[@field write ?fun(path: string_c, buf: string_c, size: integer, offset: integer, info: fuse_file_info_c): fuse_error]]
--[[@field statfs ?fun(path: string_c, out: ptr_c<statvfs_c>): fuse_error]]
--[[@field flush ?fun(path: string_c, info: fuse_file_info_c): fuse_error]]
--[[@field release ?fun(path: string_c, info: fuse_file_info_c): fuse_error]]
--[[@field fsync ?fun(path: string_c, datasync: integer, info: fuse_file_info_c): fuse_error]]
--[[@field setxattr ?fun(path: string_c, name: string_c, value: string_c, size: integer, unknown: integer): fuse_error]]
--[[@field getxattr ?fun(path: string_c, name: string_c, value: string_c, size: integer): fuse_error]]
--[[@field listxattr ?fun(path: string_c, out: string_c, size_t): fuse_error]]
--[[@field removexattr ?fun(path: string_c, name: string_c): fuse_error]]
--[[@field opendir ?fun(path: string_c, info: fuse_file_info_c): fuse_error]]
--[[@field readdir ?fun(path: string_c, out: ptr_c, fill_dir: fuse_fill_dir, offset: integer, info: fuse_file_info_c, flags: fuse_readdir_flags): fuse_error]]
--[[@field releasedir ?fun(path: string_c, info: fuse_file_info_c): fuse_error]]
--[[@field fsyncdir ?fun(path: string_c, datasync: integer, info: fuse_file_info_c): fuse_error]]
--[[@field init ?fun(conn: fuse_conn_info_c, config: ptr_c<fuse_config_c>): ptr_c]]
--[[@field destroy ?fun(private_data: ptr_c)]]
--[[@field access ?fun(path: string_c, maybe_flags: integer): fuse_error]]
--[[@field create ?fun(path: string_c, mode_t, info: fuse_file_info_c): fuse_error]]
--[[@field lock ?fun(path: string_c, info: fuse_file_info_c, command: fuse_lock_cmd, lock: flock_c): fuse_error]]
--[[@field utimens ?fun(path: string_c, tv: {[0]:timespec_c,[1]:timespec_c}, info: fuse_file_info_c): fuse_error]]
--[[@field bmap ?fun(path: string_c, blocksize: integer, index: ptr_c<integer>): fuse_error]]
--[[@field ioctl ?fun(path: string_c, command: fuse_ioctl_cmd, arg: ptr_c, info: fuse_file_info_c, flags: fuse_ioctl_flags, data: ptr_c): fuse_error]]
--[[@field poll ?fun(path: string_c, info: fuse_file_info_c, poll_handle: ptr_c<fuse_pollhandle_c>, reventsp: ptr_c<integer>): fuse_error]]
--[[@field write_buf ?fun(path: string_c, buf: ptr_c<fuse_bufvec_c>, offset: integer, info: fuse_file_info_c): fuse_error]]
--[[@field read_buf ?fun(path: string_c, bufp: ptr_c<ptr_c<fuse_bufvec_c>>, size: integer, offset: integer, info: fuse_file_info_c): fuse_error]]
--[[@field flock ?fun(path: string_c, info: fuse_file_info_c, op: integer): fuse_error]]
--[[@field fallocate ?fun(path: string_c, datasync: integer, offset: integer, offset2: integer, info: fuse_file_info_c): fuse_error]]
--[[@field copy_file_range ?fun(path_in: string_c, info_in: fuse_file_info_c, offset_in: integer, path_out: string_c, info_out: fuse_file_info_c, offset_out: integer, size: integer, flags: fuse_copy_flags): fuse_error]]
--[[@field lseek ?fun(path: string_c, offset_in: integer, whence: integer, info: fuse_file_info_c): fuse_error]]

local mod = {}

--[[temporary]]
mod.new = fuse_ffi.fuse_fs_new
mod.mount = fuse_ffi.fuse_mount

--[[@enum fuse_error]]
mod.error = {
	success = 0,
	permissions = -1,
	no_entry = -2,
	search = -3,
	interrupt = -4,
	io = -5,
	nx_io = -6,
	--[[originally called 2big]]
	too_big = -7,
	no_execute = -8,
	bad_fd = -9,
	child = -10,
	try_again = -11,
	would_block = -11,
	no_memory = -12,
	access = -13,
	fault = -14,
	not_block = -15,
	busy = -16,
	already_exists = -17,
	cross_device = -18,
	no_device = -19,
	not_directory = -20,
	is_directory = -21,
	invalid = -22,
	file_table_overflow = -23,
	too_many_open_files = -24,
	no_tty = -25,
	text_file_busy = -26,
	file_too_large = -27,
	no_space = -28,
	illegal_seek = -29,
	read_only_file_system = -30,
	too_many_links = -31,
	pipe = -32,
	dom = -33,
	range = -34,
	deadlock = -35,
	name_too_long = -36,
	no_record_locks_available = -37,
	not_implemented = -38,
	directory_not_empty = -39,
	too_many_symlinks_traversed = -40,
	no_message_of_desired_type = -42,
	ident_removed = -43,
	channel_out_of_range = -44,
	level_2_not_synced = -45,
	level_3_halted = -46,
	level_3_reset = -47,
	link_number_out_of_range = -48,
	protocol_driver_not_attached = -49,
	no_csi = -50,
	level_2_halted = -51,
	bad_exchange = -52,
	bad_request_descriptor = -53,
	exchange_full = -54,
	--[[FIXME: proper names: https://kdave.github.io/errno.h/]]
	noano = -55,
	badrqc = -56,
	badslt = -57,
	bfont = -59,
	nostr = -60,
	nodata = -61,
	time = -62,
	nosr = -63,
	nonet = -64,
	nopkg = -65,
	remote = -66,
	nolink = -67,
	adv = -68,
	srmnt = -69,
	comm = -70,
	proto = -71,
	multihop = -72,
	dotdot = -73,
	badmsg = -74,
	overflow = -75,
	notuniq = -76,
	badfd = -77,
	remchg = -78,
	libacc = -79,
	libbad = -80,
	libscn = -81,
	libmax = -82,
	libexec = -83,
	ilseq = -84,
	restart = -85,
	strpipe = -86,
	users = -87,
	not_socket = -88,
	destination_address_required = -89,
	message_too_long = -90,
	wrong_protocol_type = -91,
	protocol_not_available = -92,
	protocol_not_supported = -93,
	socket_not_supported = -94,
	op_not_supported = -95,
	pf_not_supported = -96,
	af_not_supported = -97,
	address_in_use = -98,
	address_not_available = -99,
	net_down = -100,
	net_unreachable = -101,
	net_reset = -102,
	connection_aborted = -103,
	connection_reset = -104,
	no_buffers = -105,
	is_connected = -106,
	not_connected = -107,
	shutdown = -108,
	too_many_refs = -109,
	timed_out = -110,
	connection_refused = -111,
	host_down = -112,
	host_unreachable = -113,
	already = -114,
	in_progress = -115,
	stale = -116,
	struct_needs_cleaning = -117,
	not_named_type_file = -118,
	no_semaphores_available = -119,
	is_named_type_file = -120,
	remote_io = -121,
	quota_exceeded = -122,
	no_medium_found = -123,
	wrong_medium_type = -124,
	canceled = -125,
	no_key = -126,
	key_expired = -127,
	key_revoked = -128,
	key_rejected = -129,
	owner_dead = -130,
	not_recoverable = -131,
	rfkill = -132,
	memory_page_hardware_error = -133,
	restart_system = -512,
	restart_no_interrupt = -513,
	restart_no_handler = -514,
	no_ioctl_command = -515,
	restart_restartblock = -516,
	bad_handle = -521,
	notsync = -522,
	bad_cookie = -523,
	not_supported = -524,
	too_small = -525,
	server_fault = -526,
	bad_type = -527,
	jukebox = -528,
	iocb_queued = -529,
	iocb_retry = -530,
}

return mod

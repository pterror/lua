local match = string.match; local gmatch = string.gmatch

-- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/4/html/reference_guide/s1-proc-topfiles
local mod = {}

--[[@return string? uptime, string? err]]
mod.version = function ()
	local f = io.open("/proc/version")
	if not f then return nil, "could not open " .. "/proc/version" end
	local ret = f:read("*line")
	f:close()
	return ret
end

--[[@class linux_proc_uptime]]
--[[@field uptime number]]
--[[@field idle number]]

--[[@return linux_proc_uptime? uptime, string? err]]
mod.uptime = function ()
	local f = io.open("/proc/uptime")
	if not f then return nil, "could not open " .. "/proc/uptime" end
	local ret = {}
	local line = f:read("*line")
	local uptime, idle = match(line, "(%d+%.%d+) (%d+%.%d+)")
	ret = { uptime = tonumber(uptime), idle = tonumber(idle) }
	f:close()
	return ret
end

--[[@class linux_proc_filesystem]]
--[[@field nodev boolean]]
--[[@field name string]]

--[[@return linux_proc_filesystem[]? filesystems, string? err]]
mod.filesystems = function ()
	local f = io.open("/proc/filesystems")
	if not f then return nil, "could not open " .. "/proc/filesystems" end
	local ret = {}
	while true do
		local line = f:read("*line")
		if not line then break end
		local nodev, name = match(line, "(%S*)\t(%S+)")
		ret[#ret+1] = { nodev = nodev == "nodev", name = name }
	end
	f:close()
	return ret
end

--[[@class linux_proc_misc]]
--[[@field minor integer]]
--[[@field name string]]

--[[@return linux_proc_misc[]? miscs, string? err]]
mod.misc = function ()
	local f = io.open("/proc/misc")
	if not f then return nil, "could not open " .. "/proc/misc" end
	local ret = {}
	while true do
		local line = f:read("*line")
		if not line then break end
		local minor, name = match(line, "%s*(%d+) (%S+)")
		ret[#ret+1] = { minor = tonumber(minor), name = name }
	end
	f:close()
	return ret
end

--[[@class linux_proc_loadavg]]
--[[@field loadavg_1min number]]
--[[@field loadavg_5min number]]
--[[@field loadavg_10min number]]
--[[@field running_procs integer]]
--[[@field total_procs integer]]
--[[@field last_pid integer]]

--[[@return linux_proc_loadavg? loadavg, string? err]]
mod.loadavg = function ()
	local f = io.open("/proc/loadavg")
	if not f then return nil, "could not open " .. "/proc/loadavg" end
	local line = f:read("*line")
	local loadavg_1min, loadavg_5min, loadavg_10min, running_procs, total_procs, last_pid = match(line, "(%d+%.%d+) (%d+%.%d+) (%d+%.%d+) (%d+)/(%d+) (%d+)")
	local ret = {
		loadavg_1min = tonumber(loadavg_1min), loadavg_5min = tonumber(loadavg_5min), loadavg_10min = tonumber(loadavg_10min),
		running_procs = tonumber(running_procs), total_procs = tonumber(total_procs), last_pid = tonumber(last_pid)
	}
	f:close()
	return ret
end

--[[@class linux_proc_swap]]
--[[@field filename string]]
--[[@field type linux_proc_swap_type]]
--[[@field size integer]]
--[[@field used integer]]
--[[@field priority integer]]

--[[@enum linux_proc_swap_type]]
mod.swap_type = {
	partition = "partition",
}

--[[@return linux_proc_swap[]? swaps, string? err]]
mod.swaps = function ()
	local f = io.open("/proc/swaps")
	if not f then return nil, "could not open " .. "/proc/swaps" end
	local ret = {}
	local line = f:read("*line")
	while true do
		line = f:read("*line")
		if not line then break end
		local filename, type, size, used, priority = match(line, "(%S+) +(%S+)\t+(%d+)\t+(%d+)\t+(-?%d+)")
		ret[#ret+1] = { filename = filename, type = type, size = tonumber(size), used = tonumber(used), priority = tonumber(priority) }
	end
	f:close()
	return ret
end

--[[@class linux_proc_partition]]
--[[@field major integer]]
--[[@field minor integer]]
--[[@field blocks integer]]
--[[@field name string]]

--[[@return linux_proc_partition[]? partitions, string? err]]
mod.partitions = function ()
	local f = io.open("/proc/partitions")
	if not f then return nil, "could not open " .. "/proc/partitions" end
	local ret = {}
	local line = f:read("*line")
	line = f:read("*line")
	while true do
		line = f:read("*line")
		if not line then break end
		local major, minor, blocks, name = match(line, " *(%d+) +(%d+) +(%d+) +(%S+)")
		ret[#ret+1] = { major = tonumber(major), minor = tonumber(minor), blocks = tonumber(blocks), name = name }
	end
	f:close()
	return ret
end

--[[@class linux_proc_mount]]
--[[@field device string]]
--[[@field path string]]
--[[@field filesystem string]]
--[[@field options table<string, string|number|boolean>]]
--[[@field should_backup boolean]]
--[[@field fsck_order integer]]

--[[@return linux_proc_mount[]? mounts, string? err]]
mod.mounts = function ()
	local f = io.open("/proc/mounts")
	if not f then return nil, "could not open " .. "/proc/mounts" end
	local ret = {}
	local line = f:read("*line")
	line = f:read("*line")
	while true do
		line = f:read("*line")
		if not line then break end
		local device, path, filesystem, options_raw, should_backup, fsck_order = match(line, "(.-) (.-) (.-) (.-) (%d+) (%d+)")
		local options = {}
		for option in options_raw:gmatch("[^,]+") do
			local name, value = option:match("(.-)=(.+)")
			if name then options[name] = tonumber(value) or value
			else options[option] = true end
		end
		ret[#ret+1] = { device = device, path = path, filesystem = filesystem, options = options, should_backup = should_backup ~= "0", fsck_order = tonumber(fsck_order) }
	end
	f:close()
	return ret
end

-- user nice system idle iowait irq softirq steal guest guest-nice
--[[@class linux_proc_stat]]
--[[@field cpu linux_proc_stat_cpu]]
--[[@field cpus linux_proc_stat_cpu[] ]]
--[[@field intr integer[] ]]
--[[@field ctxt integer]]
--[[@field btime integer]]
--[[@field processes integer]]
--[[@field procs_running integer]]
--[[@field procs_blocked integer]]
--[[@field softirq integer[] ]]

--[[@class linux_proc_stat_cpu]]
--[[@field user integer]]
--[[@field nice integer]]
--[[@field system integer]]
--[[@field idle integer]]
--[[@field iowait integer]]
--[[@field irq integer]]
--[[@field softirq integer]]
--[[@field steal integer]]
--[[@field guest integer]]
--[[@field guest_nice integer]]

--[[@return linux_proc_stat? stat, string? err]]
mod.stat = function ()
	local f = io.open("/proc/stat")
	if not f then return nil, "could not open " .. "/proc/stat" end
	local ret = {}
	local line = f:read("*line")
	local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = match(line, "cpu +(%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)")
	ret.cpu = {
		user = tonumber(user), nice = tonumber(nice), system = tonumber(system), idle = tonumber(idle), iowait = tonumber(iowait),
		irq = tonumber(irq), softirq = tonumber(softirq), steal = tonumber(steal), guest = tonumber(guest), guest_nice = tonumber(guest_nice)
	}
	ret.cpus = {}
	while true do
		line = f:read("*line")
		user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = match(line, "cpu%d+ (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)")
		if not user then break end
		ret.cpus[#ret.cpus+1] = {
			user = tonumber(user), nice = tonumber(nice), system = tonumber(system), idle = tonumber(idle), iowait = tonumber(iowait),
			irq = tonumber(irq), softirq = tonumber(softirq), steal = tonumber(steal), guest = tonumber(guest), guest_nice = tonumber(guest_nice)
		}
	end
	ret.intr = {}
	local intr = ret.intr
	for n in gmatch(line, "%d+") do
		intr[#intr+1] = tonumber(n)
	end
	ret.ctxt = tonumber(match(f:read("*line"), "%d+"))
	ret.btime = tonumber(match(f:read("*line"), "%d+"))
	ret.processes = tonumber(match(f:read("*line"), "%d+"))
	ret.procs_running = tonumber(match(f:read("*line"), "%d+"))
	ret.procs_blocked = tonumber(match(f:read("*line"), "%d+"))
	line = f:read("*line")
	ret.softirq = {}
	local softirqs = ret.softirq
	for n in gmatch(line, "%d+") do
		softirqs[#softirqs+1] = tonumber(n)
	end
	f:close()
	return ret
end

--[[all numbers are kilobytes, except for huge_pages which are counts]]
--[[@class linux_proc_meminfo]]
--[[@field mem_total integer]]
--[[@field mem_free integer]]
--[[@field mem_available integer]]
--[[@field buffers integer]]
--[[@field cached integer]]
--[[@field swap_cached integer]]
--[[@field active integer]]
--[[@field inactive integer]]
--[[@field active_anon integer]]
--[[@field inactive_anon integer]]
--[[@field active_file integer]]
--[[@field inactive_file integer]]
--[[@field unevictable integer]]
--[[@field mlocked integer]]
--[[@field high_total? integer]]
--[[@field high_free? integer]]
--[[@field low_total? integer]]
--[[@field low_free? integer]]
--[[@field swap_total integer]]
--[[@field swap_free integer]]
--[[@field zswap integer]]
--[[@field zswapped integer]]
--[[@field dirty integer]]
--[[@field writeback integer]]
--[[@field anon_pages integer]]
--[[@field mapped integer]]
--[[@field shmem integer]]
--[[@field k_reclaimable integer]]
--[[@field slab integer]]
--[[@field s_reclaimable integer]]
--[[@field s_unreclaim integer]]
--[[@field kernel_stack integer]]
--[[@field page_tables integer]]
--[[@field sec_page_tables integer]]
--[[@field nfs_unstable integer]]
--[[@field bounce integer]]
--[[@field writeback_tmp integer]]
--[[@field commit_limit integer]]
--[[@field committed_as integer]]
--[[@field vmalloc_total integer]]
--[[@field vmalloc_used integer]]
--[[@field vmalloc_chunk integer]]
--[[@field percpu integer]]
--[[@field hardware_corrupted integer]]
--[[@field anon_huge_pages integer]]
--[[@field shmem_huge_pages integer]]
--[[@field shmem_pmd_mapped integer]]
--[[@field file_huge_pages integer]]
--[[@field file_pmd_mapped integer]]
--[[@field cma_total integer]]
--[[@field cma_free integer]]
--[[@field huge_pages_total integer]]
--[[@field huge_pages_free integer]]
--[[@field huge_pages_rsvd integer]]
--[[@field huge_pages_surp integer]]
--[[@field hugepagesize integer]]
--[[@field hugetlb integer]]
--[[@field direct_map4k integer]]
--[[@field direct_map2_m integer]]
--[[@field direct_map1_g integer]]

--[[@enum linux_proc_meminfo_name]]
mod.name_to_key = {
	MemTotal = "mem_total",
	MemFree = "mem_free",
	MemAvailable = "mem_available",
	Buffers = "buffers",
	Cached = "cached",
	SwapCached = "swap_cached",
	Active = "active",
	Inactive = "inactive",
	["Active(anon)"] = "active_anon",
	["Inactive(anon)"] = "inactive_anon",
	["Active(file)"] = "active_file",
	["Inactive(file)"] = "inactive_file",
	Unevictable = "unevictable",
	Mlocked = "mlocked",
	HighTotal = "high_total",
	HighFree = "high_free",
	LowTotal = "low_total",
	LowFree = "low_free",
	SwapTotal = "swap_total",
	SwapFree = "swap_free",
	Zswap = "zswap",
	Zswapped = "zswapped",
	Dirty = "dirty",
	Writeback = "writeback",
	AnonPages = "anon_pages",
	Mapped = "mapped",
	Shmem = "shmem",
	KReclaimable = "k_reclaimable",
	Slab = "slab",
	SReclaimable = "s_reclaimable",
	SUnreclaim = "s_unreclaim",
	KernelStack = "kernel_stack",
	PageTables = "page_tables",
	SecPageTables = "sec_page_tables",
	NFS_Unstable = "nfs_unstable",
	Bounce = "bounce",
	WritebackTmp = "writeback_tmp",
	CommitLimit = "commit_limit",
	Committed_AS = "committed_as",
	VmallocTotal = "vmalloc_total",
	VmallocUsed = "vmalloc_used",
	VmallocChunk = "vmalloc_chunk",
	Percpu = "percpu",
	HardwareCorrupted = "hardware_corrupted",
	AnonHugePages = "anon_huge_pages",
	ShmemHugePages = "shmem_huge_pages",
	ShmemPmdMapped = "shmem_pmd_mapped",
	FileHugePages = "file_huge_pages",
	FilePmdMapped = "file_pmd_mapped",
	CmaTotal = "cma_total",
	CmaFree = "cma_free",
	HugePages_Total = "huge_pages_total",
	HugePages_Free = "huge_pages_free",
	HugePages_Rsvd = "huge_pages_rsvd",
	HugePages_Surp = "huge_pages_surp",
	Hugepagesize = "hugepagesize",
	Hugetlb = "hugetlb",
	DirectMap4k = "direct_map4k",
	DirectMap2M = "direct_map2_m",
	DirectMap1G = "direct_map1_g",
}

--[[@return linux_proc_meminfo? meminfo, string? err]]
mod.meminfo = function ()
	local f = io.open("/proc/meminfo")
	if not f then return nil, "could not open " .. "/proc/meminfo" end
	local ret = {}
	while true do
		local line = f:read("*line")
		if not line then break end
		local name, n_str = match(line, "(.-): +(%d+)")
		ret[mod.name_to_key[name]] = tonumber(n_str)
	end
	f:close()
	return ret
end

--[[@class linux_proc_vmstat]]
--[[@field nr_free_pages integer]]
--[[@field nr_zone_inactive_anon integer]]
--[[@field nr_zone_active_anon integer]]
--[[@field nr_zone_inactive_file integer]]
--[[@field nr_zone_active_file integer]]
--[[@field nr_zone_unevictable integer]]
--[[@field nr_zone_write_pending integer]]
--[[@field nr_mlock integer]]
--[[@field nr_bounce integer]]
--[[@field nr_zspages integer]]
--[[@field nr_free_cma integer]]
--[[@field numa_hit integer]]
--[[@field numa_miss integer]]
--[[@field numa_foreign integer]]
--[[@field numa_interleave integer]]
--[[@field numa_local integer]]
--[[@field numa_other integer]]
--[[@field nr_inactive_anon integer]]
--[[@field nr_active_anon integer]]
--[[@field nr_inactive_file integer]]
--[[@field nr_active_file integer]]
--[[@field nr_unevictable integer]]
--[[@field nr_slab_reclaimable integer]]
--[[@field nr_slab_unreclaimable integer]]
--[[@field nr_isolated_anon integer]]
--[[@field nr_isolated_file integer]]
--[[@field workingset_nodes integer]]
--[[@field workingset_refault_anon integer]]
--[[@field workingset_refault_file integer]]
--[[@field workingset_activate_anon integer]]
--[[@field workingset_activate_file integer]]
--[[@field workingset_restore_anon integer]]
--[[@field workingset_restore_file integer]]
--[[@field workingset_nodereclaim integer]]
--[[@field nr_anon_pages integer]]
--[[@field nr_mapped integer]]
--[[@field nr_file_pages integer]]
--[[@field nr_dirty integer]]
--[[@field nr_writeback integer]]
--[[@field nr_writeback_temp integer]]
--[[@field nr_shmem integer]]
--[[@field nr_shmem_hugepages integer]]
--[[@field nr_shmem_pmdmapped integer]]
--[[@field nr_file_hugepages integer]]
--[[@field nr_file_pmdmapped integer]]
--[[@field nr_anon_transparent_hugepages integer]]
--[[@field nr_vmscan_write integer]]
--[[@field nr_vmscan_immediate_reclaim integer]]
--[[@field nr_dirtied integer]]
--[[@field nr_written integer]]
--[[@field nr_throttled_written integer]]
--[[@field nr_kernel_misc_reclaimable integer]]
--[[@field nr_foll_pin_acquired integer]]
--[[@field nr_foll_pin_released integer]]
--[[@field nr_kernel_stack integer]]
--[[@field nr_page_table_pages integer]]
--[[@field nr_sec_page_table_pages integer]]
--[[@field nr_swapcached integer]]
--[[@field pgpromote_success integer]]
--[[@field pgpromote_candidate integer]]
--[[@field nr_dirty_threshold integer]]
--[[@field nr_dirty_background_threshold integer]]
--[[@field pgpgin integer]]
--[[@field pgpgout integer]]
--[[@field pswpin integer]]
--[[@field pswpout integer]]
--[[@field pgalloc_dma integer]]
--[[@field pgalloc_dma32 integer]]
--[[@field pgalloc_normal integer]]
--[[@field pgalloc_movable integer]]
--[[@field pgalloc_device integer]]
--[[@field allocstall_dma integer]]
--[[@field allocstall_dma32 integer]]
--[[@field allocstall_normal integer]]
--[[@field allocstall_movable integer]]
--[[@field allocstall_device integer]]
--[[@field pgskip_dma integer]]
--[[@field pgskip_dma32 integer]]
--[[@field pgskip_normal integer]]
--[[@field pgskip_movable integer]]
--[[@field pgskip_device integer]]
--[[@field pgfree integer]]
--[[@field pgactivate integer]]
--[[@field pgdeactivate integer]]
--[[@field pglazyfree integer]]
--[[@field pgfault integer]]
--[[@field pgmajfault integer]]
--[[@field pglazyfreed integer]]
--[[@field pgrefill integer]]
--[[@field pgreuse integer]]
--[[@field pgsteal_kswapd integer]]
--[[@field pgsteal_direct integer]]
--[[@field pgdemote_kswapd integer]]
--[[@field pgdemote_direct integer]]
--[[@field pgscan_kswapd integer]]
--[[@field pgscan_direct integer]]
--[[@field pgscan_direct_throttle integer]]
--[[@field pgscan_anon integer]]
--[[@field pgscan_file integer]]
--[[@field pgsteal_anon integer]]
--[[@field pgsteal_file integer]]
--[[@field zone_reclaim_failed integer]]
--[[@field pginodesteal integer]]
--[[@field slabs_scanned integer]]
--[[@field kswapd_inodesteal integer]]
--[[@field kswapd_low_wmark_hit_quickly integer]]
--[[@field kswapd_high_wmark_hit_quickly integer]]
--[[@field pageoutrun integer]]
--[[@field pgrotated integer]]
--[[@field drop_pagecache integer]]
--[[@field drop_slab integer]]
--[[@field oom_kill integer]]
--[[@field numa_pte_updates integer]]
--[[@field numa_huge_pte_updates integer]]
--[[@field numa_hint_faults integer]]
--[[@field numa_hint_faults_local integer]]
--[[@field numa_pages_migrated integer]]
--[[@field pgmigrate_success integer]]
--[[@field pgmigrate_fail integer]]
--[[@field thp_migration_success integer]]
--[[@field thp_migration_fail integer]]
--[[@field thp_migration_split integer]]
--[[@field compact_migrate_scanned integer]]
--[[@field compact_free_scanned integer]]
--[[@field compact_isolated integer]]
--[[@field compact_stall integer]]
--[[@field compact_fail integer]]
--[[@field compact_success integer]]
--[[@field compact_daemon_wake integer]]
--[[@field compact_daemon_migrate_scanned integer]]
--[[@field compact_daemon_free_scanned integer]]
--[[@field htlb_buddy_alloc_success integer]]
--[[@field htlb_buddy_alloc_fail integer]]
--[[@field cma_alloc_success integer]]
--[[@field cma_alloc_fail integer]]
--[[@field unevictable_pgs_culled integer]]
--[[@field unevictable_pgs_scanned integer]]
--[[@field unevictable_pgs_rescued integer]]
--[[@field unevictable_pgs_mlocked integer]]
--[[@field unevictable_pgs_munlocked integer]]
--[[@field unevictable_pgs_cleared integer]]
--[[@field unevictable_pgs_stranded integer]]
--[[@field thp_fault_alloc integer]]
--[[@field thp_fault_fallback integer]]
--[[@field thp_fault_fallback_charge integer]]
--[[@field thp_collapse_alloc integer]]
--[[@field thp_collapse_alloc_failed integer]]
--[[@field thp_file_alloc integer]]
--[[@field thp_file_fallback integer]]
--[[@field thp_file_fallback_charge integer]]
--[[@field thp_file_mapped integer]]
--[[@field thp_split_page integer]]
--[[@field thp_split_page_failed integer]]
--[[@field thp_deferred_split_page integer]]
--[[@field thp_split_pmd integer]]
--[[@field thp_scan_exceed_none_pte integer]]
--[[@field thp_scan_exceed_swap_pte integer]]
--[[@field thp_scan_exceed_share_pte integer]]
--[[@field thp_split_pud integer]]
--[[@field thp_zero_page_alloc integer]]
--[[@field thp_zero_page_alloc_failed integer]]
--[[@field thp_swpout integer]]
--[[@field thp_swpout_fallback integer]]
--[[@field balloon_inflate integer]]
--[[@field balloon_deflate integer]]
--[[@field balloon_migrate integer]]
--[[@field swap_ra integer]]
--[[@field swap_ra_hit integer]]
--[[@field ksm_swpin_copy integer]]
--[[@field cow_ksm integer]]
--[[@field zswpin integer]]
--[[@field zswpout integer]]
--[[@field direct_map_level2_splits integer]]
--[[@field direct_map_level3_splits integer]]
--[[@field nr_unstable integer]]

--[[@return linux_proc_vmstat? vmstat, string? err]]
mod.vmstat = function ()
	local f = io.open("/proc/vmstat")
	if not f then return nil, "could not open " .. "/proc/vmstat" end
	local ret = {}
	while true do
		local line = f:read("*line")
		if not line then break end
		local name, n_str = match(line, "(%S+) (%d+)")
		ret[name] = tonumber(n_str)
	end
	f:close()
	return ret
end

mod.net = {}

--[[@alias linux_proc_net_dev table<string, linux_proc_net_dev_interface>]]

--[[@class linux_proc_net_dev_interface]]
--[[@field receive linux_proc_net_dev_receive]]
--[[@field transmit linux_proc_net_dev_transmit]]

--[[@class linux_proc_net_dev_base]]
--[[@field bytes integer]]
--[[@field packets integer]]
--[[@field errs integer]]
--[[@field drop integer]]
--[[@field fifo integer]]
--[[@field compressed integer]]

--[[@class linux_proc_net_dev_receive: linux_proc_net_dev_base]]
--[[@field frame integer]]
--[[@field multicast integer]]

--[[@class linux_proc_net_dev_transmit: linux_proc_net_dev_base]]
--[[@field colls integer]]
--[[@field carrier integer]]

--[[@return linux_proc_net_dev? net_dev, string? err]]
mod.net.dev = function ()
	local f = io.open("/proc/net/dev")
	if not f then return nil, "could not open " .. "/proc/net/dev" end
	local ret = {}
	local line = f:read("*line"); line = f:read("*line")
	while true do
		line = f:read("*line")
		if not line then break end
		local name, r_bytes, r_packets, r_errs, r_drop, r_fifo, r_frame, r_compressed, r_multicast,
			t_bytes, t_packets, t_errs, t_drop, t_fifo, t_colls, t_carrier, t_compressed =
			match(line, "(%S+): +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+)")
		ret[name] = {
			receive = {
				bytes = tonumber(r_bytes), packets = tonumber(r_packets), errs = tonumber(r_errs), drop = tonumber(r_drop), fifo = tonumber(r_fifo),
				frame = tonumber(r_frame), compressed = tonumber(r_compressed), multicast = tonumber(r_multicast),
			},
			transmit = {
				bytes = tonumber(t_bytes), packets = tonumber(t_packets), errs = tonumber(t_errs), drop = tonumber(t_drop), fifo = tonumber(t_fifo),
				colls = tonumber(t_colls), carrier = tonumber(t_carrier), compressed = tonumber(t_compressed),
			},
		}
	end
	f:close()
	return ret
end

return mod

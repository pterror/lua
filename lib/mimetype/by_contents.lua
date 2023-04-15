-- current as of https://github.com/sindresorhus/file-type/commit/fd1e72c8624018fe67a50edcd1557f153260cdca
-- TODO: attempt wma and wmv

-- NOTE: added formats: avro, mp3 without ID3, iso, isz, dwg, dxf, svf, ipt, iam, ipn
-- also specific cfb clsids: some versions of doc, xls, ppt, msi
-- for more formats see:
-- https://gist.github.com/Qti3e/6341245314bf3513abb080677cd1c93b
-- https://en.wikipedia.org/wiki/List_of_file_signatures
-- dwg is missing pre-2000 versions
-- missing fixtures: isz, binary dxf, ipt, iam, ipn, lz4 fuchsia format
-- todo detection: autodesk ipt, f3d, rfa, dxf binary
-- next up: https://fileinfo.com/software/autodesk/inventor
-- https://stackoverflow.com/questions/71253009/autodesk-forge-difftool-extension-for-dwf
-- https://www.threedy.io/scalability/anydata
-- https://forge.autodesk.com/en/docs/viewer/v7/developers_guide/viewer_basics/difftool/

-- quick testing:
-- rm out; for f in fixture_dir/*.{exts,of,interest}; echo $f; luajit lib/mimetype/by_contents.lua $f; end
-- for testing:
-- rm out; for f in fixture_dir/*; echo $f >> out; luajit lib/mimetype/by_contents.lua $f >> out; end
-- replace: .+(.+)\n\1.+\n|.+corrupt.+\n\n|.+\.elf\n\t.+\n
-- with: <empty>

local mod = {}

local json_parse

--- @param buffer string
--- @param pos integer?
function mod.mimetype(buffer, pos)
	pos = pos or 1
	--- @param pos_ integer
	local function get_u16(pos_)
		local a, b = buffer:byte(pos_, pos_ + 1)
		local num = bit.bor(bit.lshift(a, 8), b)
		if num < 0 then return num + 0x8000 else return num end
	end
	--- @param pos_ integer
	local function get_u16_le(pos_)
		local a, b = buffer:byte(pos_, pos_ + 1)
		local num = bit.bor(a, bit.lshift(b, 8))
		if num < 0 then return num + 0x8000 else return num end
	end
	--- @param pos_ integer
	local function get_i32(pos_)
		local a, b, c, d = buffer:byte(pos_, pos_ + 3)
		return bit.bor(bit.lshift(a, 24), bit.lshift(b, 16), bit.lshift(c, 8), d)
	end
	--- @param pos_ integer
	local function get_u32(pos_)
		local num = get_i32(pos_)
		if num < 0 then return num + 0x80000000 else return num end
	end
	--- @param pos_ integer
	local function get_u32_le(pos_)
		local a, b, c, d = buffer:byte(pos_, pos_ + 3)
		local num = bit.bor(a, bit.lshift(b, 8), bit.lshift(c, 16), bit.lshift(d, 24))
		if num < 0 then return num + 0x80000000 else return num end
	end
	-- returns uint64_t cdata
	--- @param pos_ integer
	local function get_u64_le(pos_)
		return bit.bor(get_u32_le(pos_), bit.lshift(0ULL + get_u32_le(pos_ + 4), 32))
	end
	--- @param s string
	local function trim(s) return s:match("%S.*%S") or s:match("%S") or "" end
	--- @param buffer_ string
	--- @param header string
	--- @param offset integer?
	local function _check(buffer_, header, offset)
		local start = pos + (offset or 0)
		return buffer_:sub(start, start + #header - 1) == header
	end
	--- @param buffer_ string
	--- @param header string
	--- @param offset integer
	--- @param mask string
	local function _check_mask(buffer_, header, offset, mask)
		local start = pos + offset - 1
		for i = 1, #header do
			local byte = buffer_:byte(start + i)
			if header:byte(i) ~= bit.band(mask:byte(i), byte) then
				return false
			end
		end
		return true
	end
	--- @param header string
	--- @param offset integer?
	local function check(header, offset)
		return _check(buffer, header, offset or 0)
	end
	--- @param header string
	--- @param offset integer
	--- @param mask string
	local function check_mask(header, offset, mask)
		return _check_mask(buffer, header, offset or 0, mask or nil)
	end

	-- utf8 bom
	while check("\xef\xbb\xbf") do pos = pos + 3 end
	if check("BM") then return "bmp", "image/bmp" end
	if check("\x0b\x77") then return "ac3", "audio/vnd.dolby.dd-raw" end
	if check("\x78\x01") then return "dmg", "application/x-apple-diskimage" end
	if check("\x4d\x5a") then return "exe", "application/x-msdownload" end
	if check("\x25\x21") then
		if check("PS-Adobe-", 2) and check(" EPSF-", 14) then return "eps", "application/eps" end
		return "ps", "application/postscript"
	end
	if check("\x1f\xa0") or check("\x1f\x9d") then return "Z", "application/x-compress" end
	if check("\xff\xfb") or check("\xff\xf3") or check("\xff\xf2") then return "mp3", "audio/mpeg" end
	if check("GIF") then return "gif", "image/gif" end
	if check("\xff\xd8\xff") then
		if check("\xe8", 3) then
			return "spiff", "image/spiff"
		end
		return "jpg", "image/jpeg"
	end
	if check("II\xBC") then return "jxr", "image/vnd.ms-photo" end
	if check("\x1f\x8b\x08") then return "gz", "application/gzip" end
	if check("BZh") then return "bz2", "application/x-bzip2" end
	if check("ID3") then
		pos = pos + 6
		local n = get_u32(pos)
		pos = pos + 4
		-- XXX: check
		local header_length = bit.bor(
			bit.band(n, 0x7F),
			bit.lshift(bit.band(bit.rshift(n, 8), 0xFF), 7),
			bit.lshift(bit.band(bit.rshift(n, 16), 0xFF), 14),
			bit.lshift(bit.band(bit.rshift(n, 24), 0xFF), 21)
		)
		if pos + header_length > #buffer then return "mp3", "audio/mpeg" end -- guess
		pos = pos + header_length
		return mod.mimetype(buffer, pos)
	end
	if check("MP+") then return "mpc", "audio/x-musepack" end
	if check("FWS") or check("CWS") then return "swf", "application/x-shockwave-flash" end
	if check("FLIF") then return "flif", "image/flif" end
	if check("8BPS") then return "psd", "image/vnd.adobe.photoshop" end
	if check("WEBP", 8) then return "webp", "image/webp" end
	if check("MPCK") then return "mpc", "audio/x-musepack" end
	if check("FORM") then return "aif", "audio/aiff" end
	if check("icns") then return "icns", "image/icns" end
	if check("AC10") then
		local version = buffer:sub(pos + 4, pos + 5)
		if ({
			["01"] = true, ["02"] = true, ["03"] = true, ["04"] = true, ["06"] = true, ["09"] = true, ["12"] = true,
			["14"] = true, ["15"] = true, ["18"] = true, ["21"] = true, ["24"] = true, ["27"] = true, ["32"] = true,
		})[version] then return "dwg", "application/vnd.autodesk.autocad.dwg" end
	end
	if check("MC0.0") then return "dwg", "application/vnd.autodesk.autocad.dwg" end
	if check("AC") then
		if
			check("1.2", 2) or check("1.40", 2) or check("1.50", 2) or
			check("2.10", 2) or check("2.21", 2) or check("2.22", 2) or
			check("1500", 2) or check("402a", 2) or check("402b", 2) or
			check("103-4", 2)
		then
			return "dwg", "application/vnd.autodesk.autocad.dwg"
		end
	end
	if check("IsZ!") then return "isz", "application/x-iso9660-image-compressed" end
	-- needs to be before the `zip` check
	if check("PK\x03\x04") then -- Local file header signature
		while pos + 30 < #buffer do
			local compressed_size, uncompressed_size, filename_length, extra_field_length, filename =
				get_u32_le(pos + 18), get_u32_le(pos + 22), get_u16_le(pos + 26), get_u16_le(pos + 28), ""
			pos = pos + 30
			filename = buffer:sub(pos, pos + filename_length - 1)
			pos = pos + filename_length + extra_field_length
			if filename == "META-INF/mozilla.rsa" then return "xpi", "application/x-xpinstall" end
			if filename:find("%.rels$") or filename:find("%.xml$") then
				local type = filename:match("^(.-)/")
				if type == "word" then
					return "docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
				elseif type == "ppt" then
					return "pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation"
				elseif type == "xl" then
					return "xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
				end
			end
			if filename:find("^xl/") then return "xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" end
			if filename:find("^3D/.+%.model$") then return "3mf", "model/3mf" end
			if filename == "mimetype" and compressed_size == uncompressed_size then
				local mimetype = trim(buffer:sub(pos, pos + compressed_size - 1))
				if mimetype == "application/epub+zip" then
					return "epub", mimetype
				elseif mimetype == "application/vnd.oasis.opendocument.text" then
					return "odt", mimetype
				elseif mimetype == "application/vnd.oasis.opendocument.spreadsheet" then
					return "ods", mimetype
				elseif mimetype == "application/vnd.oasis.opendocument.presentation" then
					return "odp", mimetype
				end
			end
			if compressed_size == 0 then
				while pos + 4 < #buffer and not check("PK\x03\x04") do pos = pos + 1 end
			else pos = pos + compressed_size end
		end
		return "zip", "application/zip"
	end
	if check("OggS") then
		pos = pos + 28
		if check("OpusHead") then return "opus", "audio/opus" end -- needs to be before `ogg` check
		if check("\x80theora") then return "ogv", "video/ogg" end
		if check("\x01video\0") then return "ogm", "video/ogg" end
		if check("\x7fFLAC") then return "oga", "audio/ogg" end
		if check("Speex  ") then return "spx", "audio/ogg" end
		if check("\x01vorbis") then return "ogg", "audio/ogg" end
		return "ogx", "application/ogg"
	end
	if check("\x50\x4b\x03\x04") or check("\x50\x4b\x05\x06") or check("\x50\x4b\x07\x08") then
		return "zip", "application/zip"
	end
	if check("ftyp", 4) and bit.band(buffer:byte(pos + 7), 0x60) ~= 0x00 then
		local brand_major = trim(buffer:sub(pos + 8, pos + 11):gsub("%z+", ""))
		local lookup = {
			avif = { "avif", "image/avif" },
			avis = { "avif", "image/avif" },
			mif1 = { "heic", "image/heif" },
			msf1 = { "heic", "image/heif-sequence" },
			heic = { "heic", "image/heic" },
			heix = { "heic", "image/heic" },
			hevc = { "heic", "image/heic-sequence" },
			hevx = { "heic", "image/heic-sequence" },
			qt = { "mov", "video/quicktime" },
			M4V = { "m4v", "video/x-m4v" },
			M4VH = { "m4v", "video/x-m4v" },
			M4VP = { "m4v", "video/x-m4v" },
			M4P = { "m4p", "video/mp4" },
			M4B = { "m4b", "audio/mp4" },
			M4A = { "m4a", "audio/x-m4a" },
			F4V = { "f4v", "video/mp4" },
			F4P = { "f4p", "video/mp4" },
			F4A = { "f4a", "audio/mp4" },
			F4B = { "f4b", "audio/mp4" },
			crx = { "cr3", "image/x-canon-cr3" },
		}
		local result = lookup[brand_major]
		if result then return result[1], result[2] end
		if brand_major:find("^3g2") then
			return "3g2", "video/3gpp2"
		elseif brand_major:find("^3g") then
			return "3gp", "video/3gpp"
		else
			return "mp4", "video/mp4"
		end
	end
	-- this can be made much more optimal with a lookup indexed by buffer:sub(pos, pos + 3)
	if check("MThd") then return "mid", "audio/midi" end
	if check("wOFF\0\x01\0\0") or check("wOFFOTTO") then return "woff", "font/woff" end
	if check("wOF2\0\x01\0\0") or check("wOF2OTTO") then return "woff2", "font/woff2" end
	if check("\xd4\xc3\xb2\xa1") or check("\xa1\xb2\xc3\xd4") then return "pcap", "application/vnd.tcpdump.pcap" end
	if check("DSD ") then return "dsf", "audio/x-dsf" end -- non-standard
	if check("LZIP") then return "lz", "application/x-lzip" end
	if check("fLaC") then return "flac", "audio/x-flac" end
	if check("\x42\x50\x47\xfb") then return "bpg", "image/bpg" end
	if check("wvpk") then return "wv", "audio/wavpack" end
	if check("%PDF-") then
		if buffer:match("AIPrivateData", pos + 1350) then return "ai", "application/postscript" end
		return "pdf", "application/pdf"
	end
	if check("\0\x61\x73\x6d") then return "wasm", "application/wasm" end
	if check("II") or check("MM") then
		local get_u16_ = check("II") and get_u16_le or get_u16
		local get_u32_ = check("II") and get_u32_le or get_u32
		local version = get_u16_(pos + 2)
		if version == 42 then
			local ifd_offset = get_u32_(pos + 4)
			if ifd_offset >= 6 then
				if check("CR", 8) then return "cr2", "image/x-canon-cr2" end
				if ifd_offset >= 8 and (check("\x1c\0\xfe\0", 8) or check("\x1f\0\x0b\0", 8)) then return "nef", "image/x-nikon-nef" end
			end
			pos = pos + ifd_offset + 2
			if pos + 1 > #buffer then return end -- invalid
			for _ = 1, get_u16_(pos - 2) do
				if pos + 1 > #buffer then return end -- invalid
				local id = get_u16_(pos)
				if id == 0xc4a5 then return "arw", "image/x-sony-arw" end
				if id == 0xc612 then return "dng", "image/x-adobe-dng" end
				pos = pos + 12
			end
			return "tif", "image/tiff"
		end
		if version == 43 then
			return "tif", "image/tiff"
		end
		-- fallthrough
	end
	if check("MAC ") then return "ape", "audio/ape" end
	if check("\x1a\x45\xdf\xa3") then
		local function read_field()
			local msb = buffer:byte(pos) -- FIXME: `or 0` is a temporary workaround
			local mask = 0x80
			local ic = 0
			--[[@diagnostic disable-next-line: param-type-mismatch]]
			while bit.band(msb, mask) == 0 and mask ~= 0 do ic = ic + 1; mask = mask / 2; end
			local start = pos
			pos = pos + ic + 1
			return buffer:sub(start, pos - 1)
		end
		local function read_element()
			local id = read_field()
			local len = read_field()
			len = string.char(bit.bxor(len:byte(1), bit.rshift(0x80, #len - 1))) .. len:sub(2)
			--- @return integer
			--- @param buf string
			local function read(buf)
				local ret = 0ULL
				for i = 1, #buf do
					ret = bit.bor(bit.lshift(ret, 8), buf:byte(i))
				end
				--- @diagnostic disable-next-line: return-type-mismatch
				return tonumber(ret) -- lossy conversion
			end
			return read(id), read(len)
		end
		local function read_children(children)
			while children > 0 do
				local success, e, length = pcall(read_element)
				if not success then return end -- invalid
				if e == 0x4282 then return buffer:sub(pos, pos + length - 1):gsub("%z.*", "") end
				pos = pos + length
				children = children - 1
			end
		end
		local doctype = read_children(select(2, read_element()))
		if doctype == "webm" then return "webm", "video/webm" elseif doctype == "matroska" then return "mkv", "video/x-matroska" else return end
	end
	if check("RIFF") then
		if check("AVI", 8) then return "avi", "video/vnd.avi" end
		if check("WAVE", 8) then return "wav", "audio/vnd.wave" end
		if check("QLCM", 8) then return "qcp", "audio/qcelp" end
	end
	if check("NES\x1a") then return "nes", "application/x-nintendo-nes-rom" end -- probably custom
	if check("Cr24") then return "crx", "application/x-google-chrome-extension" end
	if check("MSCF") or check("ISc(") then return "cab", "application/vnd.ms-cab-compressed" end
	if check("\xed\xab\xee\xdb") then return "rpm", "application/x-rpm" end
	if check("\xc5\xd0\xd3\xc6") then return "eps", "application/eps" end
	if check("\x28\xb5\x2f\xfd") then return "zst", "application/zstd" end
	if check("OTTO\0") then return "otf", "font/otf" end
	if check("#!AMR") then return "amr", "audio/amr" end
	if check("{\\rtf") then return "rtf", "application/rtf" end
	if check("FLV\x01") then return "flv", "video/x-flv" end
	if check("IMPM") then return "it", "audio/x-it" end
	if check("\x7fELF") then return "", "application/x-elf" end
	if check("ITSF") then return "chm", "application/vnd.ms-htmlhelp" end
	if check("Obj\x01") then return "avro", "application/avro" end
	if check("\x50\x2a\x4d\x18") or check("\x04\x22\x4d\x18") then return "lz4", "application/x-lz4" end
	if check("\x28\xb5\x2f\xfd") then return "zst", "application/zstd" end
	if buffer:find("^-lh[01234567d]-", pos + 2) or buffer:find("^-lz[45s]-", pos + 2) then
		return "lzh", "application/x-lzh-compressed"
	end
	if check("\0\0\x01\xba") then
		-- may also be .ps, .mpeg
		if check_mask("\x21", 4, "\xF1") then return "mpg", "video/MP1S" end
		-- may also be .mpeg, .m2p, .vob or .sub
		if check_mask("\x44", 4, "\xC4") then return "mpg", "video/MP2P" end
	end
	if check("\xfd\x37\x7a\x58\x5a\0") then return "xz", "application/x-xz" end
	if check("<?xml ") then return "xml", "application/xml" end
	if check("BEGIN:VCARD") then return "vcf", "text/vcard" end
	if check("BEGIN:VCALENDAR") then return "ics", "text/calendar" end
	if check("\x37\x7a\xbc\xaf\x27\x1c") then return "7z", "application/x-7z-compressed" end
	if check("Rar!\x1a\x07") and bit.bor(buffer:byte(pos + 6), 1) == 1 then return "rar", "application/x-rar-compressed" end
	if check("solid ") then return "stl", "model/stl" end
	if check("BLENDER") then return "blend", "application/x-blender" end
	if check("!<arch>") then
		pos = pos + 8
		if buffer:sub(pos, pos + 12) == "debian-binary" then return "deb", "application/x-deb" end
		return "ar", "application/x-unix-archive"
	end
	if check("\x89\x50\x4e\x47\x0d\x0a\x1a\x0a") then
		pos = pos + 8
		local function readChunkHeader()
			local length = get_i32(pos)
			local name = buffer:sub(pos + 4, pos + 7)
			pos = pos + 8
			return length, name
		end
		while pos + 8 < #buffer do
			local length, type = readChunkHeader()
			if length < 0 then return end -- invalid
			if type == "IDAT" then
				return "png", "image/png"
			elseif type == "acTL" then
				return "apng", "image/vnd.mozilla.apng"
			else
				pos = pos + length + 4
			end
		end
		return "png", "image/png"
	end
	if check("\xd0\xcf\x11\xe0\xa1\xb1\x1a\xe1") then
		local sector_size = bit.lshift(1, get_u16_le(pos + 30))
		local root_dir_index = get_u32_le(pos + 48)
		pos = (root_dir_index + 1) * sector_size + 81
		-- microsoft CLSIDs below
		-- versions: 5 (95), 6 (6.0-7.0), 8 (97-2003), 12 (2007?)
		-- https://raw.githubusercontent.com/decalage2/oletools/master/oletools/common/clsid.py
		if check("\x9b\x4c\x75\xf4\xf5\x64\x40\x4b\x8a\xf4\x67\x97\x32\xac\x06\x07") then
			-- Word.Document.12: clsid f4754c9b-64f5-4b40-8af4-679732ac0607
			return "doc", "application/msword"
		elseif check("\x06\x09\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- Word.Document.8: clsid 00020906-0000-0000-c000-000000000046
			return "doc", "application/msword"
		elseif check("\x00\x09\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- Word.Document.6: clsid 00020900-0000-0000-c000-000000000046
			return "doc", "application/msword"
		elseif check("\x30\x08\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- Excel.Sheet.12: clsid 00020830-0000-0000-c000-000000000046
			return "xls", "application/vnd.ms-excel"
		elseif check("\x20\x08\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- Excel.Sheet.8: clsid 00020820-0000-0000-c000-000000000046
			return "xls", "application/vnd.ms-excel"
		elseif check("\x10\x08\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- Excel.Sheet.5: clsid 00020810-0000-0000-c000-000000000046
			return "xls", "application/vnd.ms-excel"
		elseif check("\xf4\x55\x4f\xcf\x87\x8f\x47\x4d\x80\xbb\x58\x08\x16\x4b\xb3\xf8") then
			-- Powerpoint.Show.12: clsid cf4f55f4-8f87-4d47-80bb-5808164bb3f8
			return "ppt", "application/vnd.ms-powerpoint"
		elseif check("\x10\x8d\x81\x64\x9b\x4f\xcf\x11\x86\xea\0\xaa\0\xb9\x29\xe8") then
			-- Powerpoint.Show.8: clsid 64818d10-4f9b-11cf-86ea-00aa00b929e8
			return "ppt", "application/vnd.ms-powerpoint"
		elseif check("\x46\xf0\x06\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- TemplateMessage: clsid 0006f046-0000-0000-c000-000000000046
			return "oft", "application/vnd.ms-outlook"
		elseif check("\x0b\x0d\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- MailMessage: clsid 00020d0b-0000-0000-c000-000000000046
			return "msg", "application/vnd.ms-outlook"
		elseif check("\x84\x10\x0c\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then
			-- msi: clsid 000c1084-0000-0000-c000-000000000046
			return "msi", "application/octet-stream"
		elseif -- autodesk inventor: https://knowledge.autodesk.com/search-result/caas/simplecontent/content/documentsubtype-list-common-name-inventors-name-cslid-inv-pro-2021-dev-tools.html
			-- fixtures: https://knowledge.autodesk.com/support/inventor/troubleshooting/caas/downloads/content/inventor-sample-files.html
			check("\x90\xb4\x29\x4d\xb2\x49\xd0\x11\x93\xc3\x7e\x07\x06\x00\x00\x00") or -- Part: clsid 4d29b490-49b2-11d0-93c3-7e07060000
			check("\x03\x42\x46\x9c\xae\x9b\xd3\x11\x8b\xad\x00\x60\xb0\xce\x6b\xb4") or -- Sheet Metal Part: clsid 9c464203-9bae-11d3-8bad-0060b0ce6bb4
			check("\x19\x54\x05\x92\xfa\xb3\xd3\x11\xa4\x79\x00\xc0\x4f\x6b\x95\x31") or -- Generic Proxy Part: clsid 92055419-b3fa-11d3-a479-00c04f6b9531
			check("\x04\x42\x46\x9c\xae\x9b\xd3\x11\x8b\xad\x00\x60\xb0\xce\x6b\xb4") or -- Compatibility Proxy Part: clsid 9c464204-9bae-11d3-8bad-0060b0ce6bb4
			check("\xaf\xd3\x88\x9c\xeb\xc3\xd3\x11\xb7\x9e\x00\x60\xb0\xf1\x59\xef") or -- Catalog Proxy Part: clsid 9c88d3af-c3eb-11d3-b79e-0060b0f159ef
			check("\xd4\x80\x8d\x4d\xb0\xf5\x60\x44\x8c\xea\x4c\xd2\x22\x68\x44\x69")    -- Molded Part Document: clsid 4d8d80d4-f5b0-4460-8cea-4cd222684469
		then
			return "ipt", "application/vnd.autodesk.inventor" -- non-standard
		elseif
			check("\xe1\x81\x0f\xe6\xb3\x49\xd0\x11\x93\xc3\x7e\x07\x06\x00\x00\x00") or -- Assembly: clsid e60f81e1-49b3-11d0-93c3-7e0706000000
			check("\x54\x83\xec\x28\x24\x90\x0f\x44\xa8\xa2\x0e\x0e\x55\xd6\x35\xb0")    -- Weldment: clsid 28ec8354-9024-440f-a8a2-0e0e55d635b0
		then
			return "iam", "application/vnd.autodesk.inventor.assembly"
		elseif
			check("\x80\x3a\x28\x76\xdd\x50\xd3\x11\xa7\xe3\x00\xc0\x4f\x79\xd7\xbc") or -- Presentation: clsid 76283a80-50dd-11d3-a7e3-00c04f79d7bc
			check("\x7d\xc1\xb4\xa2\xd2\xf0\x0f\x4c\x97\x99\xdd\x5f\x71\xdf\xb2\x91")    -- Composite Presentation: clsid a2b4c17d-f0d2-4c0f-9799-dd5f71dfb291
		then
			return "ipn", "application/vnd.autodesk.inventor.presentation" -- non-standard
		elseif check("\xf1\xfd\xf9\xbb\xdc\x52\xd0\x11\x8c\x04\x08\x00\x09\x0b\xe8\xec") then
			-- Drawing: clsid bbf9fdf1-52dc-11d0-8c04-0800090be8ec
			return "idw", "application/vnd.autodesk.inventor.drawing" -- non-standard
		elseif check("\x5d\x5c\xb9\x81\x31\x8e\x65\x4f\x97\x90\xcc\xf6\xec\xab\xd1\x41") then
			-- Design View: clsid 81b95c5d-8e31-4f65-9790-ccf6ecabd141
			return "idv", "application/vnd.autodesk.inventor.designview" -- non-standard
		elseif check("\x30\xb0\xfb\x62\xc7\x24\xd3\x11\xb7\x8d\x00\x60\xb0\xf1\x59\xef") then
			-- iFeature: clsid 62fbb030-24c7-11d3-b78d-0060b0f159ef
			return "ide", "application/vnd.autodesk.inventor.ifeature" -- non-standard
		else
			return "cfb", "application/x-cfb"
		end
	end
	if check("\x41\x52\x52\x4f\x57\x31\0\0") then return "arrow", "application/x-apache-arrow" end
	if check("\x67\x6c\x54\x46\x02\0\0\0") then return "glb", "model/gltf-binary" end
	if check("gimp xcf ") then return "xcf", "image/x-xcf" end
	-- `mdat` MJPEG??
	if check("free", 4) or check("mdat", 4) or check("moov", 4) or check("wide", 4) then return "mov", "video/quicktime" end
	if check("\x49\x49\x52\x4f\x08\0\0\0\x18") then return "orf", "image/x-olympus-orf" end
	if check("\x49\x49\x55\0\x18\0\0\0\x88\xe7\x74\xd8") then return "rw2", "image/x-panasonic-rw2" end
	-- ASF_Header_Object first 80 bytes
	if check("\x30\x26\xb2\x75\x8e\x66\xcf\x11\xa6\xd9") then
		local function readHeader()
			local header = buffer:sub(pos, pos + 15)
			local length = get_u64_le(pos + 16)
			pos = pos + 24
			return header, length
		end
		pos = pos + 30
		while pos + 24 < #buffer do
			local header, header_length = readHeader()
			-- FIXME: header[1] or header[2]?
			local payload = header_length - 24
			-- ASF_Stream_Properties_Object: guid B7DC0791-A9B7-11CF-8EE6-00C00C205365
			if _check(header, "\x91\x07\xdc\xb7\xb7\xa9\xcf\x11\x8e\xe6\0\xc0\x0c\x20\x53\x65") then
				local typeId = buffer:sub(pos, pos + 15)
				pos = pos + 16
				payload = payload - 16
				-- ASF_Audio_Media: guid F8699E40-5B4D-11CF-A8FD-00805F5C442B
				if _check(typeId, "\x40\x9e\x69\xf8\x4d\x5b\xcf\x11\xa8\xfd\0\x80\x5f\x5c\x44\x2b") then return "asf", "audio/x-ms-asf" end
				-- ASF_Video_Media: guid BC19EFC0-5B4D-11CF-A8FD-00805F5C442B
				if _check(typeId, "\xc0\xef\x19\xbc\x4d\x5b\xcf\x11\xa8\xfd\0\x80\x5f\x5c\x44\x2b") then return "asf", "video/x-ms-asf" end
				break
			end
			--- @diagnostic disable-next-line: cast-local-type
			pos = pos + tonumber(payload)
		end
		return "asf", "application/vnd.ms-asf"
	end
	if check("\xab\x4b\x54\x58\x20\x31\x31\xbb\x0d\x0a\x1a\x0a") then return "ktx", "image/ktx" end
	if check_mask("\x7e\x10\x04\x000MIE", 0, "\xff\xf7\xff\0\xff\xff\xff\xff") then return "mie", "application/x-mie" end
	if check("\x27\x0a\0\0\0\0\0\0\0\0\0\0", 2) then return "shp", "application/x-esri-shape" end
	if check("\0\0\0\x0c\x6a\x50\x20\x20\x0d\x0a\x87\x0a") then
		local lookup = {
			jp2 = { "jp2", "image/jp2" },
			jpx = { "jpx", "image/jpx" },
			jpm = { "jpm", "image/jpm" },
			mjp2 = { "mj2", "image/mj2" },
		}
		local type = trim(buffer:sub(pos + 20, pos + 23))
		local ret = lookup[type]
		if not ret then return type, "image/x-" .. type end -- non-standard
		return ret[1], ret[2]
	end
	if check("<!DOCTYPE html>") or check("<!doctype html>") then return "html", "text/html" end
	if check("SQLite format 3\0") then return "sqlite", "application/x-sqlite3" end
	-- unsafe signatures
	if check("\0\0\x01\xba") or check("\0\0\x01\xb3") then return "mpg", "video/mpeg" end
	if check("\0\x01\0\0\0") then return "ttf", "font/ttf" end
	if check("\0\0\x01\0") then return "ico", "image/x-icon" end
	if check("\0\0\x02\0") then return "cur", "image/x-icon" end
	-- unsafe signatures end?
	if check("\xFF\x0A") or check("\0\0\0\x0cJXL \x0d\x0a\x87\x0a") then return "jxl", "image/jxl" end
	if check("FUJIFILMCCD-RAW") then return "raf", "image/x-fujifilm-raf" end
	if check("Extended Module:") then return "xm", "audio/x-xm" end
	if check("Creative Voice File") then return "voc", "audio/x-voc" end
	if check("\x04\0\0\0") and #buffer >= pos + 16 then
		local json_size = get_u32_le(pos + 12)
		if #buffer >= pos + json_size + 16 then
			local header = buffer:sub(pos + 16, pos + json_size + 15)
			json_parse = json_parse or require("dep.lunajson").json_to_value
			local _, json = pcall(json_parse, header)
			if json and json.files then return "asar", "application/x-asar" end
		end
	end
	if check("\x06\x0e\x2b\x34\x02\x05\x01\x01\x0d\x01\x02\x01\x01\x02") then return "mxf", "application/mxf" end
	if check("SCRM", 44) then return "s3m", "audio/x-s3m" end
	if (check("G") and check("G", 188)) or (check("G", 4) and check("G", 196)) then return "mts", "video/mp2t" end
	if check("BOOKMOBI", 60) then return "mobi", "application/x-mobipocket-ebook" end
	if check("DICM", 128) then return "dcm", "application/dicom" end
	-- ShellLink: clsid 00021401-0000-0000-C000-000000000046
	if check("\x4c\0\0\0\x01\x14\x02\0\0\0\0\0\xc0\0\0\0\0\0\0\x46") then return "lnk", "application/x-ms-shortcut" end -- non-standard
	if check("book\0\0\0\0mark\0\0\0\0") then return "alias", "application/x-apple-alias" end -- non-standard
	if check("LP", 34) and (check("\0\0\x01", 8) or check("\x01\0\x02", 8) or check("\x02\0\x02", 8)) then return "eot", "application/vnd.ms-fontobject" end
	if check("\x06\x06\xed\xf5\xd8\x1d\x46\xe5\xbd\x31\xef\xe7\xfe\x74\xb7\x1d") then return "indd", "application/x-indesign" end
	-- FIXME: is view.buffer == buffer?
	local sum = (tonumber(trim(buffer:sub(149, 154):gsub("\0.*$", "")), 8) or (0/0)) - 256
	if sum == sum then -- not nan
		for i = 1, 148 do sum = sum - buffer:byte(i) end
		for i = 157, 512 do sum = sum - buffer:byte(i) end
		if sum == 0 then return "tar", "application/x-tar" end
	end
	if check("\xfe\xff") then -- utf16le bom
		if check("\0<\0?\0x\0m\0l", 2) then return "xml", "application/xml" end
		return
	end
	if check("\xff\xfe") then -- utf16be bom
		if check("<\0?\0x\0m\0l\0", 2) then
			if buffer:sub(1, 256):match("I\0n\0v\0e\0n\0t\0o\0r\0P\0r\0o\0j\0e\0c\0t") then return "ipj", "application/vnd.autodesk.inventor.project" end -- non-standard
			return "xml", "application/xml"
		end
		if check("\xff\x0eS\0k\0e\0t\0c\0h\0U\0p\0 \0M\0o\0d\0e\0l\0", 2) then return "skp", "application/vnd.sketchup.skp" end
	end
	if check("-----BEGIN PGP MESSAGE-----") then return "pgp", "application/pgp-encrypted" end
	if #buffer >= 2 and check_mask("\xff\xe0", 0, "\xff\xe0") then
		if check_mask("\x10", 1, "\x16") then
			if check_mask("\x08", 1, "\x08") then return "aac", "audio/aac" end
			return "aac", "audio/aac"
		end
		if check_mask("\x02", 1, "\x06") then return "mp3", "audio/mpeg" end
		if check_mask("\x04", 1, "\x06") then return "mp2", "audio/mpeg" end
		if check_mask("\x06", 1, "\x06") then return "mp1", "audio/mpeg" end
	end
	if check("M.K.", 0x438) then return "mod", "audio/mod" end
	if check("CD001", 0x8001) or check("CD001", 0x8801) or check("CD001", 0x9001) then return "iso", "application/x-iso9660-image" end
	if buffer:find("^SVF v%d+%.?%d*\0", pos) then return "svf", "image/vnd.svf" end
	if check("AutoCAD Binary DXF") then return "dxf", "model/vnd.autodesk.dxf" end
	if buffer:find("^ *%d+\r\n", pos) then
		while true do
			local _, id_end = buffer:find("^ *%d+\r\n", pos)
			if not id_end then break end
			local _, name_end = buffer:find("^.-\r\n", id_end + 1)
			if not name_end then break end
			local name = buffer:sub(id_end + 1, name_end - 2)
			if name == "$ACADVER" then return "dxf", "model/vnd.autodesk.dxf" end
			pos = name_end + 1
		end
	end
end

return mod

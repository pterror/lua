--[[FIXME: consider moving non-essential features to a separate file so parsing can be skipped]]
--[[ported from https://github.com/commonmark/cmark/commit/7195c6735f29be947ddc41f86c9ddfc8621d33b9]]
--[[IMPL: render (`cmark_render`)]]
--[[`CR` is not strictly `cr(write)`; it's `renderer.cr(write)`]]
--[[FIXME: to implement `cr`, make renderers cache the last non-empty string written]]
--[[notes:  ]]
--[[`commonmark_writers.strong` was `if entering then write("**") else write("**") end` in original c.]]
--[[similar applies to `commonmark_writers.emph`]]
--[[FIXME: extract renderers to separate files]]

local cmark_entities = require("dep.cmark_entities")

local mod = {}

--[[@enum cmark_options]]
mod.options = {
	--[[render options]]

	sourcepos = 0x2, --[[Include a `data-sourcepos` attribute on all block elements.]]
	hardbreaks = 0x4, --[[Render `softbreak` elements as hard line breaks.]]
	safe = 0x8, --[[Deprecated (on by default); use `options.unsafe` to disable.]]
	--[[
		Render raw HTML and unsafe links (`javascript:`, `vbscript:`,
		`file:`, and `data:`, except for `image/png`, `image/gif`,
		`image/jpeg`, or `image/webp` mime types).  By default,
		raw HTML is replaced by a placeholder HTML comment. Unsafe
		links are replaced by empty strings.
	]]
	unsafe = 0x20000,
	nobreaks = 0x10, --[[Render `softbreak` elements as spaces.]]
	--[[parse options]]
	normalize = 0x100, --[[Deprecated (no effect)]]
	--[[Validate UTF-8 in the input before parsing, replacing illegal]]
	--[[sequences with the replacement character U+FFFD.]]
	validate_utf8 = 0x200,
	smart = 0x400, --[[Convert straight quotes to curly, `---` to em dashes, `--` to en dashes.]]
}

--[[@alias cmark_node_type "none"|"document"|"block_quote"|"list"|"item"|"code_block"|"html_block"|"custom_block"|"paragraph"|"heading"|"thematic_break"|"text"|"softbreak"|"linebreak"|"code"|"html_inline"|"custom_inline"|"emph"|"strong"|"link"|"image"]]
--[[@alias cmark_event_type "none"|"done"|"enter"|"exit"]]
--[[@alias cmark_list_type "none"|"bullet"|"ordered"]]
--[[@alias cmark_delim_type "none"|"period"|"paren"]]
--[[@alias cmark_link_type "none"|"url_autolink"|"email_autolink"|"normal"|"internal"]]
--[[@alias cmark_escaping "literal"|"normal"|"title"|"url"]]

local replacement_character = "\xef\xbf\xbd"
local emdash = "\xE2\x80\x94"
local endash = "\xE2\x80\x93"
local ellipses = "\xE2\x80\xA6"
local leftdoublequote = "\xE2\x80\x9C"
local rightdoublequote = "\xE2\x80\x9D"
local leftsinglequote = "\xE2\x80\x98"
local rightsinglequote = "\xE2\x80\x99"
local maxbackticks = 1000
local entity_min_length = 2
local entity_max_length = 32
local max_indent = 40
local max_link_label_length = 1000

--[[@alias cmark_node cmark_base_node|cmark_list_node|cmark_code_node|cmark_heading_node|cmark_link_node|cmark_custom_node]]

--[[@class cmark_base_node]]
--[[@field next cmark_node?]]
--[[@field prev cmark_node?]]
--[[@field parent cmark_node?]]
--[[@field first_child cmark_node?]]
--[[@field last_child cmark_node?]]
--[[@field user_data unknown]]
--[[@field data string `node.len` replaced with `#node.data`]]
--[[@field start_line integer]]
--[[@field start_column integer]]
--[[@field end_line integer]]
--[[@field end_column integer]]
--[[@field type cmark_node_type]]
--[[@field flag integer]]

--[[@class cmark_list_node: cmark_base_node]]
--[[@field marker_offset integer]]
--[[@field padding integer]]
--[[@field start integer]]
--[[@field list_type cmark_list_type]]
--[[@field delimiter cmark_delim_type]]
--[[@field bullet_char integer `char`]]
--[[@field tight boolean]]

--[[@class cmark_code_node: cmark_base_node]]
--[[@field info string]]
--[[@field fence_length integer]]
--[[@field fence_offset integer]]
--[[@field fence_char integer `char`]]
--[[@field fenced integer]]

--[[@class cmark_heading_node: cmark_base_node]]
--[[@field internal_offset integer]]
--[[@field level integer]]
--[[@field setext boolean]]

--[[@class cmark_link_node: cmark_base_node]]
--[[@field url string]]
--[[@field title string]]

--[[@class cmark_custom_node: cmark_base_node]]
--[[@field on_enter string]]
--[[@field on_exit string]]

local utf8proc_utf8class = {
	[0] =
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
	2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
	4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0,
}

--[[@param str string]] --[[@param str_len integer]]
mod.utf8proc_charlen = function (str, str_len)
	if str_len == 0 then return 0 end
	local length = utf8proc_utf8class[str:byte(1)]
	if length == 0 then return -1 end
	if str_len >= 0 and length > str_len then return -str_len end
	for i = 2, length do
		if bit.band(str:byte(i), 0xC0) ~= 0x80 then return -i end
	end
	return length
end

--[[@param str string]] --[[@param str_len integer]]
mod.utf8proc_valid = function (str, str_len)
	local length = utf8proc_utf8class[str:byte(1)]
	if length == 0 then return -1 end
	if length > str_len then return -str_len end
	if length == 2 then
		if bit.band(str[1], 0xc0) ~= 0x80 then return -1 end
		if str[0] < 0xc2 then return -length end --[[Overlong]]
	elseif length == 3 then
		local b1, b2, b3 = str:byte(1, 3)
		if bit.band(b2, 0xc0) ~= 0x80 then return -1 end
		if bit.band(b3, 0xc0) ~= 0x80 then return -2 end
		if b1 == 0xe0 then
			if b2 < 0xa0 then return -length end --[[Overlong]]
		elseif b1 == 0xed then
			if b2 >= 0xa0 then return -length end --[[Surrogate]]
		end
	else --[[length must be 4]]
		local b1, b2, b3, b4 = str:byte(1, 4)
		if bit.band(b2,  0xc0) ~= 0x80 then return -1 end
		if bit.band(b3, 0xc0) ~= 0x80 then return -2 end
		if bit.band(b4,  0xc0) ~= 0x80 then return -3 end
		if b1 == 0xf0 then
			if b2 < 0x90 then return -length end --[[Overlong]]
		elseif b1 >= 0xf4 then
			if b1 > 0xf4 or b2 >= 0x90 then return -length end --[[Above 0x10FFFF]]
		end
	end
	return length
end

--[[@param write fun(part: string)]] --[[@param line string]] --[[@param size integer]]
mod.utf8proc_check = function (write, line, size)
	local i = 1
	while i < size do
		local org = i
		local charlen = 0
		while i <= size do
			local code = line:byte(i)
			if code < 0x80 and code ~= 0 then
				i = i + 1
			elseif code >= 0x80 then
				charlen = mod.utf8proc_valid(line + i, size - i);
				if charlen < 0 then charlen = -charlen; break end
				i = i + charlen;
				--[[ASCII NUL is technically valid but rejected for security reasons.]]
			elseif code == 0 then charlen = 1; break end
		end
		if i > org then write(line:sub(org, i - 1)) end
		if i > size then break
		else write(replacement_character); i = i + charlen end --[[Invalid UTF-8]]
	end
end

--[[@return integer length, integer c]] --[[@param str string]] --[[@param str_len integer]]
mod.utf8proc_iterate = function (str, str_len)
	local uc = -1
	local length = mod.utf8proc_charlen(str, str_len)
	if length < 0 then return -1, -1 end

	if length == 1 then uc = str:byte(1)
	elseif length == 2 then
		uc = bit.lshift(bit.band(str[0], 0x1F), 6) + bit.band(str[1], 0x3F)
		if uc < 0x80 then uc = -1 end
	elseif length == 3 then
		uc = bit.lshift(bit.band(str[0], 0x0F), 12) + bit.lshift(bit.band(str[1], 0x3F), 6) + bit.band(str[2], 0x3F)
		if uc < 0x800 or (uc >= 0xD800 and uc < 0xE000) then uc = -1 end
	else --[[length == 4]]
		uc = (
			bit.lshift(bit.band(str[0], 0x07), 18) + bit.lshift(bit.band(str[1], 0x3F), 12) +
			bit.lshift(bit.band(str[2], 0x3F), 6) + bit.band(str[3], 0x3F)
		)
		if uc < 0x10000 or uc >= 0x110000 then uc = -1 end
	end
	if uc < 0 then return -1, -1 end
	return length, uc
end

mod.utf8proc_encode_char = function (write, uc)
	if uc < 0x80 then write(string.char(uc))
	elseif uc < 0x800 then write(string.char(bit.bor(0xc0, bit.rshift(uc, 6)), bit.bor(0x80, bit.band(uc, 0x3f))))
	elseif uc == 0xffff then write(string.char(0xff))
	elseif uc == 0xfffe then write(string.char(0xfe))
	elseif uc < 0x10000 then
		write(string.char(bit.bor(0xe0, bit.rshift(uc, 12)), bit.bor(0x80, bit.band(bit.rshift(uc, 6), 0x3f)), bit.bor(0x80, bit.band(uc, 0x3f))))
	elseif uc < 0x110000 then
		write(string.char(
			bit.bor(0xf0, bit.rshift(uc, 18)), bit.bor(0x80, bit.band(bit.rshift(uc, 12), 0x3f)),
			bit.bor(0x80, bit.band(bit.rshift(uc, 6), 0x3f)), bit.bor(0x80, bit.band(uc, 0x3f))
		))
	else write(replacement_character) end
end

--[[@param dest fun(part: string)]] --[[@param str string]] --[[@param len integer]]
mod.utf8proc_case_fold = function (dest, str, len)
	--[[FIXME: #define bufpush(x) utf8proc_encode_char(dest, x)]]
	while len > 0 do
		local char_len, c = mod.utf8proc_iterate(str, len)
		if char_len >= 0 then
			--[[FIXME: #include "case_fold_switch.inc"]]
		else
			dest(replacement_character)
			char_len = -char_len
		end
		str = str + char_len --[[FIXME: conver tto lua]]
		len = len - char_len
	end
end

--[[matches anything in the Zs class, plus LF, CR, TAB, FF.]]
mod.utf8proc_is_space = function (uc)
	return (
		uc == 9 or uc == 10 or uc == 12 or uc == 13 or uc == 32 or
		uc == 160 or uc == 5760 or (uc >= 8192 and uc <= 8202) or uc == 8239 or
		uc == 8287 or uc == 12288
	)
end

--[[matches anything in the P[cdefios] classes.]]
mod.utf8proc_is_punctuation = function (uc)
	return (
		(uc < 128 and ispunct(uc)) or uc == 161 or uc == 167 or
		uc == 171 or uc == 182 or uc == 183 or uc == 187 or uc == 191 or
		uc == 894 or uc == 903 or (uc >= 1370 and uc <= 1375) or uc == 1417 or
		uc == 1418 or uc == 1470 or uc == 1472 or uc == 1475 or uc == 1478 or
		uc == 1523 or uc == 1524 or uc == 1545 or uc == 1546 or uc == 1548 or
		uc == 1549 or uc == 1563 or uc == 1566 or uc == 1567 or
		(uc >= 1642 and uc <= 1645) or uc == 1748 or (uc >= 1792 and uc <= 1805) or
		(uc >= 2039 and uc <= 2041) or (uc >= 2096 and uc <= 2110) or uc == 2142 or
		uc == 2404 or uc == 2405 or uc == 2416 or uc == 2800 or uc == 3572 or
		uc == 3663 or uc == 3674 or uc == 3675 or (uc >= 3844 and uc <= 3858) or
		uc == 3860 or (uc >= 3898 and uc <= 3901) or uc == 3973 or
		(uc >= 4048 and uc <= 4052) or uc == 4057 or uc == 4058 or
		(uc >= 4170 and uc <= 4175) or uc == 4347 or (uc >= 4960 and uc <= 4968) or
		uc == 5120 or uc == 5741 or uc == 5742 or uc == 5787 or uc == 5788 or
		(uc >= 5867 and uc <= 5869) or uc == 5941 or uc == 5942 or
		(uc >= 6100 and uc <= 6102) or (uc >= 6104 and uc <= 6106) or
		(uc >= 6144 and uc <= 6154) or uc == 6468 or uc == 6469 or uc == 6686 or
		uc == 6687 or (uc >= 6816 and uc <= 6822) or (uc >= 6824 and uc <= 6829) or
		(uc >= 7002 and uc <= 7008) or (uc >= 7164 and uc <= 7167) or
		(uc >= 7227 and uc <= 7231) or uc == 7294 or uc == 7295 or
		(uc >= 7360 and uc <= 7367) or uc == 7379 or (uc >= 8208 and uc <= 8231) or
		(uc >= 8240 and uc <= 8259) or (uc >= 8261 and uc <= 8273) or
		(uc >= 8275 and uc <= 8286) or uc == 8317 or uc == 8318 or uc == 8333 or
		uc == 8334 or (uc >= 8968 and uc <= 8971) or uc == 9001 or uc == 9002 or
		(uc >= 10088 and uc <= 10101) or uc == 10181 or uc == 10182 or
		(uc >= 10214 and uc <= 10223) or (uc >= 10627 and uc <= 10648) or
		(uc >= 10712 and uc <= 10715) or uc == 10748 or uc == 10749 or
		(uc >= 11513 and uc <= 11516) or uc == 11518 or uc == 11519 or
		uc == 11632 or (uc >= 11776 and uc <= 11822) or
		(uc >= 11824 and uc <= 11842) or (uc >= 12289 and uc <= 12291) or
		(uc >= 12296 and uc <= 12305) or (uc >= 12308 and uc <= 12319) or
		uc == 12336 or uc == 12349 or uc == 12448 or uc == 12539 or uc == 42238 or
		uc == 42239 or (uc >= 42509 and uc <= 42511) or uc == 42611 or
		uc == 42622 or (uc >= 42738 and uc <= 42743) or
		(uc >= 43124 and uc <= 43127) or uc == 43214 or uc == 43215 or
		(uc >= 43256 and uc <= 43258) or uc == 43310 or uc == 43311 or
		uc == 43359 or (uc >= 43457 and uc <= 43469) or uc == 43486 or
		uc == 43487 or (uc >= 43612 and uc <= 43615) or uc == 43742 or
		uc == 43743 or uc == 43760 or uc == 43761 or uc == 44011 or uc == 64830 or
		uc == 64831 or (uc >= 65040 and uc <= 65049) or
		(uc >= 65072 and uc <= 65106) or (uc >= 65108 and uc <= 65121) or
		uc == 65123 or uc == 65128 or uc == 65130 or uc == 65131 or
		(uc >= 65281 and uc <= 65283) or (uc >= 65285 and uc <= 65290) or
		(uc >= 65292 and uc <= 65295) or uc == 65306 or uc == 65307 or
		uc == 65311 or uc == 65312 or (uc >= 65339 and uc <= 65341) or
		uc == 65343 or uc == 65371 or uc == 65373 or
		(uc >= 65375 and uc <= 65381) or (uc >= 65792 and uc <= 65794) or
		uc == 66463 or uc == 66512 or uc == 66927 or uc == 67671 or uc == 67871 or
		uc == 67903 or (uc >= 68176 and uc <= 68184) or uc == 68223 or
		(uc >= 68336 and uc <= 68342) or (uc >= 68409 and uc <= 68415) or
		(uc >= 68505 and uc <= 68508) or (uc >= 69703 and uc <= 69709) or
		uc == 69819 or uc == 69820 or (uc >= 69822 and uc <= 69825) or
		(uc >= 69952 and uc <= 69955) or uc == 70004 or uc == 70005 or
		(uc >= 70085 and uc <= 70088) or uc == 70093 or
		(uc >= 70200 and uc <= 70205) or uc == 70854 or
		(uc >= 71105 and uc <= 71113) or (uc >= 71233 and uc <= 71235) or
		(uc >= 74864 and uc <= 74868) or uc == 92782 or uc == 92783 or
		uc == 92917 or (uc >= 92983 and uc <= 92987) or uc == 92996 or
		uc == 113823
	)
end

--[[@class cmark_iter_state]]
--[[@field ev_type cmark_event_type]]
--[[@field node cmark_node]]

--[[@class cmark_iter]]
--[[@field root cmark_node]]
--[[@field cur cmark_iter_state]]
--[[@field next cmark_iter_state]]

local is_leaf = {
	html_block = true, thematic_break = true, code_block = true, text = true,
	softbreak = true, linebreak = true, code = true, html_inline = true,
}

--[[@return cmark_iter]] --[[@param root cmark_node]]
local iter_new = function (root)
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	if not root then return nil end
	return {
		root = root,
		cur = { ev_type = "none", node = nil },
		next = { ev_type = "enter", node = root },
	}
end

--[[@return cmark_event_type]] --[[@param iter cmark_iter]]
local iter_next = function (iter)
	local ev_type = iter.next.ev_type
	local node = iter.next.node
	iter.cur.ev_type = ev_type
	iter.cur.node = node
	if ev_type == "done" then return ev_type end
	if ev_type == "enter" and not is_leaf(node.type) then
		if node.first_child then iter.next.ev_type = "exit"
		else iter.next.ev_type = "enter"; iter.next.node = node.first_child end
	elseif node == iter.root then
		iter.next.ev_type = "done"
		iter.next.node = nil
	elseif node.next then
		iter.next.ev_type = "enter"
		iter.next.node = node.next;
	elseif node.parent then
		iter.next.ev_type = "exit"
		iter.next.node = node.parent;
	else
		--[[assert(false)]]
		iter.next.ev_type = "done"
		iter.next.node = nil
	end
	return ev_type
end

--[[@param iter cmark_iter]] --[[@param current cmark_node]] --[[@param event_type cmark_event_type]]
local iter_reset = function (iter, current, event_type)
	iter.next.ev_type = event_type
	iter.next.node = current
	iter_next(iter)
end

--[[@param root cmark_node]]
local consolidate_text_nodes = function (root)
	if not root then return end
	local iter = iter_new(root)
	local parts = {} --[[@type string[] ]]
	local buf = function (part) parts[#parts+1] = part end --[[@param part string]]
	local ev_type = iter_next(iter)
	while ev_type ~= "done" do
		local cur = iter.cur.node
		if ev_type == "enter" and cur.type == "text" and cur.next and cur.next.type == "text" then
			parts = {}
			buf(cur.data)
			local tmp = cur.next
			while tmp and tmp.type == "text" do
				iter_next(iter); buf(tmp.data); cur.end_column = tmp.end_column; next = tmp.next; tmp = next
			end
			cur.len = buf.size
			cur.data = table.concat(parts)
		end
		ev_type = iter_next(iter)
	end
end

--[[FIXME: not to be confusd with the other `cr`...]]
--[[FIXME: writers currently accept `write`, not `renderer`]]
--[[@param renderer cmark_renderer]]
local cr = function (renderer) if renderer.need_cr < 1 then renderer.need_cr = 1 end end
--[[FIXME: writers currently accept `write`, not `renderer`]]
--[[@param renderer cmark_renderer]]
local blankline = function (renderer) if renderer.need_cr < 2 then renderer.need_cr = 2 end end

--[[@param renderer cmark_renderer]] --[[@param source string]] --[[@param wrap boolean]] --[[@param escape cmark_escaping]]
local out = function (renderer, source, wrap, escape)
	local length = #source --[[FIXME remove]]
	local i = 1
	local k = renderer.buffer.size - 1 --[[FIXME: remove renderer.buffer?]]
	wrap = wrap and not renderer.no_linebreaks
	if renderer.in_tight_list_item and renderer.need_cr > 1 then renderer.need_cr = 1 end
	while renderer.need_cr do
		--[[fIXME: mutating pointer contents]]
		if k < 0 or renderer.buffer.ptr[k] == '\n' then k = k - 1
		else
			renderer.buffer("\n")
			if renderer.need_cr > 1 then renderer.buffer(renderer.prefix) end
		end
		renderer.column = 0
		renderer.last_breakable = 0
		renderer.begin_line = true
		renderer.begin_content = true
		renderer.need_cr = renderer.need_cr - 1
	end

	while i <= length do --[[FIXME: off by one]]
		if renderer.begin_line then
			renderer.buffer(renderer.prefix)
			--[[note: this assumes prefix is ascii:]]
			renderer.column = #renderer.prefix
		end
		--[[FIXME: adding to string]]
		local len, c = mod.utf8proc_iterate(source + i, length - i)
		if len == -1 then return end --[[return without rendering rest of string]]
		local nextc = source:byte(i + len)
		if c == 32 and wrap then
			if not renderer.begin_line then
				local last_nonspace = renderer.buffer.size
				renderer.buffer(" ")
				renderer.column = renderer.column + 1
				renderer.begin_line = false
				renderer.begin_content = false
				while source:byte(i + 1) == 0x20 --[[ ]] do i = i + 1 end
				--[[We don't allow breaks that make a digit the first character because this causes problems with commonmark output.]]
				if not isdigit(source[i + 1]) then
					renderer.last_breakable = last_nonspace;
				end
			end
		elseif escape == "literal" then
			if c == 10 then
				renderer.buffer("\n")
				renderer.column = 0;
				renderer.begin_line = true;
				renderer.begin_content = true;
				renderer.last_breakable = 0;
			else
				cmark_render_code_point(renderer, c)
				renderer.begin_line = false;
				--[[
					we don't set 'begin_content' to false til we've
					finished parsing a digit.  Reason:  in commonmark
					we need to escape a potential list marker after
					a digit:
				]]
				renderer.begin_content = renderer.begin_content and isdigit(c) == 1
			end
		else
			(renderer.outc)(renderer, escape, c, nextc);
			renderer.begin_line = false;
			renderer.begin_content = renderer.begin_content and isdigit(c) == 1
		end

		--[[If adding the character went beyond width, look for an earlier place where the line could be broken:]]
		if renderer.width > 0 and renderer.column > renderer.width and not renderer.begin_line and renderer.last_breakable > 0 then
			local src = renderer.buffer + renderer.last_breakable + 1 --[[FIXME: pointer arithmetic]]
			local remainder = renderer.buffer:sub(renderer.last_breakable + 1 --[[off by one?]])
			cmark_strbuf_truncate(renderer.buffer, renderer.last_breakable)
			renderer.buffer("\n")
			renderer.buffer(renderer.prefix)
			renderer.buffer(remainder)
			renderer.column = #renderer.prefix + remainder_len
			renderer.last_breakable = 0
			renderer.begin_line = false
			renderer.begin_content = false
		end
		i = i + len
	end
end

--[[Assumes no newlines, assumes ascii content]]
--[[@param renderer cmark_renderer]] --[[@param s string]]
mod.render_ascii = function (renderer, s)
	local origsize = #renderer.buffer
	renderer.buffer(s) --[[FIXME: renderer.buffer isn't how we're doing it in lua]]
	renderer.column = renderer.column + renderer.buffer.size - origsize
end

--[[@param renderer cmark_renderer]] --[[@param c integer]]
mod.render_code_point = function (renderer, c)
	mod.utf8proc_encode_char(renderer.buffer, c)
	renderer.column = renderer.column + 1
end

--[[@param root cmark_node]]
--[[@param options integer]]
--[[@param width integer]]
--[[@param outc fun(renderer: cmark_renderer, escape: cmark_escaping, idk: integer, c: integer)]]
--[[@param render_node fun(renderer: cmark_renderer, node: cmark_node, ev_type: cmark_event_type, options: cmark_options)]]
mod.render = function (root, options, width, outc, render_node)
	local iter = iter_new(root)
	local renderer = { --[[@class cmark_renderer]]
		buffer = {} --[[@type string[] ]],
		options = options, prefix = "", idk1 = 0, width = width, idk2 = 0, idk3 = 0,
		no_linebreaks = true, idk4 = true, in_tight_list_item = false,
		false,  nil, outc = outc, cr = cr, blankline = blankline, out = out,
	}

	local ev_type = iter_next(iter)
	while ev_type ~= "done" do
		local cur = iter_get_node(iter)
		if not render_node(renderer, cur, ev_type, options) then
			--[[a false value causes us to skip processing the node's contents.  this is used for autolinks.]]
			iter_reset(iter, cur, "exit")
		end
		ev_type = iter_next(iter)
	end
	--[[ensure final newline]]
	if renderer.buffer.size == 0 or renderer.buffer.ptr[renderer.buffer.size - 1] ~= '\n' then
		renderer.buffer("\n")
	end
	return table.concat(renderer.buffer)
end

local is_block_type = {
	document = true, block_quote = true, list = true, item = true, code_block = true, html_block = true,
	custom_block = true, paragraph = true, heading = true, thematic_break = true,
}

--[[@param node cmark_node]]
local is_block = function (node) return node and is_block_type[node.type] or false end

local is_inline_type = {
	text = true, softbreak = true, linebreak = true, code = true, html_inline = true,
	custom_inline = true, emph = true, strong = true, link = true, image = true,
}

--[[@param node cmark_node]]
local is_inline = function (node) return node and is_inline_type[node.type] or false end

local can_containers = {} --[[@type table<cmark_node_type, fun(child: cmark_node): boolean>]]
mod.can_containers = can_containers
can_containers.document = function (child) return is_block(child) and child.type ~= "item" end
can_containers.block_quote = can_containers.document
can_containers.item = can_containers.item
can_containers.node_list = function (child) return child.type == "item" end
can_containers.custom_block = function () return true end
can_containers.paragraph = is_inline
can_containers.heading = can_containers.paragraph
can_containers.emph = can_containers.paragraph
can_containers.strong = can_containers.paragraph
can_containers.link = can_containers.paragraph
can_containers.image = can_containers.paragraph
can_containers.custom_inline = can_containers.paragraph

--[[@param node cmark_node]] --[[@param child cmark_node]]
local can_contain = function (node, child)
	if not node or not child or node == child then return false end
	if child.first_child then
		local cur = node.parent
		while cur do
			if cur == child then return false end
			cur = cur.parent
		end
	end
	if child.type == "document" then return false end
	local can_container = can_containers[node.type]
	return can_container and can_container(child) or false
end

local node_initializers = {} --[[@type table<cmark_node_type, fun(node: cmark_node)>]]
mod.node_initializers = node_initializers
node_initializers.heading = function (node) node.level = 1 end
node_initializers.list = function (node) node.list_type = "bullet"; node.start = 0; node.tight = false end

--[[@return cmark_node]] --[[@param type cmark_node_type]]
local node_new = function (type)
	local node = { type = type }
	local initializer = node_initializers[type]
	if initializer then initializer(node) end
	return node
end

--[[@param node cmark_node]]
local node_unlink = function (node)
	if not node then return end
	if node.prev then node.prev.next = node.next end
	if node.next then node.next.prev = node.prev end
	local parent = node.parent
	if parent then
		if parent.first_child == node then parent.first_child = node.next end
		if parent.last_child == node then parent.last_child = node.prev end
	end
end

--[[@param node cmark_node]]
local node_unlink = function (node) node_unlink(node); node.next = nil; node.prev = nil; node.parent = nil end

--[[@param node cmark_node]] --[[@param sibling cmark_node]]
local node_insert_before = function (node, sibling)
	if not node or not sibling then return false end
	if not node.parent or not can_contain(node.parent, sibling) then return false end
	node_unlink(sibling)
	local old_prev = node.prev
	if old_prev then old_prev.next = sibling end
	sibling.prev = old_prev
	sibling.next = node
	node.prev = sibling
	local parent = node.parent
	sibling.parent = parent
	if parent and not old_prev then parent.first_child = sibling end
	return true
end

--[[@param node cmark_node]] --[[@param sibling cmark_node]]
local node_insert_after = function (node, sibling)
	if not node or not sibling then return false end
	if not node.parent or not can_contain(node.parent, sibling) then return false end
	node_unlink(sibling)
	local old_next = node.next
	if old_next then old_next.prev = sibling end
	sibling.next = old_next
	sibling.prev = node
	node.next = sibling
	local parent = node.parent
	sibling.parent = parent
	if parent and not old_next then parent.last_child = sibling end
	return true
end

--[[@param oldnode cmark_node]] --[[@param newnode cmark_node]]
local node_replace = function (oldnode, newnode)
	if not node_insert_before(oldnode, newnode) then return false end
	node_unlink(oldnode)
	return true
end

--[[@param node cmark_node]] --[[@param child cmark_node]]
local node_prepend_child = function (node, child)
	if not can_contain(node, child) then return false end
	node_unlink(child)
	local old_first_child = node.first_child
	child.next = old_first_child
	child.prev = nil
	child.parent = node
	node.first_child = child
	if old_first_child then old_first_child.prev = child
	else node.last_child = child end
	return true
end

--[[@param node cmark_node]] --[[@param child cmark_node]]
local cmark_node_append_child = function (node, child)
	if not can_contain(node, child) then return false end
	node_unlink(child)
	local old_last_child = node.last_child
	child.next = nil
	child.prev = old_last_child
	child.parent = node
	node.last_child = child
	if old_last_child then old_last_child.next = child
	else node.first_child = child end
	return true
end

--[[@param out file*]] --[[@param node cmark_node]] --[[@param elem string]]
local print_error = function (out, node, elem)
	if not out then return end
	out:write(("Invalid '%s' in node type %s at %d:%d\n"):format(elem, node.type, node.start_line, node.start_column))
end

--[[@param node cmark_node]] --[[@param out file*]]
local node_check = function (node, out)
	if not node then return 0 end
	local errors = 0
	local cur = node
	while true do
		if cur.first_child then
			if cur.first_child.prev then
				print_error(out, cur.first_child, "prev")
				cur.first_child.prev = nil
				errors = errors + 1
			end
			if cur.first_child.parent ~= cur then
				print_error(out, cur.first_child, "parent")
				cur.first_child.parent = cur
				errors = errors + 1
			end
			cur = cur.first_child
			goto continue
		end
		::next_sibling::
		if cur == node then break end
		if cur.next then
			if cur.next.prev ~= cur then
				print_error(out, cur.next, "prev")
				cur.next.prev = cur
				errors = errors + 1
			end
			if cur.next.parent ~= cur.parent then
				print_error(out, cur.next, "parent")
				cur.next.parent = cur.parent
				errors = errors + 1
			end
			cur = cur.next
			goto continue
		end
		if cur.parent.last_child ~= cur then
			print_error(out, cur.parent, "last_child")
			cur.parent.last_child = cur
			errors = errors + 1
		end
		cur = cur.parent
		goto next_sibling
		::continue::
	end
	return errors
end

--[[@return string?]] --[[@param ref string]]
local normalize_reference = function (ref)
	if not ref or #ref == 0 then return nil end
	local parts = {} --[[@type string[] ]]
	local normalized = function (part) parts[#parts+1] = part end --[[@param part string]]
	utf8proc_case_fold(normalized, ref, #ref)
	strbuf_trim(normalized)
	strbuf_normalize_whitespace(normalized)
	if #normalized == 0 then return nil end
	return table.concat(parts)
end

--[[@param map cmark_reference_map]] --[[@param label string]] --[[@param url string]] --[[@param title string]]
local reference_create = function (map, label, url, title)
	local reflabel = normalize_reference(label)
	if not reflabel then return end
	--[[assert(map.sorted == nil)]]
	local ref = {
		label = reflabel, url = clean_url(url), title = clean_title(title),
		age = map.size, next = map.refs
	}
	if ref.url then ref.size = ref.size + #ref.url end
	if ref.title then ref.size = ref.size + #ref.title end
	map.refs = ref
	map.size = map.size + 1
end

--[[@param a string]] --[[@param b string]]
local labelcmp = function (a, b) return a > b and 1 or a < b and -1 or 0 end

local refcmp = function (p1, p2)
	local res = labelcmp((p1 --[[@as cmark_reference]]).label, (p2  --[[@as cmark_reference]]).label)
	return res ~= 0 and res or ((p1 --[[@as cmark_reference]]).age - (p2 --[[@as cmark_reference]]).age)
end

local refsearch = function (label, p2) return labelcmp(label, (p2 --[[@as cmark_reference]]).label) end

--[[@pram map cmark_reference_map]]
local sort_references = function (map)
	local last = 1
	local size = map.size
	local r = map.refs
	local sorted = {}
	while r do sorted[#sorted+1] = r; r = r.next end
	table.sort(sorted, function (a, b) return refcmp(a, b) > 0 end)
	for i = 2, size do
		if labelcmp(sorted[i].label, sorted[last].label) ~= 0 then
			last = last + 1
			sorted[last] = sorted[i]
		end
	end
	map.sorted = sorted
	map.size = last + 1
end

--[[@param map cmark_reference_map]] --[[@param label string]]
local reference_lookup = function (map, label)
	if #label < 1 or #label > max_link_label_length then return nil end
	if map == nil or map.size == 0 then return nil end
	local ref do
		local norm = normalize_reference(label)
		if not norm then return nil end
		if not map.sorted then sort_references(map) end
		ref = bsearch(norm, map.sorted, refsearch)
	end
	if ref then
		if map.max_ref_size and ref.size > map.max_ref_size - map.ref_size then return nil end
		map.ref_size = map.ref_size + ref.size
	end
	return ref
end

--[[@class cmark_reference]]
--[[@field next cmark_reference?]]
--[[@field label string]]
--[[@field url string]]
--[[@field title string]]
--[[@field age integer]]
--[[@field size integer]]

--[[@class cmark_reference_map]]
--[[@field refs cmark_reference]]
--[[@field sorted cmark_reference[]?]]
--[[@field size integer]]
--[[@field ref_size integer]]
--[[@field max_ref_size integer]]

--[[@return cmark_reference_map]]
local reference_map_new = function ()
	return { refs = nil, sorted = nil, size = 0, ref_size = 0, max_ref_size = 0 }
end

return mod

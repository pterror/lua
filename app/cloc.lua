#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local dirs = {}
for i = 1, #arg do
	dirs[#dirs+1] = arg[i]
end
if #dirs == 0 then dirs[#dirs+1] = "." end

-- TODO: https://www.gavilan.edu/csis/languages/comments.html
-- TODO: https://en.wikipedia.org/wiki/List_of_programming_languages

local dir_list = require("lib.fs.dir_list").dir_list

--[[@class cloc_info]]
--[[@field ext string]]
--[[@field files integer]]
--[[@field blank integer]]
--[[@field comment integer]]
--[[@field code integer]]

local infos = {} --[[@type table<string, cloc_info>]]
local info_arr = {} --[[@type cloc_info[] ]]

-- TODO: vim, sqls, 

local filename_is_text = {
	license = true, readme = true,
	makefile = true,
}

local is_text = {
	c = true, cs = true, csx = true, cpp = true, cc = true, h = true, hpp = true, hh = true, hxx = true, ixx = true, java = true,
	js = true, jsx = true, cjs = true, mjs = true, ts = true, tsx = true, cts = true, mts = true,
	dfy = true, jakt = true, owen = true, jai = true, cone = true, qml = true, hx = true, kt = true, d = true,
	svelte = true, vue = true,
	fs = true, fsi = true, fsx = true, fsscript = true, re = true, res = true, php = true,
	f = true, ["for"] = true, ftn = true, i = true, fpp = true,
	f90 = true, i90 = true, f95 = true, f03 = true,
	cbl = true, ccp = true, cob = true, cpy = true,
	lua = true, hs = true, e = true, sql = true,
	py = true, rb = true, pl = true,
	lisp = true, lsp = true, s = true, clj = true, cljs = true, cljc = true, rkt = true, el = true,
	html = true, xhtml = true, svg = true, css = true,
	md = true, rst = true, tex = true, sty = true, org = true,
	txt = true, xml = true, xaml = true, yml = true, yaml = true, toml = true, ini = true, json = true, jsonc = true,
	edn = true, hxml = true, csproj = true, hxproj = true, editorconfig = true,
	sln = true,
	sh = true, fish = true, zsh = true, ps = true, nu = true,
	xbm = true, xpm = true,
	coq = true, agda = true, am = true, ml = true, mli = true, vb = true, bas = true,
}
-- proper parsing is a non-goal
-- certain languages support nested block comments; but this tool doesn't:
-- jai, coq, agda, d
-- lsp = autolisp, e = eiffel

-- some extensions are ambiguous, assuming:
-- pl = perl, not prolog (%)
-- ps = powershell, not postscript (%)

-- some have comments unrepresentable by a single pattern:
-- vb = '|REM
-- js (vue and svelte are similar) = /*|<!--  */|//-->
-- xml = <!--|<![IGNORE[  -->|]]>
-- php = //|#

local cp = {
	c = "//", cs = "//", cpp = "//", cc = "//", h = "//", hpp = "//", hh = "//", hxx = "//", ixx = "//", java = "//",
	js = "//", jsx = "//", cjs = "//", mjs = "//", ts = "//", tsx = "//", cts = "//", mts = "//", svelte = "//", vue = "//",
	dfy = "//", jakt = "//", owen = "//", jai = "//", cone = "//", qml = "//", hx = "//", kt = "//", d = "//",
	fs = "//", fsi = "//", fsx = "//", fsscript = "//", re = "//", res = "//", php = "//",
	f = "^[cC*dD!]", ["for"] = "^[cC*dD!]", ftn = "^[cC*dD!]", i = "^[cC*dD!]", fpp = "^[cC*dD!]",
	f90 = "!", i90 = "!", f95 = "!", f03 = "!",
	cbl = "^......%*", ccp = "^......%*", cob = "^......%*", cpy = "^......%*",
	lua = "%-%-", hs = "%-%-", e = "%-%-", sql = "%-%-",
	py = "#", rb = "#", pl = "#",
	lisp = ";", lsp = ";", s = ";", clj = ";", cljs = ";", cljc = ";", rkt = ";", el = ";",
	tex = "%%", sty = "%%",
	yml = "#", yaml = "#", toml = "#", ini = "[;#]", json = "//", jsonc = "//", edn = ";", hxml = "#",
	editorconfig = "[;#]",
	sh = "#", fish = "#", zsh = "#", ps = "#", nu = "#",
	agda = "%-%-", am = "#", vb = "'", bas = "REM",
}
local csp = {
	c = "/%*", cs = "/%*", csx = "/%*", cpp = "/%*", cc = "/%*", h = "/%*", hpp = "/%*", hh = "/%*", hxx = "/%*", ixx = "/%*", java = "/%*",
	js = "/%*", jsx = "/%*", cjs = "/%*", mjs = "/%*", ts = "/%*", tsx = "/%*", cts = "/%*", mts = "/%*", svelte = "/%*", vue = "/%*",
	dfy = "/%*", jai = "/%*", cone = "/%*", qml = "/%*", hx = "/%*", kt = "/%*", d = "/[*+]",
	fs = "%(%*", fsi = "%(%*", fsx = "%(%*", fsscript = "%(%*", re = "/%*", res = "/%*", php = "/%*",
	lua = "%-%-%[=*%[", hs = "{%-", sql = "/%*",
	pl = "^=",
	lsp = ";|",
	html = "<!%-%-", xhtml = "<!%-%-", svg = "<!%-%-", css = "/%*",
	md = "<!%-%-", tex = "\\begin{comment}",
	xml = "<!%-%-", xaml = "<!%-%-", json = "/%*", jsonc = "/%*", hxproj = "<!%-%-", csproj = "<!%-%-",
	editorconfig = "[;#]",
	ps = "<#",
	coq = "%(%*", agda = "{%-", ml = "%(%*", mli = "%(%*",
}
local cep = {
	c = "%*/", cs = "%*/", csx = "%*/", cpp = "%*/", cc = "%*/", h = "%*/", hpp = "%*/", hh = "%*/", hxx = "%*/", ixx = "%*/", java = "%*/",
	js = "%*/", jsx = "%*/", cjs = "%*/", mjs = "%*/", ts = "%*/", tsx = "%*/", cts = "%*/", mts = "%*/", svelte = "%*/", vue = "/%*",
	dfy = "%*/", jai = "%*/", cone = "%*/", qml = "%*/", hx = "%*/", kt = "%*/",  d = "[*+]/",
	fs = "%*%)", fsi = "%*%)", fsx = "%*%)", fsscript = "%*%)", re = "%*/", res = "%*/", php = "%*/",
	lua = "%]=*%]", hs = "%-}", sql = "%*/",
	pl = "^=cut$",
	lsp = "|;",
	html = "%-%->", xhtml = "%-%->", svg = "%-%->", css = "%*/",
	md = "%-%->", tex = "\\end{comment}",
	xml = "%-%->", xaml = "%-%->", json = "%*/", jsonc = "%*/", hxproj = "%-%->", csproj = "%-%->", editorconfig = "[;#]",
	ps = "#>",
	coq = "%*%)", agda = "%-}", ml = "%*%)", mli = "%*%)",
}

local handle_file = function (path) --[[@param path string]]
	local f = io.open(path)
	if not f then io.stderr:write("cloc: could not open file: " .. path .. "\n"); return end
	local ext = (path:match("%.([^./]+)$") or ""):lower() --[[@type string]]
	if not is_text[ext] then
		ext = (path:match("%/([^./]+)$") or ""):lower()
		if not filename_is_text[ext] then return end
	end
	local info = infos[ext]
	if not info then
		info = { ext = ext, files = 0, blank = 0, comment = 0, code = 0 }
		infos[info.ext] = info
		info_arr[#info_arr+1] = info
	end
	info.files = info.files + 1
	local csp_ = csp[ext]
	local cep_ = cep[ext]
	local cp_ = cp[ext]
	local line = f:read("*Line") --[[@type string]]
	while line do
		if line:match("^%s+$") then info.blank = info.blank + 1
		elseif csp_ and line:match(csp_) then
			info.comment = info.comment + 1
			while line and not line:match(cep_) do
				info.comment = info.comment + 1
				line = f:read("*Line")
			end
		elseif cp_ and line:match(cp_) then info.comment = info.comment + 1
		else info.code = info.code + 1 end
		line = f:read("*Line")
	end
end

local handle_dir
handle_dir = function (path, top) --[[@param path string]] --[[@param top? boolean]]
	local iter, state = dir_list(path)
	if not iter then
		if top then handle_file(path); return end
		io.stderr:write("cloc: could not open directory: " .. path .. "\n")
		return
	end
	for f in iter, state do
		f = f --[[@type file_info]]
		if f.is_dir then
			handle_dir(path .. "/" .. f.name)
		else
			handle_file(path .. "/" .. f.name)
		end
	end
end
for i = 1, #dirs do
	handle_dir(dirs[i], true)
end

print("ext", "files", "blank", "comment", "code")
print("---", "-----", "-----", "-------", "----")
table.sort(info_arr, function (a, b) return a.code > b.code end)
for _, info in ipairs(info_arr) do
	print(info.ext, info.files, info.blank, info.comment, info.code)
end

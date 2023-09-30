#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local root = arg[1] or "."

--[[@type http_table_handler]]
local routes = {
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	api = require("serve_api.git").make_routes(root),
	[""] = function (_, res)
		res.headers["Content-Type"] = "text/html"
		res.body = [[
<!doctype html>
<link rel="stylesheet" href="/style.css">
<link rel="stylesheet" href="/git_style.css">
<h1>git gui</h1>
<h2>current head</h2>
<div class="d d-head icon-and-text"><svg class="icon"><use class="p p-icon"></use></svg><span class="p p-name"></span></div>
<h2>all refs</h2>
<div class="d d-ref-list"></div>
<h2>changed files</h2>
<div class="d d-file-list"></div>
<script type="module">
	import $ from "/$.js";
	import * as g from "/git.js";
	const sym = s => "/git_icons.svg#symbol-" + s;
	const diffClass = t => "status-" + t.replace(/^worktree_|^index_/, "").replace(/_/g, "-");
	const worktreeSym = t => sym(t.startsWith("index_") ? "blank" : "file-" + t.replace(/^worktree_/, "").replace(/_/g, "-"));
	const indexSym = t => sym(t.startsWith("worktree_") ? "blank" : "file-" + t.replace(/^index_/, "").replace(/_/g, "-"));
	const head = g.parseRef(await (await fetch("api/repository/head/name")).json());
	$(".d-head .p-icon")?.attr("href", sym("ref-" + head.type.replace(/_/g, "-")));
	$(".d-head .p-name")?.text(head.name);
	$(".d-ref-list")?.do(async $ => (await (await fetch("api/reference/list")).json()).map(g.parseRef).forEach(r => $.append("div", $ => $
		.class("p", "p-ref", "icon-and-text")
		.appendSvg("svg", $ => $.class("icon").appendSvg("use", $ => $
			.class("p", "p-icon")
			.attr("href", sym("ref-" + r.type.replace(/_/g, "-")))
		))
		.append("span", $ => $
			.class("p", "p-name")
			.text(r.name)
		)
	)));
	$(".d-file-list")?.do(async $ => (await (await fetch("api/status")).json()).forEach(s => $.append("div", $ => $
		.class("p", "p-file", "icon-and-text", diffClass(s.type))
		.appendSvg("svg", $ => $.class("icon").appendSvg("use", $ => $
			.class("p", "p-icon")
			.attr("href", worktreeSym(s.type))
		))
		.appendSvg("svg", $ => $.class("icon").appendSvg("use", $ => $
			.class("p", "p-icon")
			.attr("href", indexSym(s.type))
		))
		.append("div", $ => $
			.text(
				s.index_to_workdir?.new_file.path ?? s.index_to_workdir?.old_file.path ??
				s.head_to_index?.new_file.path ?? s.head_to_index?.old_file.path
			)
		)
	)));
</script>]]
	end
}
routes["index.html"] = routes[""]
if DEV then routes._routes = require("lib.http.router.table_list_routes").list_routes_handler(routes) end

local here = debug.getinfo(1).source:match("@?(.*[/\\])")
return require("lib.http.server").server(
	require("lib.http.router.chain").chain_router(
		require("lib.http.router.tablex").table_router(routes),
		require("lib.http.router.staticx").static_router(here .. "static")
	),
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	tonumber(os.getenv("PORT") or os.getenv("port") or 8080)
)

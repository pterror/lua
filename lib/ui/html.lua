local mod = {}

--[[@type table<string,fun(node:ui_element,write:fun(text:string))>]]
local renderers = {}
--[[@param node ui_element]] --[[@param write fun(text: string)]]
local render = function (node, write)
	if type(node) ~= "table" then io.stderr:write("node must be table: ", tostring(node), "\n"); return end
	local renderer = renderers[node.type]
	if not renderer then io.stderr:write("unknown node type: ", node.type, "\n") return end
	renderer(node, write)
end
mod.render = render
--[[@param node ui_list_element]]
renderers.list = function (node, write)
	write("<ul>")
	for _, item in ipairs(node.items) do
		write("<li>") --[[TODO: is there a way to make these styleable without introducing indirection?]]
		render(item, write)
		write("</li>")
	end
	write("</ul>")
end
--[[@param node ui_ordered_list_element]]
renderers.ordered_list = function (node, write)
	write("<ol>")
	for _, item in ipairs(node.items) do
		write("<li>")
		render(item, write)
		write("</li>")
	end
	write("</ol>")
end
--[[@param node ui_hstack_element]]
renderers.hstack = function (node, write)
	write("<div style=\"display:flex;flex-flow:row nowrap;align-items:center;\">")
	for _, item in ipairs(node.items) do render(item, write) end
	write("</div>")
end
--[[@param node ui_vstack_element]]
renderers.vstack = function (node, write)
	write("<div style=\"display:flex;flex-flow:column nowrap;align-items:center;\">")
	for _, item in ipairs(node.items) do render(item, write) end
	write("</div>")
end
--[[@param node ui_table_element]]
renderers.table = function (node, write)
	write("<table>")
	if node.header then
		write("<thead><tr>")
		for _, header in ipairs(node.header) do
			write("<th>")
			render(header, write)
			write("</th>")
		end
		write("</tr></thead>")
	end
	write("<tbody>")
	for _, row in ipairs(node.rows) do
		write("<tr>")
		for _, item in ipairs(row) do
			write("<td>")
			render(item, write)
			write("</td>")
		end
		write("</tr>")
	end
	write("</tbody>")
	if node.footer then
		write("<tfoot><tr>")
		for _, footer in ipairs(node.footer) do
			write("<th>")
			render(footer, write)
			write("</th>")
		end
		write("</tr></tfoot>")
	end
	write("</table>")
end
mod.renderers = renderers


return mod

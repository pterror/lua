local mod = {}

local renderers = {}
local render = function (node, write)
	local renderer = renderers[node.type]
	if not renderer then io.stderr:write("unknown node type: ", node.type) return end
	renderer(node, write)
end
renderers.list = function (node, write)
	write("<ul>")
	for _, item in ipairs(node.items) do
		write("<li>") --[[TODO: is there a way to make these styleable without introducing indirection?]]
		render(item, write)
		write("</li>")
	end
	write("</ul>")
end
renderers.ordered_list = function (node, write)
	write("<ol>")
	for _, item in ipairs(node.items) do
		write("<li>")
		render(item, write)
		write("</li>")
	end
	write("</ol>")
end
renderers.table = function (node, write)
	write("<table>")
	if node.header then
		write("<thead><tr>")
		for _, header in ipairs(node.header) do
			write("<th>")
			write(header)
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
			write(footer)
			write("</th>")
		end
		write("</tr></tfoot>")
	end
	write("</table>")
end
mod.renderers = renderers


return mod

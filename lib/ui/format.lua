local mod = {}

--[[@class ui_base_element]]
--[[@field type string]]

--[[@alias ui_element ui_list_element|ui_ordered_list_element|ui_vstack_element|ui_hstack_element|ui_image_element|ui_text_element]]

--[[@class ui_list_element: ui_base_element]]
--[[@field type "list"]]
--[[@field items ui_element[] ]]

--[[@class ui_ordered_list_element: ui_base_element]]
--[[@field type "ordered_list"]]
--[[@field items ui_element[] ]]

--[[@class ui_vstack_element: ui_base_element]]
--[[@field type "vstack"]]
--[[@field items ui_element[] ]]

--[[@class ui_hstack_element: ui_base_element]]
--[[@field type "hstack"]]
--[[@field items ui_element[] ]]

--[[@class ui_table_element: ui_base_element]]
--[[@field type "table"]]
--[[@field header? ui_element[] ]]
--[[@field rows ui_element[] ]]
--[[@field footer? ui_element[] ]]

--[[@class ui_image_element: ui_base_element]]
--[[@field type "image"]]
--[[@field location string]]

--[[@class ui_text_element: ui_base_element]]
--[[@field type "text"]]
--[[@field text string]]

--[[@return ui_list_element]] --[[@param items ui_element[] ]]
mod.list = function (items) return { type = "list", items = items } end
--[[@return ui_ordered_list_element]] --[[@param items ui_element[] ]]
mod.ordered_list = function (items) return { type = "ordered_list", items = items } end
--[[@return ui_vstack_element]] --[[@param items ui_element[] ]]
mod.vstack = function (items) return { type = "vstack", items = items } end
--[[@return ui_hstack_element]] --[[@param items ui_element[] ]]
mod.hstack = function (items) return { type = "hstack", items = { items } } end
--[[@return ui_table_element]] --[[@param shape {header?:ui_element[],rows:ui_element[],footer?:ui_element[]}]]
mod.table = function (shape)
	return { type = "table", header = shape.header, rows = shape.rows, footer = shape.footer }
end
--[[@return ui_image_element]] --[[@param location string]]
mod.image = function (location) return { type = "image", location = location } end
--[[@return ui_text_element]] --[[@param text string]]
mod.text = function (text) return { type = "text", text = text } end

return mod

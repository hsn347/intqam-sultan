local items
local MyItemColumnID_ID = 0
local MyItemColumnID_Name = 1
local MyItemColumnID_Action = 2
local MyItemColumnID_Quantity = 3
local MyItemColumnID_Description = 4
_UPVALUE15_ = nil
;(nil)[1] = "Banana"
;(nil)[2] = "Apple"
;(nil)[3] = "Cherry"
;(nil)[4] = "Watermelon"
;(nil)[5] = "Grapefruit"
;(nil)[6] = "Strawberry"
;(nil)[7] = "Mango"
;(nil)[8] = "Kiwi"
;(nil)[9] = "Orange"
;(nil)[10] = "Pineapple"
;(nil)[11] = "Blueberry"
;(nil)[12] = "Plum"
;(nil)[13] = "Coconut"
;(nil)[14] = "Pear"
local (nil)[15], template_items_names = "Apricot", nil
local names_count = #template_items_names
local imgui_test_Table = function()
	if not items then
		items = items
		for n = 1, 50 do
			print(n)
			local template_n = (n - 1) % names_count + 1
			items = names_count
			names_count.ID = n
			names_count.Name = template_items_names[template_n]
			local names_count.Quantity, item = (n * n - n) % 20, names_count
			items[n] = item
		end
		dump(items, "items", 10)
	end
	local flags = 0 + imgui.ImGuiTableFlags_Resizable + imgui.ImGuiTableFlags_Reorderable + imgui.ImGuiTableFlags_Hideable + imgui.ImGuiTableFlags_Sortable + imgui.ImGuiTableFlags_SortMulti + imgui.ImGuiTableFlags_RowBg + imgui.ImGuiTableFlags_BordersOuter + imgui.ImGuiTableFlags_BordersV + imgui.ImGuiTableFlags_NoBordersInBody
	if imgui.BeginTable("##table", 4, flags) then
		imgui.TableSetupColumn("ID", imgui.ImGuiTableColumnFlags_DefaultSort + imgui.ImGuiTableColumnFlags_WidthFixed, -1.0, MyItemColumnID_ID)
		imgui.TableSetupColumn("Name", imgui.ImGuiTableColumnFlags_WidthFixed, -1.0, MyItemColumnID_Name)
		imgui.TableSetupColumn("Action", imgui.ImGuiTableColumnFlags_NoSort + imgui.ImGuiTableColumnFlags_WidthFixed, -1.0, MyItemColumnID_Action)
		imgui.TableSetupColumn("Quantity", imgui.ImGuiTableColumnFlags_PreferSortDescending + imgui.ImGuiTableColumnFlags_WidthStretch, -1.0, MyItemColumnID_Quantity)
		imgui.TableSetupScrollFreeze(0, 1)
		imgui.TableHeadersRow()
		local sorts_specs = imgui.TableGetSortSpecs()
		if sorts_specs and sorts_specs.SpecsDirty then
			table.sort(items, function(a, b)
				for i, sort_spec in ipairs(sorts_specs.Specs) do
					local delta = 0
					if sort_spec.ColumnUserID == MyItemColumnID_ID then
						delta = a.ID - b.ID
					elseif sort_spec.ColumnUserID == MyItemColumnID_Name then
						if a.Name > b.Name then
							delta = 1
						elseif a.Name < b.Name then
							delta = -1
						end
					elseif sort_spec.ColumnUserID == MyItemColumnID_Quantity then
						delta = a.Quantity - b.Quantity
					elseif sort_spec.ColumnUserID == MyItemColumnID_Description then
						if a.Name > b.Name then
							delta = 1
						elseif a.Name < b.Name then
							delta = -1
						end
					end
					if 0 < delta then
						return sort_spec.SortDirection == imgui.ImGuiSortDirection_Ascending
					end
					if delta < 0 then
						return sort_spec.SortDirection ~= imgui.ImGuiSortDirection_Ascending
					end
				end
				return a.ID < b.ID
			end)
			imgui.SetTableSortSpecs_SpecsDirty(true)
		end
		for i, item in ipairs(items) do
			imgui.PushID(item.ID)
			imgui.TableNextRow()
			imgui.TableNextColumn()
			imgui.Text(string.format("%04d", item.ID))
			imgui.TableNextColumn()
			imgui.TextUnformatted(item.Name)
			imgui.TableNextColumn()
			imgui.SmallButton("None")
			imgui.TableNextColumn()
			imgui.Text(string.format("%d", item.Quantity))
			imgui.PopID()
		end
		imgui.EndTable()
	end
end
function imgui_testTable_func()
	imgui.setNextWindowSize(400, 300, imgui.ImGuiCond_FirstUseEver)
	_ENV = 300
	imgui.xpcallShowWindow("imgui测试 - Table", 300, function()
		imgui_test_Table()
	end)
end
return imgui_testTable_func

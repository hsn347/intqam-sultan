local imgui = _G.imgui
local mainPanelLayout = function()
	local dockspace_id = imgui.GetID("MainPanel")
	if imgui.DockBuilderGetNodeIsNull(dockspace_id) then
		local rect = imgui.GetMainViewportRect()
		imgui.DockBuilderRemoveNode(dockspace_id)
		imgui.DockBuilderAddNode(dockspace_id)
		imgui.DockBuilderSetNodeSize(dockspace_id, 1000, 900)
		imgui.DockBuilderSetNodePos(dockspace_id, rect.x + rect.width, rect.y)
		local dock_main_id = dockspace_id
		local dock_id_mainLeft, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Left, 0.4)
		local dock_id_mainup, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Up, 0.015)
		local dock_id_up, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Up, 0.3)
		local dock_id_bottom, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Down, 0.2)
		local dock_id_left, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Left, 0.4)
		local dock_id_right, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Right, 0.3)
		local dock_id_middle, dock_main_id = imgui.DockBuilderSplitNode(dock_main_id, imgui.ImGuiDir_Right, 0.8)
		imgui.DockBuilderDockWindow("imguiMainPanel", dock_id_mainup)
		imgui.DockBuilderDockWindow("###statusPanel", dock_id_up)
		imgui.DockBuilderDockWindow("###skillEffectEditor", dock_id_mainLeft)
		imgui.DockBuilderDockWindow("###imguiParallaxSettingPanel", dock_id_mainLeft)
		imgui.DockBuilderDockWindow("###imguiBattleMapPanel", dock_id_up)
		imgui.DockBuilderDockWindow("###imguiTestPanel", dock_id_up)
		imgui.DockBuilderDockWindow("###imguiPlayerPanel", dock_id_up)
		imgui.DockBuilderDockWindow("###imguiWorldMap", dock_id_up)
		imgui.DockBuilderDockWindow("###scene", dock_id_middle)
		imgui.DockBuilderDockWindow("###inspector", dock_id_right)
		imgui.DockBuilderDockWindow("###tabInspector", dock_id_right)
		imgui.DockBuilderDockWindow("###hierarchy", dock_id_left)
		imgui.DockBuilderDockWindow("###tabTreeGraph", dock_id_left)
		imgui.DockBuilderDockWindow("###console", dock_id_bottom)
		imgui.DockBuilderDockWindow("###profiler", dock_id_bottom)
		imgui.DockBuilderDockWindow("Dear ImGui Demo", dock_id_right)
		imgui.DockBuilderFinish(dockspace_id)
	else
		local rect = imgui.GetMainViewportRect()
		imgui.DockBuilderSetNodePos(dockspace_id, rect.x + rect.width, rect.y)
	end
	imgui = rect.x + rect.width
	local _, opended = imgui.begin("imguiMainPanel", true, rect.x + rect.width)
	if not opended then
		imgui.toogleMainWindow()
	end
	imgui.endToLua()
end
imgui.addDrawFunc("mainPanelLayout", mainPanelLayout)

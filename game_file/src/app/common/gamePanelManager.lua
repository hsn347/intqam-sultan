local SoraDUpdatePanelVisible = function(ignorePanel)
	local visible = true
	if #SoraDPanelManager == 0 then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAIN_UI_ANIMATION"
		SoraDSendMessage(nil)
	end
	for i = #SoraDPanelManager, 1, -1 do
		local panel = SoraDPanelManager[i]
		if not tolua.isnull(panel) then
			if not ignorePanel or ignorePanel ~= panel then
				panel:setVisible(visible)
			end
			if panel.isHidePrePanel then
				visible = false
			end
		end
	end
end
local SoraDUpdateCurrentSceneViewAndMainUI = function(panel, isHide)
	local isHideCurrentSceneView = panel.isHideCurrentSceneView
	if isHideCurrentSceneView then
		_ENV, isHide = nil, isHide or false
		;(nil).isHideCurrentSceneView = isHide
		local (nil).isHideMainUI, hideData = isHide, nil
		SoraDHideCurrentSceneViewAndMainUI(hideData)
	end
end
SoraDPanelManager, _ENV = nil, nil
function SoraDAddPanelToManager(panel, ignoreEvent)
	if not panel then
		return
	end
	SoraDUpdateCurrentSceneViewAndMainUI(panel, true)
	local lastPanel = SoraDPanelManager[#SoraDPanelManager]
	if lastPanel and lastPanel.onLeavePanel and not tolua.isnull(lastPanel) then
		lastPanel:onLeavePanel()
	end
	SoraDPanelManager[#SoraDPanelManager + 1] = panel
	SoraDUpdatePanelVisible(panel)
	if not ignoreEvent then
		SoraDShowCurrentViewName(panel.__cname, true, panel._name, panel)
	end
	if gModuleMgr then
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow(panel.viewName or panel.__cname)
	end
	if panel.isTranslucentView then
		SoraDUpdateCurrentSceneViewAndMainUI = gModuleMgr.sharedMgr("mildGuideManager")
		gModuleMgr.sharedMgr("mildGuideManager").msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
		gModuleMgr.sharedMgr("mildGuideManager").onEnter = true
		gModuleMgr.sharedMgr("mildGuideManager").opacity = panel:getBackGroundColorOpacity()
		SoraDSendMessage((gModuleMgr.sharedMgr("mildGuideManager")))
	else
		SoraDUpdateCurrentSceneViewAndMainUI = gModuleMgr.sharedMgr("mildGuideManager")
		gModuleMgr.sharedMgr("mildGuideManager").msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
		SoraDSendMessage((gModuleMgr.sharedMgr("mildGuideManager")))
	end
end
function SoraDRemovePanelFromManager(panel, ignoreEvent)
	if not panel then
		return
	end
	for index, v in ipairs(SoraDPanelManager) do
		if v == panel then
			SoraDUpdateCurrentSceneViewAndMainUI(panel, false)
			if not ignoreEvent then
				SoraDShowCurrentViewName(panel.__cname, false, panel._name, panel)
			end
			table.remove(SoraDPanelManager, index)
			if 1 < index then
				local prePanel = SoraDPanelManager[index - 1]
				if prePanel and prePanel.onIntoPanel then
					prePanel:onIntoPanel(panel.__cname)
				end
			end
			break
		end
	end
	SoraDWhenRemovePanelFromManager()
end
function SoraDRemoveTopPanelFromManager()
	if #SoraDPanelManager > 0 then
		local removePanel = SoraDPanelManager[#SoraDPanelManager]
		SoraDUpdateCurrentSceneViewAndMainUI(removePanel, false)
		table.remove(SoraDPanelManager, #SoraDPanelManager)
		removePanel:removeFromParent()
		local prePanel = SoraDPanelManager[#SoraDPanelManager]
		if prePanel and prePanel.onIntoPanel then
			prePanel:onIntoPanel(removePanel.__cname)
		end
		SoraDWhenRemovePanelFromManager()
		return true
	end
	return false
end
function SoraDRemoveAllAfterPanelFromManager(panel, notCoverSelf)
	if not panel then
		return
	end
	local allNum = #SoraDPanelManager
	local needBreak = false
	for i = 1, allNum do
		local index = allNum - i + 1
		local removePanel = SoraDPanelManager[index]
		if removePanel == nil or removePanel == panel and notCoverSelf then
			if removePanel and panel.onIntoPanel then
				panel:onIntoPanel()
			end
			break
		end
		table.remove(SoraDPanelManager, index)
		SoraDUpdateCurrentSceneViewAndMainUI(removePanel, false)
		if removePanel == panel then
			needBreak = true
			local isHidePrePanel = panel.isHidePrePanel
			if isHidePrePanel and 1 < index then
				local prePanel = SoraDPanelManager[index - 1]
				if prePanel and prePanel.onIntoPanel then
					prePanel:onIntoPanel()
				end
			end
		end
		removePanel:removeFromParent()
		if needBreak then
			break
		end
	end
	SoraDWhenRemovePanelFromManager()
end
function SoraDRemoveAllPrePanelFromManager(panel, notCoverSelf)
	if not panel then
		return
	end
	local allNum = #SoraDPanelManager
	local needBreak = false
	for i = 1, allNum do
		local removePanel = SoraDPanelManager[1]
		if removePanel == nil or removePanel == panel and notCoverSelf then
			break
		end
		table.remove(SoraDPanelManager, 1)
		SoraDUpdateCurrentSceneViewAndMainUI(removePanel, false)
		if removePanel == panel then
			needBreak = true
		end
		removePanel:removeFromParent()
		if needBreak then
			break
		end
	end
	SoraDWhenRemovePanelFromManager()
end
function SoraDRemoveAllExceptPanelFromManager(panel)
	if not panel then
		return
	end
	local allNum = #SoraDPanelManager
	local needBreak = false
	for i = allNum, 1, -1 do
		local removePanel = SoraDPanelManager[i]
		if removePanel ~= panel then
			table.remove(SoraDPanelManager, i)
			SoraDUpdateCurrentSceneViewAndMainUI(removePanel, false)
			removePanel:removeFromParent()
		end
	end
	if panel.onIntoPanel then
		panel:onIntoPanel()
	end
	SoraDWhenRemovePanelFromManager()
end
function SoraDRemoveAllPanelFromManager()
	print("remove all")
	userSDKManager.cleanCallBack2SDK()
	local allNum = #SoraDPanelManager
	for i = 1, allNum do
		local panel = SoraDPanelManager[1]
		if panel then
			table.remove(SoraDPanelManager, 1)
			SoraDUpdateCurrentSceneViewAndMainUI(panel, false)
			if not tolua.isnull(panel) or type(panel) == "table" then
				panel:removeFromParent()
			end
		end
	end
	SoraDPanelManager, _ENV = 1, (for index)
	SoraDWhenRemovePanelFromManager()
end
function SoraDWhenRemovePanelFromManager()
	SoraDShowPopUpView()
	SoraDCheckNoPanelGuide()
	_ENV = nil
	;(nil).msg = "MESSAGE_NEW_PLAYER_QUEST_NOTICE_HAND_CLEAN"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
	SoraDSendMessage(nil)
	SoraDUpdatePanelVisible()
end
function SoraDSearchPanelFromManagerByName(name)
	local panel
	for i, v in ipairs(SoraDPanelManager) do
		_UPVALUE2_ = nil
		;(nil)[1] = v.viewName
		;(nil)[2] = v.__cname
		dump(nil, "SoraDPanelManager")
		if v.isFgui and v.viewName == name or v.__cname == name then
			panel = v
			break
		end
	end
	return panel
end
function SoraDSearchPanelFromManager(panel)
	local ret = false
	if not panel then
		return ret
	end
	for i, v in ipairs(SoraDPanelManager) do
		if v == panel then
			ret = true
			break
		end
	end
	return ret
end
function SoraDCurrentTopPanelFromManager()
	return SoraDPanelManager[#SoraDPanelManager]
end
function SoraDCurrentTopPanelNameFromManager()
	local ret = ""
	if SoraDCurrentTopPanelFromManager() then
		ret = SoraDCurrentTopPanelFromManager().__cname
	end
	return ret
end

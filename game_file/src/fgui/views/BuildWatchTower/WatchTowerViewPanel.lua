local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local watchTowerData = include("watchTowerData")
local socket = require("socket")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WatchTowerViewPanel = class("WatchTowerViewPanel", baseFguiPanel)
_ENV = "WatchTowerViewPanel"
;("WatchTowerViewPanel").ALL = 0
;("WatchTowerViewPanel").SINGLE = 1
local _ENV, _UPVALUE3_, ("WatchTowerViewPanel").MASS, showType = nil, baseFguiPanel, 2, "WatchTowerViewPanel"
;(nil).title = "common_text_635"
_ENV, (nil).tag = showType.ALL, showType.ALL
showType.ALL.title = "common_text_4883"
_ENV, showType.ALL.tag = showType.SINGLE, showType.SINGLE
showType.SINGLE.title = "common_text_292"
showType.SINGLE.tag = showType.MASS
baseFguiPanel[1] = nil
baseFguiPanel[2] = showType.ALL
local baseFguiPanel[3], showTypeItems = showType.SINGLE, baseFguiPanel
function WatchTowerViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("WatchTowerViewPanel:ctor", self.viewName)
end
function WatchTowerViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WatchTowerViewPanel:onInit()
	print("=======WatchTowerViewPanel:onInit")
	self.fields.btn_set:addClickEventListener(handler(self, self.btnSettingClick))
	self.fields.btnIgnoreAll:setTitleText(i18n("common_text_1266"))
	self.fields.btnIgnoreAll:addClickEventListener(handler(self, self.btnIgnoreAllClick))
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.showTypes:setItemRenderer(handler(self, self.onShowTypeRenderer))
	self.fields.showTypes:setNumItems(#showTypeItems)
	self.fields.showTypes:fixPos()
	self.fields.ComboBox_sort:fixPos()
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	end)
end
function WatchTowerViewPanel:onComboBoxClick()
	SoraDPlaySound()
	local sortType = tonumber(self.fields.ComboBox_sort:getValue())
	if self.curSortType == sortType then
		self.curSortType = 0
	else
		self.curSortType = sortType
	end
	_ENV = self.fields.ComboBox_sort:getValue()
	self.fields.ComboBox_sort:getValue().byUID = true
	SoraDConfigSet("Game:WatchTowerViewPanel:SortIndex~integer", self.curSortType, self.fields.ComboBox_sort:getValue())
	self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	if self.curSortType == 0 then
		self.fields.ComboBox_sort:setTitle(i18n("jinn_skill_4"))
	end
	self:initScrollList()
end
function WatchTowerViewPanel:onShow()
	self.is_delay = false
	print("=======WatchTowerViewPanel:onShow")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	_ENV = nil
	;(nil).level = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	self.fields.Com_title:initData(i18n("common_text_603", nil), handler(self, self.onClickClose))
	self.curClassType = nil
	self.curShowType = showType.ALL
	self.queueDatas, _ENV, self.tableSingleUI, _ENV, self.tableSpare, _ENV, self.scrollH = showType.ALL, showType.ALL, showType.ALL, showType.ALL, showType.ALL, showType.ALL, 0
	self.fields.showTypes:setSelectedIndex(self.curShowType)
	showType = self.fields.showTypes
	self.fields.showTypes[1] = gAllianceQueueClassType.pvp_def
	self.fields.showTypes[2] = gAllianceQueueClassType.pvp
	for _, v in pairs(self.fields.showTypes) do
		self.queueDatas[v] = watchTowerData.new(self, v, self.scrollH)
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self.fields.scroll:setNumItems(0)
	self:initQueueData()
	_ENV = self.initQueueData
	_ENV, _ENV, self.initQueueData.defaultClick = self, self:getDefaultClick(), self:getDefaultClick()
	self.title = i18n("common_text_310")
	_ENV, self:getDefaultClick()[1], self.tag = self, self, gAllianceQueueClassType.pvp_def
	self.title = i18n("common_text_483")
	self.initQueueData.tabsetArray, self:getDefaultClick()[2], self.tag = self:getDefaultClick(), self, gAllianceQueueClassType.pvp
	local self.initQueueData.callback, param = handler(self, self.btn_onClick_btns), self.initQueueData
	self.fields.Com_tab:initView(param)
	_ENV = param
	param.byUID = true
	showType, self.curSortType = SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0, SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[1] = i18n("Promise_Summit_text_04"), i18n("Promise_Summit_text_04")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[2] = i18n("Promise_Summit_text_04"), i18n("AncienTreasure_text_52")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[3] = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[4] = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[5] = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[6] = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[7] = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	local watchTowerData, (SoraDConfigGet("Game:WatchTowerViewPanel:SortIndex~integer", param) or 0)[8], items = i18n("Promise_Summit_text_04"), i18n("artifact_title_01")
	i18n("Promise_Summit_text_04")[1] = 1
	i18n("Promise_Summit_text_04")[2] = 2
	local i18n("Promise_Summit_text_04")[3], values = 3, i18n("Promise_Summit_text_04")
	_ENV = i18n("artifact_title_01")
	i18n("artifact_title_01").items = items
	i18n("artifact_title_01").values = values
	i18n("artifact_title_01").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("artifact_title_01"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	if self.curSortType == 0 then
		self.fields.ComboBox_sort:setTitle(i18n("jinn_skill_4"))
	end
end
function WatchTowerViewPanel:dataAdd(target, redata)
	local indexID = redata.indexID
	local msgdata = redata.data
	if indexID then
		local classType = msgdata.classType
		local warQueueData = self:getQueue(classType)
		warQueueData:dataLinkAdd(indexID, msgdata)
	end
end
function WatchTowerViewPanel:dataDel(target, redata)
	local indexID = redata.indexID
	local classType = redata.classType
	if indexID then
		local warQueueData = self:getQueue(classType)
		warQueueData:dataLinkDelete(indexID)
	end
end
function WatchTowerViewPanel:dataUpdate(target, redata)
	local indexID = redata.indexID
	local msgdata = redata.data
	if indexID then
		local classType = msgdata.classType
		local warQueueData = self:getQueue(classType)
		warQueueData:dataLinkUpdate(indexID, msgdata)
	end
end
function WatchTowerViewPanel:refreshView(target, data)
	local seq = ffa.seq(ffa.delay(0.5), ffa.callFunc(function()
		self:clearScrollData()
		self.curWarData:clean()
		self:initData()
	end))
	seq:setTag(996)
	self:stopActionByTag(996)
	self:runAction(seq)
end
function WatchTowerViewPanel:initData()
	self:initQueueData()
	self:refreshData()
end
function WatchTowerViewPanel:refreshData()
	self.offsetY = nil
	self.beginIndex = nil
	self.endIndex = nil
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	self:prepareScrollData()
end
function WatchTowerViewPanel:prepareScrollData()
	self:updateScrollSize()
	self:checkIgnore()
	self:initScrollList()
end
function WatchTowerViewPanel:updateScrollSize()
end
function WatchTowerViewPanel:checkIgnore(target, redata)
	local ignoreFlage = self.curWarData:checkIgnore()
	self.fields.btnIgnoreAll:setTouchEnabled(ignoreFlage)
	self.fields.btnIgnoreAll:setBright(ignoreFlage)
end
function WatchTowerViewPanel:clearScrollData()
end
function WatchTowerViewPanel:onItemRenderer(index, obj)
	if self.filterIdx ~= -1 and index > self.filterIdx - 1 then
		local data = self.itemDatas[index]
		obj:initData(false, data, true)
	elseif index ~= self.filterIdx - 1 then
		local data = self.itemDatas[index + 1]
		obj:initData(false, data, false)
	else
		obj:initData(true)
	end
end
function WatchTowerViewPanel:onShowTypeRenderer(index, obj)
	local item = showTypeItems[index + 1]
	obj:setTitle(i18n(item.title))
	obj:setTag(item.tag)
	obj:addClickEventListener(handler(self, self.onShowTypeClick))
end
function WatchTowerViewPanel:onShowTypeClick(obj)
	local tag = obj:getTag()
	if self.curShowType == tag then
		return
	end
	SoraDPlaySound()
	self.curShowType = tag
	self:initScrollList()
end
function WatchTowerViewPanel:initScrollList()
	local tableData = self.curWarData:getTableData()
	self.itemDatas, _ENV = self.curWarData, self.curWarData
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for i, v in ipairs(queueData) do
			if self.curShowType == showType.ALL then
				table.insert(self.itemDatas, v)
			else
				local isMass = self:getIsMass(v.data)
				if self.curShowType == showType.SINGLE and not isMass then
					table.insert(self.itemDatas, v)
				elseif self.curShowType == showType.MASS and isMass then
					table.insert(self.itemDatas, v)
				end
			end
		end
	end
	self:sortItemDatas()
	self.filterIdx = -1
	for i, v in ipairs(self.itemDatas) do
		if v.isFilter then
			self.filterIdx = i
			break
		end
	end
	self.fields.scroll:setNumItems(self.filterIdx ~= -1 and #self.itemDatas + 1 or #self.itemDatas)
	self.fields.txtNoArmy:setVisible(not self.curWarData:isHasQueue())
end
_ENV, WatchTowerViewPanel.getIsMass = function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end, function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end
;(function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end)[6100131] = 5
;(function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end)[6200131] = 1
;(function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end)[6300131] = 2
;(function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end)[6400131] = 3
local (function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end)[6500131], artifactSort = 4, function(self, queueObj)
	local qType = queueObj:getQueueType()
	if qType == gMapMoveLineServerType.moveLineTypeOccupyMass or qType == gMapMoveLineServerType.moveLineTypeMassATBuilding or qType == gMapMoveLineServerType.moveLineTypeMass or qType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
		return true
	end
	return false
end
function WatchTowerViewPanel:sortItemDatas()
	if self.curClassType == gAllianceQueueClassType.pvp_def and self.curSortType ~= 0 then
		for i, v in ipairs(self.itemDatas) do
			local _ENV, sortData
			v.sortData = sortData
			local queueObj = v.data
			local statuRemainTime = queueObj:getStatusRemainTime()
			local isInMass = gMapMoveLineStatusType.moveLineStatusTypeRally == queueObj:getStatus()
			sortData.isInMass = isInMass and 1 or 0
			sortData.timeValue = statuRemainTime and statuRemainTime or 9999999
			sortData.totalArmyCount = queueObj:getFromTotalAmryCount()
			local artifact = queueObj:getFromArtifact()
			local armsID = artifact and artifact[1] and artifact[1].armsID or 0
			sortData.artifactOrder = artifactSort[armsID] or 99
			sortData.artifactLv = artifact and artifact[1] and artifact[1].level or 0
			sortData.filter = v.isFilter and 1 or 0
		end
		table.sort(self.itemDatas, function(a, b)
			local aSortData = a.sortData
			local bSortData = b.sortData
			if aSortData.filter ~= bSortData.filter then
				return aSortData.filter < bSortData.filter
			elseif aSortData.isInMass ~= bSortData.isInMass then
				return aSortData.isInMass < bSortData.isInMass
			end
			if self.curSortType == 1 then
				if aSortData.timeValue ~= bSortData.timeValue then
					return aSortData.timeValue < bSortData.timeValue
				else
					return aSortData.totalArmyCount > bSortData.totalArmyCount
				end
			elseif self.curSortType == 2 then
				if aSortData.totalArmyCount ~= bSortData.totalArmyCount then
					return aSortData.totalArmyCount > bSortData.totalArmyCount
				else
					return aSortData.timeValue < bSortData.timeValue
				end
			elseif self.curSortType == 3 then
				if aSortData.artifactOrder ~= bSortData.artifactOrder then
					return aSortData.artifactOrder < bSortData.artifactOrder
				else
					return aSortData.artifactLv > bSortData.artifactLv
				end
			end
		end)
	end
	dump(self.itemDatas, "self.itemDatas")
end
function WatchTowerViewPanel:btnSettingClick(button, eventType)
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = 1
	uiManager:show("AllianceWarSettingView", nil)
end
function WatchTowerViewPanel:ignoreDataOne(target, redata)
	if redata and redata.qid then
		if redata.controlType == "add" then
			self.curWarData:ignoreQueue(redata.qid)
		elseif redata.controlType == "sub" then
			self.curWarData:noIgnoreQueue(redata.qid)
		end
	end
end
function WatchTowerViewPanel:btnIgnoreAllClick(button, eventType)
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1268"), i18n("common_text_204"), nil, function(msgType)
		if MSGBOX_CALLBACK_YES == msgType then
			kingdomMapCtrl:getWatchTowerQueue():cleanRedFrm()
			kingdomMapCtrl:getWatchTowerQueue():addRecordQ()
			if self.curWarData then
				self.curWarData:ignoreAll()
			end
			_ENV = self.curWarData
			self.curWarData.msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL"
			SoraDSendMessage(self.curWarData)
		end
	end)
end
function WatchTowerViewPanel:handlEscort(target, redata)
	dump(redata, "handlEscort")
	if redata and redata.data then
		local _id = tostring(redata.data.uid)
		local info = kingdomMapCtrl:getWatchTowerQueue():getWatchTowerData(_id)
		dump(info, "info")
		if SoraDEnoughTroops() and info then
			local _x = info.from.x
			local _y = info.from.y
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV, _ENV = "WorldDispatchArmyView", uiManager
			;("WorldDispatchArmyView").x = _x
			uiManager.toPoint, ("WorldDispatchArmyView").y = "WorldDispatchArmyView", _y
			uiManager.dispatchType = worldMapDefine.worldMapTipButtonType_bangzhuyayun
			local uiManager.instanceID, dispatchData = _id, uiManager
			dispatchPanel:initData(dispatchData)
		end
	end
end
function WatchTowerViewPanel:reuseSingle(single)
	if single then
		single:setVisible(false)
		table.insert(self.tableSpare, single)
	end
end
function WatchTowerViewPanel:refreshByData(classType, queue, isDelete)
	if self.curClassType ~= classType then
		return
	end
	self:refreshData()
end
function WatchTowerViewPanel:refreshSinggleByData(classType, queue)
	if self.curClassType ~= classType then
		return
	end
	if self.itemDatas then
		self.fields.scroll:setNumItems(self.filterIdx ~= -1 and #self.itemDatas + 1 or #self.itemDatas)
	end
end
function WatchTowerViewPanel:openTimeUp(dt)
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if self.delay_time <= 0 then
			self.is_delay = false
			self:clearScrollData()
			self:refreshData()
		end
	end
end
local MIN_TIME = 2.0
function WatchTowerViewPanel:needRefresh()
	if self.is_delay then
		return false
	end
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if 0.1 < time and time < MIN_TIME then
			self.is_delay = true
			self.delay_time = MIN_TIME
			print("refresh timeup--delay")
			return false
		end
	end
	print("refresh timeup--nodelay")
	self.preClockTime = curTime
	return true
end
function WatchTowerViewPanel:getDefaultClick(...)
	_UPVALUE2_ = nil
	;(nil)[1] = gAllianceQueueClassType.pvp_def
	;(nil)[2] = gAllianceQueueClassType.pvp
	for _, v in pairs(nil) do
		local warQueueData = self:getQueue(v)
		if warQueueData:isHasQueue() then
			return v
		end
	end
	return gAllianceQueueClassType.pvp_def
end
function WatchTowerViewPanel:btn_onClick_btns(tag, name)
	print("==WatchTowerView:btn_onClick_btns==", tag, name)
	dump(gAllianceQueueClassType, "gAllianceQueueClassType")
	if self.curClassType == tag then
		return
	end
	self.curClassType = tag
	self.fields.ComboBox_sort:setVisible(self.curClassType == gAllianceQueueClassType.pvp_def)
	if self.curClassType == gAllianceQueueClassType.pvp_def then
		self.fields.txtNoArmy:setString(i18n("common_text_592"))
	else
		self.fields.txtNoArmy:setString(i18n("common_text_4721"))
	end
	self.curWarData = self:getQueue(self.curClassType)
	self:clearScrollData()
	self:refreshData()
end
function WatchTowerViewPanel:getQueue(classType)
	return self.queueDatas[classType] or self.queueDatas[gAllianceQueueClassType.pvp_def]
end
function WatchTowerViewPanel:initQueueData(...)
	local watchList = kingdomMapCtrl:getWatchTowerQueue():getAllWatchTowerQueue()
	if watchList and next(watchList) ~= nil then
		for key, v in pairs(watchList) do
			local classType = v.classType
			local warQueueData = self:getQueue(classType)
			warQueueData:dataLinkAdd(key, v, true)
		end
	end
end
return WatchTowerViewPanel

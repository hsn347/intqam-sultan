local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EventCenterViewPanel = class("EventCenterViewPanel", baseFguiPanel)
function EventCenterViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("EventCenterViewPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.keysTb, _ENV, self.tableEventData, _ENV, self.canUseOCXs, _ENV, self.myEventList, _ENV, self.logPosition = print, print, print, print, print, print, print, print, 1
	self.pageTimeCount = 1
	self.curClassify = nil
	self.curSelect = 1
	self.isFromUpdate = false
	if self.param and self.param.logPosition then
		self:setLogPosition(self.param.logPosition)
	end
end
function EventCenterViewPanel:onInit()
	print("=======EventCenterViewPanel:onInit")
	self.fields.Com_title:initData(i18n("buildDes_name_106"), handler(self, self.onClickClose))
	self.fields.PageView_events:setVirtualAndLoop()
	self.fields.PageView_events:setItemRenderer(handler(self, self.onPageItemRenderer))
	self.fields.PageView_events:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.PageView_events:childIndexToItemIndex(0)
		self.curSelect = itemIndex % self.pagesCount + 1
		self.fields.List_point:setSelectedIndex(self.curSelect - 1)
	end)
	self.fields.List_point:setNeedAutoFix(false)
	self.scroll = self.fields.Scroll_events
	self.scroll:addEventListener(fgui.UIEventType.Scroll, function()
		self:updateScroll()
	end)
	self.Node_activity_open = self.scroll:getChild("Node_activity_open")
	self.Node_activity_open:setString(i18n("activity_text_05"))
	self.Node_activity_prepare = self.scroll:getChild("Node_activity_prepare")
	self.Node_activity_prepare:setString(i18n("activity_text_06"))
	self:initData()
	self:startSystemTimeLabel()
	self:activeTimeUp()
	self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.ACTIVITY_CENTER)
	SoraDGetCtrl("newPlayerTaskCtrl"):sendToActivityCenter()
end
function EventCenterViewPanel:onShow()
	print("=======EventCenterViewPanel:onShow")
	_ENV = nil
	;(nil).position = 1
	;(nil).lable = self.curClassify
	userSDKManager.logEvent(gSDKDef.TDonEvent.event_center, nil)
	local sSize = self.fields.PageView_events:getContentSize()
	local vWidth = self:getWidth()
	local newSize = cc.size(vWidth, vWidth / sSize.width * sSize.height)
	self.fields.Size_events:setSize(newSize)
	self.fields.PageView_events:setScale(vWidth / sSize.width)
end
function EventCenterViewPanel:initData(target, redata)
	if redata and redata.msg == "MESSAGE_UI_EVENTCENTER_REFRESHISNEW" and redata.removeNew then
		self.isFromUpdate = true
	else
		self.isFromUpdate = false
	end
	self:setTabView()
	self:initPageView()
end
function EventCenterViewPanel:setLogPosition(position)
	self.logPosition = position
	print("self.logPosition = ", self.logPosition)
end
function EventCenterViewPanel:refreshScroll(...)
	self:setTabView()
	if not self.tableEventDatas[self.curClassify] then
		_UPVALUE0_ = self.tableEventDatas[self.curClassify]
	end
	self.tableEventData = self.tableEventDatas[self.curClassify]
	self:initScroll()
end
function EventCenterViewPanel:startSystemTimeLabel(...)
	local timerChangeFun = function(dt)
		self.fields.Text_systemTime:setString(string.format("UTC+0  %s", os.date("!%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime())))
	end
	timerChangeFun()
	self.systimer = SoradCreateTimer(self, timerChangeFun)
end
function EventCenterViewPanel:onClickTabBtn(index)
	if index == self.curClassify then
		return
	end
	print("==EventCenterViewPanel:onClickTabBtn==", index)
	self.isFromUpdate = false
	self.curClassify = index
	local labelTag = self.curClassify == 1 and 6 or self.curClassify - 1
	_ENV = nil
	;(nil).position = self.logPosition
	;(nil).lable = labelTag
	userSDKManager.logEvent(gSDKDef.TDonEvent.activity_label_select, nil)
	print("labelTag = ", labelTag, ", self.logPosition = ", self.logPosition)
	self.scroll:getScrollPane():scrollTop()
	self.scroll:getScrollPane():updatePositionImmediately()
	self:initPageView()
	for k, v in pairs(self.myEventList) do
		if v.point then
			v.point:doShowAnimation()
		end
	end
end
function EventCenterViewPanel:onIntoPanel(...)
	print("==EventCenterView:onIntoPanel==")
	print("重新显示的时候刷新一下红点===========")
	self:refreshScroll()
end
function EventCenterViewPanel:setTabView()
	self.tableEventDatas, _ENV = nil, nil
	if not IsArClient then
		self.tableEventDatas[4] = clientEventMgr.nowEventStateList
	end
	local isOpen1 = clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_1)
	local isOpen2 = clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_2)
	for k, v in pairs(clientEventMgr.nowEventStateList) do
		local classifyTable = activityShowCtrl:getActivityClassifyByID(k)
		local classify = 1
		if type(classifyTable) ~= "number" then
			classify = classifyTable[1]
			if classifyTable[2] and (not (classify ~= 6 or isOpen1) or classify == 5 and not isOpen2) then
				classify = classifyTable[2]
			end
		else
			classify = classifyTable
		end
		if not self.tableEventDatas[classify] then
			self.tableEventDatas[classify], _ENV = classifyTable, classifyTable
		end
		self.tableEventDatas[classify][k] = v
	end
	_ENV, _ENV = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_01")
	_ENV, pairs(clientEventMgr.nowEventStateList)[1], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_02")
	_ENV, pairs(clientEventMgr.nowEventStateList)[2], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_03")
	_ENV, pairs(clientEventMgr.nowEventStateList)[3], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_04")
	_ENV, pairs(clientEventMgr.nowEventStateList)[4], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_05")
	_ENV, pairs(clientEventMgr.nowEventStateList)[5], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("activity_page_06")
	_ENV, pairs(clientEventMgr.nowEventStateList)[6], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	pairs(clientEventMgr.nowEventStateList).name = i18n("recharge_label_011")
	pairs(clientEventMgr.nowEventStateList)[7], pairs(clientEventMgr.nowEventStateList).sortIndex = pairs(clientEventMgr.nowEventStateList)
	local nameConfig = pairs(clientEventMgr.nowEventStateList)
	if not IsArClient then
		_ENV, _ENV = i18n("recharge_label_011"), IsArClient
		i18n("recharge_label_011").name = i18n("activity_page_01")
		_ENV, IsArClient[1], i18n("recharge_label_011").sortIndex = i18n("recharge_label_011"), i18n("recharge_label_011"), 3
		i18n("recharge_label_011").name = i18n("activity_page_02")
		_ENV, IsArClient[2], i18n("recharge_label_011").sortIndex = i18n("recharge_label_011"), i18n("recharge_label_011"), 2
		i18n("recharge_label_011").name = i18n("activity_page_03")
		_ENV, IsArClient[3], i18n("recharge_label_011").sortIndex = i18n("recharge_label_011"), i18n("recharge_label_011"), 1
		i18n("recharge_label_011").name = i18n("common_text_635")
		_ENV, IsArClient[4], i18n("recharge_label_011").sortIndex = i18n("recharge_label_011"), i18n("recharge_label_011"), 4
		i18n("recharge_label_011").name = i18n("recharge_label_011")
		nameConfig, IsArClient[7], i18n("recharge_label_011").sortIndex = IsArClient, i18n("recharge_label_011"), 2.5
	end
	local _ENV, exchangeIDArray = IsArClient, IsArClient
	for i = 1, 7 do
		if self.tableEventDatas[i] then
			if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_1) then
				if i ~= 6 then
					table.insert(exchangeIDArray, i)
				end
			elseif i == 2 then
				if not self.tableEventDatas[6] then
					table.insert(exchangeIDArray, i)
				end
			else
				table.insert(exchangeIDArray, i)
			end
		end
	end
	if not table.indexof(exchangeIDArray, self.curClassify) then
		if not IsArClient then
			self.curClassify = 4
		else
			self.curClassify = exchangeIDArray[1]
		end
	end
	_ENV = exchangeIDArray[1]
	local configData.tabsetArray, _ENV, exchangeIDArray[1].callback, configData = handler(self, self.onClickTabBtn), handler(self, self.onClickTabBtn), handler(self, self.onClickTabBtn), exchangeIDArray[1]
	configData.defaultClick = self.curClassify or exchangeIDArray[1]
	for k, v in ipairs(exchangeIDArray) do
		_ENV = nil
		;(nil).title = nameConfig[v].name
		;(nil).tag = v
		;(nil).sortIndex = nameConfig[v].sortIndex
		table.insert(configData.tabsetArray, nil)
	end
	table.sort(configData.tabsetArray, function(a, b)
		return a.sortIndex > b.sortIndex
	end)
	if not IsArClient then
		configData.defaultClick = self.curClassify or 4
	end
	self.fields.com_Tab:initView(configData)
	for i, v in ipairs(configData.tabsetArray) do
		local needRedPoint = false
		local needNew = false
		local neeLimited = v.tag == 5 or v.tag == 6
		for eventID, __ in pairs(self.tableEventDatas[v.tag]) do
			local tips = clientEventMgr.getNewAndRedPointInfo(eventID)
			if not needRedPoint and tips.redPoint and tips.redPoint ~= 0 then
				needRedPoint = true
			end
			if not needNew and tips.isNew then
				needNew = true
			end
			if needRedPoint and needNew then
				break
			end
		end
		self.fields.com_Tab:setTimeLimitState(i, neeLimited and not needRedPoint)
		self.fields.com_Tab:setBtnRedDot(i, needRedPoint)
		self.fields.com_Tab:setNewState(i, needNew)
	end
end
function EventCenterViewPanel:initScroll(...)
	self:refreshTable()
	self:updateScroll()
end
function EventCenterViewPanel:initPageView(...)
	if not self.tableEventDatas[self.curClassify] then
		_ENV = self.tableEventDatas[self.curClassify]
	end
	self.tableEventData = self.tableEventDatas[self.curClassify]
	local keys = table.keys(self.tableEventData)
	self.keysTb = clientEventMgr.getSortTblByCeHua(keys, self.isFromUpdate, self.keysTb)
	local _ENV, tmpEventList = clientEventMgr.getSortTblByCeHua(keys, self.isFromUpdate, self.keysTb), clientEventMgr.getSortTblByCeHua(keys, self.isFromUpdate, self.keysTb)
	for _, v in ipairs(self.keysTb) do
		if not self.tableEventData[v.eid].noPage then
			table.insert(tmpEventList, self.tableEventData[v.eid])
		end
	end
	self.tmpEventList = tmpEventList
	self.pagesCount = #self.tmpEventList
	self.fields.PageView_events:setNumItems(self.pagesCount)
	self.fields.List_point:setNumItems(self.pagesCount)
	self.curSelect = math.min(self.curSelect, self.pagesCount)
	self.fields.List_point:setSelectedIndex(self.curSelect - 1)
	self:initScroll()
end
function EventCenterViewPanel:onPageItemRenderer(index, obj)
	local pageData = self.tmpEventList[index + 1]
	obj:initPageData(pageData)
end
function EventCenterViewPanel:refreshTable()
	for _, v in pairs(self.myEventList) do
		if v.point then
			v.point:setVisible(false)
			v.point:setPosition(0, 0)
			table.insert(self.canUseOCXs, v.point)
		end
	end
	self.myEventList, _ENV = pairs(self.myEventList)
	local _ENV, activityPrepara = pairs(self.myEventList)
	local _ENV, activityOpen = pairs(self.myEventList)
	for _, v in ipairs(self.keysTb) do
		local data = self.tableEventData[v.eid]
		if data then
			if data.eventState and (data.eventState == gActivityState.PREPARE or data.eventState == gActivityState.CLOSE) and v.eid ~= gActivityTimeActivityID.VALUE_REBATE_ACTIVITY then
				table.insert(activityPrepara, data)
			else
				table.insert(activityOpen, data)
			end
		end
	end
	_ENV, _UPVALUE2_ = ipairs(self.keysTb)
	ipairs(self.keysTb).data = activityOpen
	_ENV, ipairs(self.keysTb).node = self.Node_activity_open, self.Node_activity_open
	self.Node_activity_open.data = activityPrepara
	self.Node_activity_open.node = self.Node_activity_prepare
	ipairs(self.keysTb)[1] = ipairs(self.keysTb)
	local ipairs(self.keysTb)[2], activityTable = self.Node_activity_open, ipairs(self.keysTb)
	local titleH = 50
	local itemH = 274
	local itemW = 210
	local sSize = self.scroll:getContentSize()
	local arr = SoraDFIsRA() and 1 or -1
	local index = 1
	local offsetY = 3
	for _, activityData in ipairs(activityTable) do
		local hasNum = 0 < #activityData.data
		if not hasNum then
			activityData.node:setVisible(false)
			activityData.node:setPosition(0, 0)
		else
			activityData.node:setVisible(true)
			activityData.node:setPositionY(offsetY)
			offsetY = offsetY + titleH
			for i, v in ipairs(activityData.data) do
				if 3 < i and (i - 1) % 3 == 0 then
					offsetY = offsetY + itemH
				end
				_ENV = nil
				;(nil).index = index
				;(nil).data = v
				;(nil).posY = offsetY
				;(nil).posX = sSize.width / 2 - ((i - 1) % 3 - 1) * itemW * arr - 0.5 * itemW + 5
				table.insert(self.myEventList, nil)
				index = index + 1
			end
			offsetY = offsetY + itemH
		end
	end
end
function EventCenterViewPanel:createItem(itemData, ocx)
	if ocx then
		ocx:initSingleData(itemData)
		return ocx
	else
		local single = fgui.UIPackage:createObject("EventCenterView", "EventCenterSingle")
		single:initSingleData(itemData)
		return single
	end
end
function EventCenterViewPanel:updateScroll(...)
	local scrollPane = self.scroll:getScrollPane()
	local sSize = self.scroll:getContentSize()
	local offsetY = scrollPane:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 260)
	local self.scroll.endY, tableShowH = offsetY + scrollH + 260, self.scroll
	for k, v in pairs(self.myEventList) do
		if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
			if v.point then
				table.insert(self.canUseOCXs, v.point)
				v.point:setVisible(false)
				v.point:setPosition(0, 0)
				v.point = nil
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		elseif 0 < #self.canUseOCXs then
			v.point = table.remove(self.canUseOCXs)
			self:createItem(v.data, v.point)
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		else
			local single = self:createItem(v.data)
			single:setPosition(v.posX, v.posY)
			self.scroll:addChild(single)
			v.point = single
		end
	end
end
function EventCenterViewPanel:pageFoward(...)
	self.curSelect = self.curSelect % (self.pagesCount + 1) + 1
	self.fields.PageView_events:scrollToView(self.curSelect - 1, true)
end
function EventCenterViewPanel:activeTimeUp()
	self.pageTimeCount = self.pageTimeCount + 1
	if self.pageTimeCount >= 5 then
		self.pageTimeCount = 0
		self:pageFoward()
	end
end
function EventCenterViewPanel:gameGuide_getTarget(itemName, parameters)
	print("==gameGuide_getTarget==", itemName)
	dump(parameters, "==parameters==")
	if itemName == "eventCenterSingle" then
		local single
		for i, v in ipairs(self.scroll:getChildren()) do
			if v.getActivityID and v:getActivityID() == parameters.eid then
				single = v
				break
			end
		end
		return single
	elseif itemName == "Panel_guide" then
		return self.fields.com_Tab
	end
	return self.fields[itemName]
end
return EventCenterViewPanel

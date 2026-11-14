local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local planThoroughCtrl = SoraDGetCtrl("planThoroughCtrl")
local planThoroughRead = include("planThoroughRead")
local eventRushTaskCtrl = SoraDGetCtrl("eventRushTaskCtrl")
local eventRushTaskRead = include("eventRushTaskRead")
local recruitmentRead = include("recruitmentRead")
local noviceGiftCtrl = SoraDGetCtrl("noviceGiftCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonTaskActivityPanel = class("CommonTaskActivityPanel", baseFguiPanel)
function CommonTaskActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonTaskActivityPanel:ctor", self.viewName)
end
_ENV, CommonTaskActivityPanel.getPackageList = function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
_ENV = nil
;(nil).title = "activity_name_25"
;(nil).bg = "img_9001149_bg.png"
;(nil).faq = "common_text_4448"
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end)[gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY], (nil).showTab = nil, true
_ENV = nil
;(nil).title = "activity_name_9001158"
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end)[gActivityTimeActivityID.RECRUITMENT_MATERIALS], (nil).bg = nil, "img_9001158_bg.png"
_ENV = nil
;(nil).title = "activity_name_9001319"
;(nil).bg = "img_9001319_bg.png"
;(nil).faq = "overRall_text_01"
;(nil).showTab = true
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end)[gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY], (nil).initReq = nil, "planThoroughCtrl"
local function config(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonTaskActivityPanel:onInit()
	print("=======CommonTaskActivityPanel:onInit")
	self.subType = 1
	self.activityID = self.proxy.param.activityID
	if not self.activityID then
		self:removeFromParent()
		return
	end
	self.activityConfig = config[self.activityID]
	self.fields.Com_title:initData(i18n(self.activityConfig.title), handler(self, self.onClickClose))
	if self.activityID == gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY then
		local leftTime = planThoroughCtrl:getCloseTime()
		self.fields.Com_title:initSpecialActivityTime(leftTime)
	else
		self.fields.Com_title:initCommonActivityTime(self.activityID)
	end
	if self.activityConfig.faq then
		self.fields.Com_title:setHelpCallBack(handler(self, self.onClickHelp))
	end
	self.fields.Bg:setURL(self.activityConfig.bg or string.format("img_%s_bg.png", tostring(self.activityID)))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	if self.activityConfig.showTab then
		local func = "getTabConfig" .. self.activityID
		self.controllers.c1:setSelectedIndex(1)
		if self[func] then
			_ENV = 1
			;(1).defaultClick = 1
			;(1).tabsetArray = self[func](self)
			;(1).callback = handler(self, self.onClickTab)
			self.fields.Com_Tab:initView(1)
		end
	end
end
function CommonTaskActivityPanel:onShow()
	print("=======CommonTaskActivityPanel:onShow")
	if self.activityID == gActivityTimeActivityID.RECRUITMENT_MATERIALS and not noviceGiftCtrl:getIsEnd() then
		SoraDRemoveAllAfterPanelFromManager()
		return
	end
	if self.activityConfig.initReq then
		SoraDGetCtrl(self.activityConfig.initReq):sendReqInitDataMsg()
	else
		self:updateScrollView()
	end
end
function CommonTaskActivityPanel:updateScrollView()
	self.taskConfig = self:getTaskConfig()
	dump(self.taskConfig, "self.taskConfig")
	self.fields.List:setNumItems(#self.taskConfig)
	self:updateRedPoint()
end
function CommonTaskActivityPanel:onItemRederer(index, target)
	self.taskConfig[index + 1].activityID = self.activityID
	target:initData(self.taskConfig[index + 1])
	local getAwardHandler, skipToHandler
	if self["getAwardHandler" .. self.activityID] then
		getAwardHandler = handler(self, self["getAwardHandler" .. self.activityID])
	end
	if self["skipToHandler" .. self.activityID] then
		skipToHandler = handler(self, self["skipToHandler" .. self.activityID])
	end
	target:setHandler(getAwardHandler, skipToHandler)
end
function CommonTaskActivityPanel:getTaskConfig()
	local func = "getTaskConfig" .. self.activityID
	if self[func] then
		return self[func](self)
	end
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	return eventQuestRead.getSortList(self.activityID, serverData)
end
function CommonTaskActivityPanel:getTaskConfig9001119()
	local taskList = eventRushTaskRead.sunSetTaskConfig
	local getStatus = function(data)
		local status = gBtnTargetStatusDef.GO
		if data.receive then
			status = gBtnTargetStatusDef.GOT
		elseif data.finishCount >= data.amount then
			status = gBtnTargetStatusDef.GET
		end
		return status
	end
	table.sort(taskList, function(a, b)
		local aData = eventRushTaskCtrl:getSunsetTaskStatusByID(a.taskID)
		local bData = eventRushTaskCtrl:getSunsetTaskStatusByID(b.taskID)
		a.taskStatus = getStatus(aData)
		b.taskStatus = getStatus(bData)
		a.progress = aData.finishCount
		b.progress = bData.finishCount
		if a.taskStatus == b.taskStatus then
			return a.taskID < b.taskID
		else
			return a.taskStatus < b.taskStatus
		end
	end)
	return taskList
end
function CommonTaskActivityPanel:getTaskConfig9001149()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	print("self.subType = ", self.subType)
	local taskList = eventQuestRead.getDailySortList(self.subType, serverData)
	return taskList
end
function CommonTaskActivityPanel:getTaskConfig9001158()
	local taskList = recruitmentRead.getDayAndAwardsList()
	dump(taskList, "taskList")
	for i, v in ipairs(taskList) do
		v.taskStatus = gBtnTargetStatusDef.GO
		if noviceGiftCtrl:getCanReceiveByDay(v.taskID) then
			v.taskStatus = gBtnTargetStatusDef.GET
		end
		if noviceGiftCtrl:getCurrentDay() < v.taskID then
			v.taskStatus = gBtnTargetStatusDef.GO
		end
		v.count = noviceGiftCtrl:getCurrentDay()
		if noviceGiftCtrl:isAlreadyReceiveByDay(v.taskID) then
			v.taskStatus = gBtnTargetStatusDef.GOT
		end
	end
	table.sort(taskList, function(l, r)
		if l.taskStatus ~= r.taskStatus then
			return l.taskStatus < r.taskStatus
		else
			return l.taskID < r.taskID
		end
	end)
	return taskList
end
function CommonTaskActivityPanel:getTaskConfig9001319()
	local serverData = planThoroughCtrl:getQuestData()
	print("self.subType = ", self.subType)
	local taskList = planThoroughRead.getDailySortList(self.subType, serverData)
	for _, v in ipairs(taskList) do
		for _, item in ipairs(v.award) do
			local quality = include("publicRead").getQuality(item.id)
			if quality == gQualityDef.ORANGE then
				item.heightLight = true
			end
		end
	end
	return taskList
end
function CommonTaskActivityPanel:getTabConfig9001149()
	local _ENV, tabsetArray
	for i, v in ipairs(eventQuestRead.dailyTargetConfig) do
		_ENV = nil
		;(nil).title = i18n(eventQuestRead.getDailyQuestName(i))
		;(nil).tab = i
		table.insert(tabsetArray, nil)
	end
	return tabsetArray
end
function CommonTaskActivityPanel:getTabConfig9001319()
	local _ENV, tabsetArray
	for i, v in ipairs(planThoroughRead.dailyTargetConfig) do
		_ENV = nil
		;(nil).title = i18n(planThoroughRead.getDailyQuestName(i))
		;(nil).tab = i
		table.insert(tabsetArray, nil)
	end
	return tabsetArray
end
function CommonTaskActivityPanel:updateRedPoint()
	if self.activityConfig.showTab then
		local func = "updateRedPoint" .. self.activityID
		if self[func] then
			self[func](self)
		end
	end
end
function CommonTaskActivityPanel:updateRedPoint9001149()
	for i, v in ipairs(eventQuestRead.dailyTargetConfig) do
		local isVisible, num = eventQuestRead.getReceiveStatusAndNum(i)
		self.fields.Com_Tab:setBtnRedDot(i, isVisible, num)
	end
end
function CommonTaskActivityPanel:updateRedPoint9001319()
	for i, v in ipairs(planThoroughRead.dailyTargetConfig) do
		local isVisible, num = planThoroughCtrl:getTabStatusAndNum(i)
		self.fields.Com_Tab:setBtnRedDot(i, isVisible, num and num or 0)
	end
end
function CommonTaskActivityPanel:getAwardHandler9001319(taskID)
	SoraDShowLoading(self)
	planThoroughCtrl:reqReward(taskID)
end
function CommonTaskActivityPanel:getAwardHandler9001119(taskID)
	SoraDShowLoading(self)
	_ENV = nil
	;(nil).taskID = taskID
	eventRushTaskCtrl:reqCommitSunSetTask(nil)
end
function CommonTaskActivityPanel:getAwardHandler9001158(taskID)
	SoraDShowLoading(self)
	noviceGiftCtrl:sendReceiveMsg()
end
function CommonTaskActivityPanel:skipToHandler9001119(type, taskDes)
	if type then
		if type ~= gSunsetConditionType.USE_GOLD then
			local qData = eventRushTaskRead.getTaskCondition(type)
			if qData.questType then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local qtype = qData.questType
				mildGuideManager:starMildByNewPlayerQuestID(qtype, qData)
			end
		end
		SoraDShowMsgTip(i18n(taskDes))
		SoraDRemoveAllPanelFromManager()
	end
end
function CommonTaskActivityPanel:onClickTab(tag)
	self.subType = tag
	self:updateScrollView()
end
function CommonTaskActivityPanel:onClickHelp()
	if self.activityConfig.faq then
		SoraDPlaySound()
		_ENV = nil
		;(nil).content = i18n(self.activityConfig.faq)
		uiManager:show("RuleView", nil)
	end
end
return CommonTaskActivityPanel

local activity_9001625_Read = include("activity_9001625_Read")
local activityTimeRead = include("activityTimeRead")
local activity_9001631_Ctrl = SoraDGetCtrl("activity_9001631_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001631_MainPanel = class("Activity_9001631_MainPanel", baseFguiPanel)
function Activity_9001631_MainPanel:ctor(...)
	Activity_9001631_MainPanel.super.ctor(self, ...)
	print("Activity_9001631_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.PREPARING_FEAST_2024
	self.jumpActivityID = gActivityTimeActivityID.GATHERING_FEAST_2024
	self.feastConfig = activity_9001625_Read.getFeastConfig()
	self.scoreList = activity_9001625_Read.getFeastScoreList()
	self.taskConfig = activity_9001625_Read.getTaskConfig()
	self.curTag = 1
end
function Activity_9001631_MainPanel:onInit()
	print("=======Activity_9001631_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_activity:addClickListener(handler(self, self.onClickBtnActivity))
	local showName = activityTimeRead.getActivityShowName(self.jumpActivityID)
	self.fields.Button_activity:setString(showName)
	self.fields.Text_noAlliance:setString(i18n("gathering_activity_text2") .. i18n("pyramid_text_02"))
	if allianceMgr:hasJoinAlliance() then
		self.fields.Text_reward:setString(i18n("preparing_feast_text4"))
		self.controllers.c_alliance:setSelectedIndex(0)
	else
		self.fields.Text_reward:setString(i18n("preparing_feast_text5"))
		self.controllers.c_alliance:setSelectedIndex(1)
	end
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxItemRenderer))
	self.fields.List_box:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickBoxItem))
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	if not SoraDFIsRA() then
		self.fields.bar:fixPos()
		self.fields.bar:getChild("bar"):fixPos()
		self.fields.List_box:fixPos()
		self.fields.Com_point:fixPos()
		self.fields.Text_point:fixPos()
		self.fields.Load_point:fixPos()
	end
end
function Activity_9001631_MainPanel:onShow()
	print("=======Activity_9001631_MainPanel:onShow")
	self:updateAllianceScore()
	local dayMax = activity_9001625_Read.getActivityQuestMaxDay()
	self.dayMax = dayMax
	local curDay = activityShowCtrl:getCurOpenDay(self.activityID)
	self.curDay = curDay
	local _ENV, tabsetArray = activityShowCtrl, activityShowCtrl
	for day = 1, dayMax do
		local isLock = day > curDay
		_ENV = nil
		_ENV = nil
		;(nil).day = day
		;(nil).title = i18n("common_text_3723", nil)
		;(nil).isLock = isLock
		;(nil).isBright = not isLock
		table.insert(tabsetArray, nil)
	end
	_ENV = (for index)
	;(1).defaultClick = math.min(curDay, dayMax)
	;(1).tabsetArray = tabsetArray
	local (1).callback, param = handler(self, self.onClickTab), 1
	self.fields.Com_Tab:initView(param)
	self:updateBtnRed()
	activity_9001631_Ctrl:sendReqInitDataMsg()
end
function Activity_9001631_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("preparing_feast_text1")
	uiManager:show("RuleView", nil)
end
function Activity_9001631_MainPanel:onClickBtnActivity(...)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.jumpActivityID)
end
function Activity_9001631_MainPanel:onBoxItemRenderer(index, obj)
	local cfg = self.feastConfig[index + 1]
	local point = activity_9001625_Read.getFeastPoint(cfg)
	obj:setString(string.formatnumberthousands(point))
	local c_state = obj:getController("c_state")
	if point <= self.curScore then
		c_state:setSelectedIndex(1)
	else
		c_state:setSelectedIndex(0)
	end
end
function Activity_9001631_MainPanel:onClickBoxItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_box:getChildIndex(obj)
	local feastId = childIndex + 1
	_ENV = nil
	;(nil).feastId = feastId
	;(nil).cfg = self.feastConfig[feastId]
	uiManager:show("Activity_9001631_Reward", nil)
end
function Activity_9001631_MainPanel:onTaskItemRenderer(index, obj)
	local task = self.taskList[index + 1]
	obj:initData(task)
	obj:setHandler(handler(self, self.getAwardHandler))
end
function Activity_9001631_MainPanel:getAwardHandler(taskID)
	print("==Activity_9001631_MainPanel:getAwardHandler==", taskID)
	if allianceMgr:hasJoinAlliance() then
		activity_9001631_Ctrl:reqTaskReward(taskID)
	else
		_ENV = nil
		;(nil).isHtml = true
		SoraDShowMsgBox(i18n("preparing_feast_text6"), nil, nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				activity_9001631_Ctrl:reqTaskReward(taskID)
			end
		end, nil)
	end
end
function Activity_9001631_MainPanel:onClickTab(tag)
	print("==Activity_9001631_MainPanel:onClickTab==", tag)
	if tag > self.curDay then
		SoraDShowMsgTip(i18n("common_text_2274"))
		self.fields.Com_Tab:setTabIndex(self.curTag)
		return
	end
	self.curTag = tag
	self:updateTaskList()
end
function Activity_9001631_MainPanel:updateTaskList(...)
	if not self.taskConfig[self.curTag] then
		local activityTaskComponentCtrl, taskIDList = self.taskConfig[self.curTag], self.taskConfig[self.curTag]
	end
	self.taskList = activityTaskComponentCtrl:getTaskList(self.activityID, taskIDList)
	self.fields.List_task:setNumItems(#self.taskList)
end
function Activity_9001631_MainPanel:updateAllianceScore(...)
	local score = 0
	if allianceMgr:hasJoinAlliance() then
		score = activity_9001631_Ctrl:getAllianceScore()
		allianceMgr = score
		score.color = "#FFDF2D"
		local pointStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(score), score)
		self.fields.Text_point:setString(i18n("gathering_activity_text2") .. pointStr)
		fguiHelper.setTextWidthHeight(self.fields.Text_point, cc.size(400, 36))
	end
	if self.curScore == score then
		return
	end
	self.curScore = score
	self.fields.Com_point:setString(string.formatnumberthousands(score))
	local percent = SoraDGetStageValue(score, self.scoreList)
	self.fields.bar:setValue(percent)
	self.fields.List_box:setNumItems(#self.feastConfig)
end
function Activity_9001631_MainPanel:updateBtnRed(...)
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	for day = 1, self.curDay do
		local isRed = false
		if not self.taskConfig[day] then
			local activityTaskComponentCtrl, taskIDList = self.taskConfig[day], self.taskConfig[day]
		end
		for __, taskID in ipairs(taskIDList) do
			local taskStatus = taskComponent:getTaskState(taskID)
			if taskStatus == gBtnTargetStatusDef.GET then
				isRed = true
				break
			end
		end
		self.fields.Com_Tab:setBtnRedDot(day, isRed)
	end
end
function Activity_9001631_MainPanel:onMsgUpdateData(target, event)
	if event.subMsg == "score" then
		self:updateAllianceScore()
	else
		self:updateTaskList()
		self:updateAllianceScore()
		self:updateBtnRed()
	end
end
return Activity_9001631_MainPanel

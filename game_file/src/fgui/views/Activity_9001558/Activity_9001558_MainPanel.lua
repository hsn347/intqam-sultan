local activity_9001558_Read = include("activity_9001558_Read")
local activity_9001558_Ctrl = SoraDGetCtrl("activity_9001558_Ctrl")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001558_MainPanel = class("Activity_9001558_MainPanel", baseFguiPanel)
function Activity_9001558_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001558_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY
	self.curTag = 1
	self.curType = 1
end
function Activity_9001558_MainPanel:onInit()
	print("=======Activity_9001558_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_exchange:setString(i18n("common_text_1809"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.List:setItemRenderer(handler(self, self.onTaskItemRender))
end
function Activity_9001558_MainPanel:onShow()
	print("=======Activity_9001558_MainPanel:onShow")
	self.fields.boxBar:initData(self)
	self:updateExchangeRed()
	self:initView()
end
function Activity_9001558_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Stellar_Odyssey_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001558_MainPanel:onClickExchange(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001558_Exchange")
end
function Activity_9001558_MainPanel:onTaskItemRender(index, obj)
	local task = self.taskList[index + 1]
	obj:initData(task)
end
function Activity_9001558_MainPanel:initView()
	local dayMax = activity_9001558_Read.getActivityQuestMaxDay()
	local curDay = activity_9001558_Ctrl:getCurOpenDay()
	local activity_9001558_Read, tabsetArray = activity_9001558_Ctrl, activity_9001558_Ctrl
	for day = 1, dayMax do
		activity_9001558_Read = nil
		activity_9001558_Read = nil
		;(nil).count = day
		;(nil).title = i18n("common_text_523", nil)
		;(nil).tag = day
		;(nil).isLock = day > curDay
		table.insert(tabsetArray, nil)
	end
	activity_9001558_Read = 1
	;(1).defaultClick = self.curTag
	;(1).tabsetArray = tabsetArray
	;(1).callback = handler(self, self.onClickTabDay)
	self.fields.tab_day:initView(1)
	self:updateTabDayRed()
end
function Activity_9001558_MainPanel:updateTabDayRed()
	local dayMax = activity_9001558_Read.getActivityQuestMaxDay()
	local curDay = activity_9001558_Ctrl:getCurOpenDay()
	for day = 1, dayMax do
		if day <= curDay then
			local num = activity_9001558_Ctrl:getDayRewardNum(day)
			self.fields.tab_day:setBtnRedDot(day, 0 < num, num)
		end
	end
end
function Activity_9001558_MainPanel:updateTabGroupRed()
	local cfg = activity_9001558_Read.getTaskConfig(self.curTag)
	for tType, __ in ipairs(cfg) do
		local num = activity_9001558_Ctrl:getDayGroupRewardNum(self.curTag, tType)
		self.fields.tab_type:setBtnRedDot(tType, 0 < num, num)
	end
end
function Activity_9001558_MainPanel:onClickTabDay(tag)
	print("==Activity_9001558_MainPanel:onClickTabDay==", tag)
	local curDay = activity_9001558_Ctrl:getCurOpenDay()
	if tag > curDay then
		_ENV = nil
		;(nil).day = tag
		SoraDShowMsgTip(i18n("digging_task_04", nil))
		self.fields.tab_day:setTabIndex(self.curTag)
		return
	end
	self.curTag = tag
	self:initTaskTab(tag)
end
function Activity_9001558_MainPanel:initTaskTab(day)
	local activity_9001558_Read, tabsetArray
	local cfg = activity_9001558_Read.getTaskConfig(day)
	for tType, __ in ipairs(cfg) do
		activity_9001558_Read = nil
		;(nil).title = activity_9001558_Read.getTabName(day, tType)
		table.insert(tabsetArray, nil)
	end
	activity_9001558_Read = ipairs(cfg)
	ipairs(cfg).defaultClick = self.curType
	ipairs(cfg).tabsetArray = tabsetArray
	ipairs(cfg).callback = handler(self, self.onClickTabType)
	self.fields.tab_type:initView(ipairs(cfg))
	self:updateTabGroupRed()
end
function Activity_9001558_MainPanel:onClickTabType(tag)
	self.curType = tag
	self:initTaskList(tag)
	self.fields.List:scrollToView(0)
end
function Activity_9001558_MainPanel:initTaskList(tType)
	local taskIDList = activity_9001558_Read.getTaskIDList(self.curTag, tType)
	self.taskList, activity_9001558_Read = self.curTag, self.curTag
	for __, taskID in ipairs(taskIDList) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		local task = clone(questInfo)
		task.taskID = taskID
		task.taskStatus = activity_9001558_Ctrl:getQuestStatus(taskID)
		task.progress = activity_9001558_Ctrl:getQuestProgress(taskID)
		task.award = task.reward
		task.activityID = self.activityID
		table.insert(self.taskList, task)
	end
	table.sort(self.taskList, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	self.fields.List:setNumItems(#self.taskList)
end
function Activity_9001558_MainPanel:updateExchangeRed()
	local ret = activity_9001558_Ctrl:getExchangeStatusAndNum()
	self.fields.Button_exchange:setReddot(ret)
end
function Activity_9001558_MainPanel:onIntoPanel()
	self:updateExchangeRed()
end
function Activity_9001558_MainPanel:onMsgReceiveBack()
	SoraDCloseLoading(self:displayObject())
	self.fields.boxBar:initData(self)
end
function Activity_9001558_MainPanel:onMsgUpdateTask()
	local num = activity_9001558_Ctrl:getDayRewardNum(self.curTag)
	self.fields.tab_day:setBtnRedDot(self.curTag, 0 < num, num)
	local num = activity_9001558_Ctrl:getDayGroupRewardNum(self.curTag, self.curType)
	self.fields.tab_type:setBtnRedDot(self.curType, 0 < num, num)
	self:initTaskList(self.curType)
end
return Activity_9001558_MainPanel

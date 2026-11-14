local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local taskRushActivityRead = include("taskRushActivityRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001695_MainPanel = class("Activity_9001695_MainPanel", baseFguiPanel)
function Activity_9001695_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001695_MainPanel.super.ctor(self, ...)
	print("Activity_9001695_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001695
end
function Activity_9001695_MainPanel:onInit()
	print("=======Activity_9001695_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.title:initData(i18n("activity_name_9001695"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.title:initCommonActivityTime(self.activityID)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001695_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self)
end
function Activity_9001695_MainPanel:endShow()
	print("=======Activity_9001695_MainPanel:endShow")
	self.curTag = 1
	self.curType = 1
	local days = taskRushActivityRead.getActivityQuestMaxDay(self.activityID)
	local _ENV, tabsetArray = self.activityID, self.activityID
	for i = 1, days do
		_ENV = nil
		_ENV = nil
		;(nil).count = i
		;(nil).title = i18n("common_text_523", nil)
		;(nil).tag = i
		;(nil).isLock = i > taskRushActivityCtrl:getCurOpenDay(self.activityID)
		table.insert(tabsetArray, nil)
	end
	_ENV = 1
	;(1).defaultClick = self.curTag
	;(1).tabsetArray = tabsetArray
	;(1).callback = handler(self, self.onClickTab)
	self.fields.tab_day:initView(1)
	self:updateTabDayRed()
end
function Activity_9001695_MainPanel:onClickTab(tag)
	if tag > taskRushActivityCtrl:getCurOpenDay(self.activityID) then
		SoraDShowMsgTip(i18n("common_text_2274"))
		self.fields.tab_day:setTabIndex(self.curTag)
		return
	end
	self.curTag = tag
	self:initTaskTab(self.curTag)
end
function Activity_9001695_MainPanel:initTaskTab(day)
	local cfg = taskRushActivityRead.getGroupID(day, self.activityID)
	local taskRushActivityRead, tabsetArray = day, day
	for k, v in ipairs(cfg) do
		taskRushActivityRead = nil
		;(nil).title = taskRushActivityRead.getGroupName(v)
		;(nil).tag = k
		table.insert(tabsetArray, nil)
	end
	taskRushActivityRead = ipairs(cfg)
	ipairs(cfg).defaultClick = self.curType
	ipairs(cfg).tabsetArray = tabsetArray
	ipairs(cfg).callback = handler(self, self.onClickTypeTab)
	self.fields.tab_type:initView(ipairs(cfg))
	self:updateTabGroupRed()
end
function Activity_9001695_MainPanel:onClickTypeTab(tag)
	self.curType = tag
	self:initTaskList(self.curType)
end
function Activity_9001695_MainPanel:updateTabDayRed()
	local days = taskRushActivityRead.getActivityQuestMaxDay(self.activityID)
	for i = 1, days do
		if i <= taskRushActivityCtrl:getCurOpenDay(self.activityID) then
			local num = taskRushActivityCtrl:getDayRewardNum(i, self.activityID)
			self.fields.tab_day:setBtnRedDot(i, 0 < num, num)
		end
	end
end
function Activity_9001695_MainPanel:updateTabGroupRed()
	local groups = taskRushActivityRead.getGroupID(self.curTag, self.activityID)
	for k, v in ipairs(groups) do
		local num = taskRushActivityCtrl:getDayGroupRewardNum(self.curTag, v, self.activityID)
		self.fields.tab_type:setBtnRedDot(k, 0 < num, num)
	end
end
function Activity_9001695_MainPanel:updateView()
	self:initTaskList(self.curType)
	self:updateTabDayRed()
	self:updateTabGroupRed()
end
function Activity_9001695_MainPanel:initTaskList(index)
	local cfg = taskRushActivityRead.getGroupID(self.curTag, self.activityID)
	local cfgList = taskRushActivityRead.getQuest(self.curTag, cfg[index], self.activityID)
	self.taskList, taskRushActivityRead = self.curTag, self.curTag
	for k, v in ipairs(cfgList) do
		taskRushActivityRead = nil
		;(nil).questID = v
		;(nil).status = taskRushActivityCtrl:getQuestStatus(v, self.activityID)
		table.insert(self.taskList, nil)
	end
	table.sort(self.taskList, function(a, b)
		if a.status == b.status then
			return a.questID < b.questID
		else
			return a.status < b.status
		end
	end)
	self.fields.List:setNumItems(#self.taskList)
	self.fields.List:scrollToView(0)
	self.fields.boxBar:initData()
end
function Activity_9001695_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eid_carnival_001")
	uiManager:show("RuleView", nil)
end
return Activity_9001695_MainPanel

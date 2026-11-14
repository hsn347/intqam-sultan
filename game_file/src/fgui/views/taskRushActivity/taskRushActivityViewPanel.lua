local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local taskRushActivityRead = include("taskRushActivityRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local taskRushActivityViewPanel = class("taskRushActivityViewPanel", baseFguiPanel)
function taskRushActivityViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("taskRushActivityViewPanel:ctor", self.viewName)
end
function taskRushActivityViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function taskRushActivityViewPanel:onInit()
	print("=======taskRushActivityViewPanel:onInit")
	self.curTag = 1
	self.curType = 1
	self.activityID = gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	self.fields.title:initData(i18n("Bright_night_activityname_0001"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:initView()
end
function taskRushActivityViewPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self)
end
function taskRushActivityViewPanel:updateView()
	self.fields.boxBar:initData(self)
	self:initTaskList(self.curType)
	self:updateTabDayRed()
	self:updateTabGroupRed()
end
function taskRushActivityViewPanel:updateTabDayRed()
	local days = taskRushActivityRead.getActivityQuestMaxDay()
	for i = 1, days do
		if i <= taskRushActivityCtrl:getCurOpenDay() then
			local num = taskRushActivityCtrl:getDayRewardNum(i)
			self.fields.tab_day:setBtnRedDot(i, 0 < num, num)
		end
	end
end
function taskRushActivityViewPanel:updateTabGroupRed()
	local groups = taskRushActivityRead.getGroupID(self.curTag)
	for k, v in ipairs(groups) do
		local num = taskRushActivityCtrl:getDayGroupRewardNum(self.curTag, v)
		self.fields.tab_type:setBtnRedDot(k, 0 < num, num)
	end
end
function taskRushActivityViewPanel:initView()
	self.fields.boxBar:initData(self)
	local days = taskRushActivityRead.getActivityQuestMaxDay()
	local taskRushActivityRead, tabsetArray = self.fields.boxBar, self.fields.boxBar
	for i = 1, days do
		taskRushActivityRead = nil
		taskRushActivityRead = nil
		;(nil).count = i
		;(nil).title = i18n("common_text_523", nil)
		;(nil).tag = i
		;(nil).isLock = i > taskRushActivityCtrl:getCurOpenDay()
		table.insert(tabsetArray, nil)
	end
	taskRushActivityRead = 1
	;(1).defaultClick = self.curTag
	;(1).tabsetArray = tabsetArray
	;(1).callback = handler(self, self.onClickTab)
	self.fields.tab_day:initView(1)
	self:updateTabDayRed()
	self:updateTabGroupRed()
end
function taskRushActivityViewPanel:initTaskTab(day)
	local cfg = taskRushActivityRead.getGroupID(day)
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
function taskRushActivityViewPanel:initTaskList(index)
	local cfg = taskRushActivityRead.getGroupID(self.curTag)
	local cfgList = taskRushActivityRead.getQuest(self.curTag, cfg[index])
	self.taskList, taskRushActivityRead = self.curTag, self.curTag
	for k, v in ipairs(cfgList) do
		taskRushActivityRead = nil
		;(nil).questID = v
		;(nil).status = taskRushActivityCtrl:getQuestStatus(v)
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
end
function taskRushActivityViewPanel:onShow()
	print("=======taskRushActivityViewPanel:onShow")
end
function taskRushActivityViewPanel:onHide()
	print("=======taskRushActivityViewPanel:onHide")
end
function taskRushActivityViewPanel:onDispose()
	print("=======taskRushActivityViewPanel:onDispose")
end
function taskRushActivityViewPanel:onClickTab(tag)
	print("tag=======", tag)
	if tag > taskRushActivityCtrl:getCurOpenDay() then
		SoraDShowMsgTip(i18n("common_text_2274"))
		self.fields.tab_day:setTabIndex(self.curTag)
		return
	end
	self.curTag = tag
	self:initTaskTab(tag)
end
function taskRushActivityViewPanel:onClickTypeTab(tag)
	self.curType = tag
	self:initTaskList(tag)
end
function taskRushActivityViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Bright_night_activity_rule_0001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return taskRushActivityViewPanel

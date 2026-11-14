local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local troopsExchangeTaskCtrl = SoraDGetCtrl("troopsExchangeTaskCtrl")
local armyChangeRead = include("armyChangeRead")
local eventQuestRead = include("eventQuestRead")
local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeTaskPanel = class("troopsExchangeTaskPanel", basePanel)
function troopsExchangeTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeTaskPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function troopsExchangeTaskPanel:onInit()
	self.tag = 1
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.com_Title:initData(i18n("activity_name_9001369"), handler(self, self.onClickClose))
	self.fields.scroll_Task:setItemRenderer(handler(self, self.onTaskItemRederer))
end
function troopsExchangeTaskPanel:onShow()
	self:initActivityTime()
	local armyChangeRead, tabsetArray = self.initActivityTime, self.initActivityTime
	self.taskList = armyChangeRead.getTaskConfig()
	for _, v in ipairs(self.taskList) do
		armyChangeRead = nil
		;(nil).title = i18n(v.des)
		;(nil).tag = v.type
		table.insert(tabsetArray, nil)
	end
	armyChangeRead = (for generator)
	ipairs(self.taskList).defaultClick = self.tag
	ipairs(self.taskList).tabsetArray = tabsetArray
	local ipairs(self.taskList).callback, param = handler(self, self.onClickTab), ipairs(self.taskList)
	self.fields.com_Tab:setTabNum(#tabsetArray, nil, true)
	self.fields.com_Tab:initView(param)
	self:updatTaskScroll()
	self:updateRedPoint()
	troopsExchangeTaskCtrl:sendReqInitDataMsg()
end
function troopsExchangeTaskPanel:onClickTab(tag)
	self.tag = tag
	self.fields.scroll_Task:jumpToTop()
	self:updatTaskScroll()
end
function troopsExchangeTaskPanel:initActivityTime()
	self.txt_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.BATTLEFIELD_TRAINING)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.txt_time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function troopsExchangeTaskPanel:updatTaskScroll()
	self.questIDList = troopsExchangeTaskCtrl:getTaskList(self.taskList[self.tag].qeustID)
	self.fields.scroll_Task:setNumItems(#self.questIDList)
end
function troopsExchangeTaskPanel:updateRedPoint()
	for i, _ in ipairs(self.taskList) do
		local visible, num = troopsExchangeTaskCtrl:getReddotNumByType(i)
		print(visible, num, i, "updateRedPoint")
		self.fields.com_Tab:setBtnRedDot(i, visible, num)
	end
end
function troopsExchangeTaskPanel:onTaskItemRederer(index, obj)
	local taskID = self.questIDList[index + 1]
	troopsExchangeTaskCtrl = nil
	;(nil).taskID = taskID
	;(nil).progress = troopsExchangeTaskCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = troopsExchangeTaskCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	obj:initData(nil)
	obj:setHandler(handler(self, self.onClickGetTaskAward))
end
function troopsExchangeTaskPanel:onClickGetTaskAward(taskID)
	print(taskID, "taskID")
	SoraDPlaySound()
	SoraDShowLoading()
	troopsExchangeTaskCtrl:reqBattlefieldTrainingClaim(taskID)
end
return troopsExchangeTaskPanel

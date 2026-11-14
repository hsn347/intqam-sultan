local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warHornCtrl = SoraDGetCtrl("warHornCtrl")
local warOrderRead = include("warOrderRead")
local eventQuestRead = include("eventQuestRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarHornMainPanel = class("WarHornMainPanel", baseFguiPanel)
function WarHornMainPanel:ctor(...)
	WarHornMainPanel.super.ctor(self, ...)
	print("WarHornMainPanel:ctor", self.viewName)
end
function WarHornMainPanel:onInit()
	print("=======WarHornMainPanel:onInit")
	self.taskList, _ENV = print, print
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	self.curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
	self.tag = 1
	self.fields.Com_title:initData(i18n("activity_name_9001581"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_Task:setItemRenderer(handler(self, self.onItemTaskRederer))
	self.fields.Button_receiveAll:setString(i18n("ice_carnival_text05"))
	self.fields.Button_receiveAll:addClickListener(handler(self, self.onClickReceive))
	self.fields.Button_receiveAll:setEnabled(false)
	if self:getHeight() > 1250 then
		self.fields.bg_bottom:setPositionY(self:getHeight() - 325)
	end
	self.fields.Progress_score:fixPos()
end
function WarHornMainPanel:onShow()
	print("=======WarHornMainPanel:onShow")
	local activityName = i18n(activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
	_ENV = activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
	_ENV, _ENV, activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).defaultClick = activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
	activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).title = activityName
	_ENV, self.tag[1], activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).tag = activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
	activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).title = i18n("activity_9001581_text_01")
	activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).tabsetArray, self.tag[2], activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).tag = self.tag, activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
	activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
	self:updatRed()
end
function WarHornMainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self:updateView()
	else
		self:updateTask()
	end
end
function WarHornMainPanel:updatRed()
	local rewardRedNum = self.curCtrl:getLvRewardStatusAndNum()
	local taskRedNum = self.curCtrl:getTaskStatusAndNum()
	print("rewardRedNum,taskRedNum=====", rewardRedNum, taskRedNum)
	self.fields.Com_tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
end
function WarHornMainPanel:onItemTaskRederer(index, target)
	local taskID = self.taskList[index + 1]
	eventQuestRead = nil
	;(nil).taskID = taskID
	;(nil).progress = self.curCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = self.curCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	;(nil).activityID = self.activityID
	target:initData(nil)
end
function WarHornMainPanel:updateTask()
	self.taskList = self.curCtrl:getTaskList()
	self.fields.List_Task:setNumItems(#self.taskList)
end
function WarHornMainPanel:updateView()
	self.fields.Com_main:initData()
	self.curLv = self.curCtrl:getLevel()
	self.fields.Progress_score:initData(self.curLv, self.curCtrl:getExp(), warOrderRead.getNextExp(self.activityID, self.curLv, self.curCtrl:getGroupIndex()))
	local rewardRedNum = self.curCtrl:getLvRewardStatusAndNum()
	self.fields.Button_receiveAll:setEnabled(0 < rewardRedNum)
	self.fields.Button_receiveAll:setRed(self.curCtrl:getLvRewardStatusAndNum())
end
function WarHornMainPanel:onClickReceive()
	SoraDPlaySound()
	SoraDShowLoading(self)
	warHornCtrl.reqWarOrderReceive()
end
function WarHornMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("activity_9001581_text_04")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return WarHornMainPanel

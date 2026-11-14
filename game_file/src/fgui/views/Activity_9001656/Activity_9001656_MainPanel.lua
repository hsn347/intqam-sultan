local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001656_MainPanel = class("Activity_9001656_MainPanel", baseFguiPanel)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
local activity_9001656_Read = include("activity_9001656_Read")
function Activity_9001656_MainPanel:ctor(...)
	Activity_9001656_MainPanel.super.ctor(self, ...)
	print("Activity_9001656_MainPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001656_MainPanel:onInit()
	print("=======Activity_9001656_MainPanel:onInit")
	self.view:fixChildrenPos()
	self.activityID = gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_daily:setVirtual()
	self.fields.List_daily:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.fields.Button_buff:setString(i18n("Battle_Towers_23"))
	self.fields.Button_buff:addClickListener(handler(self, self.onClickBtnBuff))
	self.tabIndex = 1
end
function Activity_9001656_MainPanel:onClickHelp()
	SoraDPlaySound()
	dump(self.doStage, "self.doStage")
	if self.doStage == 0 then
		_ENV = nil
		;(nil).content = i18n("warmongering_text1")
		uiManager:show("RuleView", nil)
	else
		_ENV = nil
		;(nil).content = i18n("warmongering_text_6")
		uiManager:show("RuleView", nil)
	end
end
function Activity_9001656_MainPanel:onShow()
	print("=======Activity_9001656_MainPanel:onShow")
	activity_9001656_Ctrl:setClicked()
	self:updateView()
end
function Activity_9001656_MainPanel:updateView()
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	self.doStage = doStage
	self.controllers.c2:setSelectedIndex(doStage == 0 and 0 or 1)
	if doStage == 0 then
		self.fields.Com_9001656_prepare:initData()
	else
		if not self.inited then
			activityShowCtrl = doStage == 0 and 0 or 1
			activityShowCtrl, activityShowCtrl, (doStage == 0 and 0 or 1).defaultClick = nil, nil, 1
			;(nil).title = i18n("anniversary_cross_text_03")
			activityShowCtrl, (nil)[1], (nil).tag = nil, nil, 1
			;(nil).title = i18n("common_text_4498")
			;(doStage == 0 and 0 or 1).tabsetArray, (nil)[2], (nil).tag = nil, nil, 2
			;(doStage == 0 and 0 or 1).callback = handler(self, self.onClickTab)
			self.fields.Com_tab:initView(doStage == 0 and 0 or 1)
		else
			self:updateUI()
		end
		self.inited = true
	end
end
function Activity_9001656_MainPanel:onClickTab(index)
	self.tabIndex = index
	self:updateUI()
end
function Activity_9001656_MainPanel:updateUI()
	self:updateReddot()
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	local lv, exp, expMax = activity_9001656_Read.getLvByExp(activity_9001656_Ctrl:getCurExp())
	self.fields.Label_lv:setString(lv)
	self.fields.Text_exp:setString(string.formatnumberthousands(exp) .. "/" .. string.formatnumberthousands(expMax))
	self.fields.Progress_exp:setMax(expMax)
	self.fields.Progress_exp:setValue(exp)
	if self.tabIndex == 1 then
		self.fields.Panel_reward:updateUI()
	else
		self.taskList = activity_9001656_Ctrl:getTaskList()
		dump(self.taskList, "self.taskList")
		self.fields.List_daily:setNumItems(#self.taskList)
	end
end
function Activity_9001656_MainPanel:updateReddot()
	local isHaveAward = activity_9001656_Ctrl:hasAward()
	local isHaveTaskReward = activity_9001656_Ctrl:getTaskRedNum() > 0
	self.fields.Com_tab:setBtnRedDot(1, isHaveAward)
	self.fields.Com_tab:setBtnRedDot(2, isHaveTaskReward)
end
function Activity_9001656_MainPanel:onTaskItemRenderer(index, obj)
	obj:initDataTaskID(self.taskList[index + 1])
	obj:setHandler(handler(self, self.onGetReward))
end
function Activity_9001656_MainPanel:onGetReward(taskID)
	SoraDPlaySound()
	activity_9001656_Ctrl:reqReward(taskID)
end
function Activity_9001656_MainPanel:onClickBtnBuff()
	SoraDPlaySound()
	uiManager:show("Activity_9001656_Buff")
end
return Activity_9001656_MainPanel

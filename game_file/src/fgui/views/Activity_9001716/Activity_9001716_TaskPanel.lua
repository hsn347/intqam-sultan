local eventQuestRead = include("eventQuestRead")
local activity_9001716_Read = include("activity_9001716_Read")
local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001716_TaskPanel = class("Activity_9001716_TaskPanel", baseFguiPanel)
function Activity_9001716_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001716_TaskPanel.super.ctor(self, ...)
	print("Activity_9001716_TaskPanel:ctor", self.viewName)
end
function Activity_9001716_TaskPanel:onInit()
	self.fields.title:fixPos()
	self.fields.com_icon:fixPos()
	print("=======Activity_9001716_TaskPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("trainTask_text_02"))
	self.fields.txtGet:setText(i18n("common_text_4458"))
	self.fields.btnGo:setTitle(i18n("common_text_477"))
	self.fields.btnGo:addClickListener(handler(self, self.onClickGo))
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001716_TaskPanel:endShow()
	print("=======Activity_9001716_TaskPanel:endShow")
	self:initData(self.param.baseTask, self.param.taskData)
end
function Activity_9001716_TaskPanel:onClickGo(context)
	SoraDPlaySound()
	if self.taskInfo.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE then
		_ENV = nil
		;(nil).taskID = self.taskInfo.taskID
		activity_9001716_Ctrl:reqCommitTask(nil)
		SoraDShowLoading(self)
	elseif self.baseTask.isAct == 1 then
		local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.baseTask.guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	else
		self:close()
	end
end
function Activity_9001716_TaskPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Activity_9001716_TaskPanel:initData(baseTask, taskInfo)
	self.baseTask = baseTask
	self.taskInfo = taskInfo
	_ENV = nil
	;(nil).num = baseTask.taskDes.num
	self.fields.txtDesc:setText(i18n(baseTask.taskDes[1], nil))
	_ENV = "(%s/%s)"
	;("(%s/%s)").size = 20
	;("(%s/%s)").color = "#f0e6d2"
	self.fields.title:setString(i18n(baseTask.taskName[1]) .. SoraDWrapHtmlTagByStyle(string.format("(%s/%s)", string.formatnumberthousands(taskInfo.curNum), string.formatnumberthousands(baseTask.conditionNum)), "(%s/%s)"))
	self.fields.icon:setURL(baseTask.taskIcon)
	self.rewards, _ENV = self.fields.icon.setURL, self.fields.icon.setURL
	for i = 1, #baseTask.taskReward, 2 do
		local _ENV, reward = string.format("(%s/%s)", string.formatnumberthousands(taskInfo.curNum), string.formatnumberthousands(baseTask.conditionNum)), string.format("(%s/%s)", string.formatnumberthousands(taskInfo.curNum), string.formatnumberthousands(baseTask.conditionNum))
		reward.id = baseTask.taskReward[i]
		reward.count = baseTask.taskReward[i + 1]
		table.insert(self.rewards, reward)
	end
	self.fields.List_items:setNumItems(#self.rewards)
	if taskInfo.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE then
		self.fields.btnGo:setTitle(i18n("common_text_1146"))
		self.fields.btnGo:setVisible(true)
	elseif taskInfo.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE_DONE then
		self.fields.btnGo:setVisible(false)
	elseif baseTask.isAct == 0 then
		self.fields.btnGo:setVisible(false)
	else
		self.fields.btnGo:setTitle(i18n("common_text_477"))
		self.fields.btnGo:setVisible(true)
	end
end
return Activity_9001716_TaskPanel

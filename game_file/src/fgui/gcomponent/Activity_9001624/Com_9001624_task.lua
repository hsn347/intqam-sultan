local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activity_9001624_Read = include("activity_9001624_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001624_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001624/Com_9001624_task", Com_9001624_task)
fgui.register_extension("ui://Activity_9001670/Com_9001670_task", Com_9001624_task)
function Com_9001624_task:onInit()
	self.fields.icon_double:fixPos()
end
function Com_9001624_task:onShow()
end
function Com_9001624_task:initData(activityID, data)
	self.activityID = activityID
	self.activity_Ctrl = activity_9001624_Read.getActivityCtrl(self.activityID)
	self.isUnlockAdvance = self.activity_Ctrl:getIsAdvanceRewardUnlock()
	self:initDataTaskID(data)
end
function Com_9001624_task:initDataTaskID(params)
	local eventQuestRead = include("eventQuestRead")
	local activityID = params.activityID
	local taskID = params.taskID
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	local isContinue = false
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not self.activity_Ctrl:isGotTaskPayReward(taskID) then
		taskStatus = gBtnTargetStatusDef.GET
		isContinue = true
	end
	_ENV = taskID
	taskID.taskID = taskID
	taskID.progress = taskComponent:getTaskProgress(taskID)
	taskID.taskStatus = taskStatus
	taskID.taskDes = eventQuestRead.getDes(taskID)
	taskID.award = eventQuestRead.getReward(taskID)
	taskID.aim = eventQuestRead.getAim(taskID)
	taskID.guideId = eventQuestRead.getGuideId(taskID)
	taskID.isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	taskID.activityID = activityID
	self.fields.Com_task:initData(taskID)
	if params.isCanGotPay or isContinue then
		self.fields.Com_task.fields.Button_Task:setTitle(i18n("cityUp_btn_01"))
	end
	self.fields.icon_double:setVisible(self.isUnlockAdvance and not params.isCanGotPay)
end
function Com_9001624_task:setHandler(callbackHandler)
	self.fields.Com_task:setHandler(callbackHandler)
end
return Com_9001624_task

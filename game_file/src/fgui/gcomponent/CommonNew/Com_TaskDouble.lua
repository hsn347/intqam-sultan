local activityCommonDecreeCtrl = SoraDGetCtrl("activityCommonDecreeCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TaskDouble = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_TaskDouble", Com_TaskDouble)
function Com_TaskDouble:onInit()
	self.fields.icon_double:fixPos()
end
function Com_TaskDouble:onShow()
end
function Com_TaskDouble:initData(activityID, data)
	self.activityID = activityID
	self.isUnlockAdvance = self:getIsAdvanceRewardUnlock()
	self:initDataTaskID(data)
	self.fields.Com_task:setHandler(handler(self, self.onGetReward))
end
function Com_TaskDouble:initDataTaskID(params)
	local eventQuestRead = include("eventQuestRead")
	local activityID = params.activityID
	local taskID = params.taskID
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	local isContinue = false
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not self:isGotTaskPayReward(taskID) then
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
function Com_TaskDouble:setHandler(callbackHandler)
	self.fields.Com_task:setHandler(callbackHandler)
end
function Com_TaskDouble:onGetReward(taskID)
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not self.isUnlockAdvance then
		activityTaskComponentCtrl = nil
		;(nil).activityID = self.activityID
		;(nil).rewardType = 2
		uiManager:show("CommonBuyGift", nil)
		return
	end
	activityCommonDecreeCtrl:reqQuestReward(self.activityID, taskID)
end
function Com_TaskDouble:getIsAdvanceRewardUnlock()
	return activityCommonDecreeCtrl:getIsAdvanceRewardUnlock(self.activityID)
end
function Com_TaskDouble:isGotTaskPayReward(taskID)
	return activityCommonDecreeCtrl:isGotTaskPayReward(self.activityID, taskID)
end
return Com_TaskDouble

local gametop = gModuleMgr.getObject("gametop")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local commonTaskSingle = include("commonTaskSingle")
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
local RLC = require_data("return_kinggift_task", true)
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local eventGloryGiftSingle = class("eventGloryGiftSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("eventGloryGiftSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
local MAX_AWARD_NUM = 5
function eventGloryGiftSingle:ctor()
end
function eventGloryGiftSingle:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
	end
	local taskID = data.taskID
	self:initData_imp(data, otherData)
	print("self.taskStatus = ", self.taskStatus, ", taskID = ", taskID)
	self.Button_go:setVisible(true)
	print("显示go按钮-------")
end
function eventGloryGiftSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	SoraDGetCtrl("honorBackCtrl"):reqGloryTaskReward(taskID)
end
function eventGloryGiftSingle:skipTo(taskDes)
	local data = self.data
	dump(data, "任务数据", 10)
	local guideId = data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	print("guideId = ", guideId)
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(self.data.taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return eventGloryGiftSingle

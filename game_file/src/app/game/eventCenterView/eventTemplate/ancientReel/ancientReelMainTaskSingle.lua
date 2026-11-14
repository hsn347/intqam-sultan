local eventQuestRead = include("eventQuestRead")
local gametop = gModuleMgr.getObject("gametop")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local ancientReelMainTaskSingle = class("ancientReelMainTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsMainTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function ancientReelMainTaskSingle:ctor()
end
function ancientReelMainTaskSingle:initData(data, otherData)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
end
function ancientReelMainTaskSingle:doAction()
	SoraDShowLoading(self.view)
	activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, self.activityID)
end
function ancientReelMainTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return ancientReelMainTaskSingle

local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local MAX_AWARD_NUM = 4
local eventLightShiningTaskSingle = class("eventLightShiningTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("eventLightShiningTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function eventLightShiningTaskSingle:initData(data, otherData)
	self:setAwardOffsetY(50)
	self:setRewardOffsetX(60)
	self:setItemWidth(538)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
end
function eventLightShiningTaskSingle:doAction()
	SoraDShowLoading(self.view)
	activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY)
end
function eventLightShiningTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if guideId then
		if worldMapDefine.isInRadiance() then
			if taskDes and next(taskDes) then
				SoraDShowMsgTip(i18n(taskDes))
			end
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		else
			SoraDShowMsgTip(i18n("brightWar_text_79"))
		end
	end
end
return eventLightShiningTaskSingle

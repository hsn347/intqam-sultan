local gametop = gModuleMgr.getObject("gametop")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local starRhapsodyTaskSingle = class("starRhapsodyTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("starRhapsodyTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function starRhapsodyTaskSingle:ctor()
end
function starRhapsodyTaskSingle:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
		self.activityID = otherData.activityID
	end
	local taskID = data.taskID
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
		print("显示go按钮-------")
	end
end
function starRhapsodyTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	activityTaskComponentCtrl:reqRuestClaimReward(taskID, self.activityID or gActivityTimeActivityID.STAR_RHAPSODY)
end
function starRhapsodyTaskSingle:skipTo(taskDes)
	local data = self.data
	local guideId = data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	print("guideId = ", guideId)
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(self.data.taskDes))
	end
	if guideId then
		local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return starRhapsodyTaskSingle

local gametop = gModuleMgr.getObject("gametop")
local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local nodeSalvoItem = class("nodeSalvoItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			target = SoraDCreateBasePanel("nodeSalvoItem")
		end
		local commonTaskSingle = include("commonTaskSingle")
		target = commonTaskSingle.new(target)
		target:setAwardOffsetY(58)
		target:setItemWidth(624)
		target:setRewardOffsetX(50)
		return target
	end
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function nodeSalvoItem:ctor()
	self:createUI()
	self.Button_go = SoraDGetChildByName(self, "Button_go")
end
function nodeSalvoItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeSalvoItem:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
	end
	local taskID = data.taskID
	self:initData_imp(data, otherData)
	print("self.taskStatus = ", self.taskStatus, ", taskID = ", taskID, "eventQuestRead:isNeedShowGo(taskID) = ", eventQuestRead.isNeedShowGo(taskID))
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
		print("显示go按钮-------")
	end
end
function nodeSalvoItem:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	activityTaskComponentCtrl:reqRuestClaimReward(taskID, self.data.activityID)
end
function nodeSalvoItem:skipTo(taskDes)
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
return nodeSalvoItem

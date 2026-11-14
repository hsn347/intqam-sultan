local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local MAX_AWARD_NUM = 4
local anniversaryFlameTaskSingle = class("anniversaryFlameTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anniversaryFlameTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function anniversaryFlameTaskSingle:initData(data, otherData)
	self.textGot = SoraDGetChildByName(self, "Text_Got")
	self.scheduBgColor = "#a9997f"
	self.desBgColor = "#aa9682"
	self.scheduValeColor = "#00be1e"
	self:setAwardOffsetY(50)
	self:setRewardOffsetX(60)
	self:setItemWidth(538)
	self:specialCheck(data)
	dump(data, "anniversaryFlameTaskSingle:initData", 10)
	self:initData_imp(data, otherData)
	if not (self.taskStatus ~= gBtnTargetStatusDef.GO or eventQuestRead.isNeedShowGo(data.taskID)) or self.taskStatus == gBtnTargetStatusDef.GOT then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	if self.textGot then
		self.textGot:setVisible(self.taskStatus == gBtnTargetStatusDef.GOT)
		self.textGot:setString(i18n("common_text_1892"))
	end
end
function anniversaryFlameTaskSingle:specialCheck(info)
	if info.ruleID == 94 then
		if info.count >= info.total then
			info.count = 1
			info.total = 1
		else
			info.count = 0
			info.total = 1
		end
	end
end
function anniversaryFlameTaskSingle:doAction()
end
function anniversaryFlameTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	elseif tbParam.id == gNewPLayerTaskType.ANNIVERSARY_FLAME then
		local panel = SoraDCreatePanel("anniversaryFlameAlliance")
		panel:initData()
		panel:show()
		self.view:removeFromParent()
		return
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return anniversaryFlameTaskSingle

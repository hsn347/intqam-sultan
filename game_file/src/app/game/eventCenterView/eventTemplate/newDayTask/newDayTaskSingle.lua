local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local newDayTaskSingle = class("newDayTaskSingle", function(target)
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function newDayTaskSingle:ctor()
	self.finishNode = SoraDGetChildByName(self, "Node_Finish")
	SoraDGetChildByName(self.finishNode, "Text_Finish"):setString(i18n("common_text_2601"))
	SoraDGetChildByName(self.finishNode, "frame_csyx_gou02_3"):setCascadeColorEnabled(false)
	SoraDGetChildByName(self.finishNode, "frame_csyx_gou02_3"):setOpacityModifyRGB(false)
	SoraDGetChildByName(self.finishNode, "frame_csyx_gou02_3"):setColor(cc.c3b(136, 116, 96))
end
function newDayTaskSingle:initData(data, otherData)
	self:setAwardOffsetY(50)
	self.desBgColor = "#FFEBB9"
	self.scheduBgColor = "#FFEBB9"
	self.scheduValeColor = "#6CDE00"
	self.desColor = "#FFBF00"
	local awardNum = table.nums(data.award)
	dump(data.award, "data.award")
	if 0 < awardNum then
		self.itemSepX = 440 / awardNum
		self.itemScale = self.itemSepX / 80
	end
	self:initData_imp(data, otherData)
	if not (self.taskStatus ~= gBtnTargetStatusDef.GO or eventQuestRead.isNeedShowGo(data.taskID)) or self.taskStatus == gBtnTargetStatusDef.GOT then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	self.finishNode:setVisible(self.taskStatus == gBtnTargetStatusDef.GOT)
	_ENV = self.finishNode.setVisible
	self.finishNode.setVisible.color = self.desColor
	local _ENV, self.finishNode.setVisible.i, tmp = self.desColor, "true", self.finishNode.setVisible
	self.desColor.var = tmp
	self.desColor.power = tmp
	self.desColor.num = tmp
	_ENV, self.desColor.lv = self.taskStatus == gBtnTargetStatusDef.GOT, tmp
	self.desColor.__default, (self.taskStatus == gBtnTargetStatusDef.GOT).color = self.taskStatus == gBtnTargetStatusDef.GOT, self.desBgColor
	local styles = self.desColor
	self.Text_des:setString(eventQuestRead.getDesNew(data.taskID, styles))
end
function newDayTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.view)
	activityTaskComponentCtrl:reqRuestClaimReward(taskID, self.activityID)
end
function newDayTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if guideId then
		tbParam.msg = i18n(taskDes)
		tbParam.minLv = taskDes.lv
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(tbParam.id, tbParam)
		print("ret,notNeedClose", ret, notNeedClose, tbParam.id, taskDes)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return newDayTaskSingle

local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local eventQuestRead = include("eventQuestRead")
local sultansBackTaskSingle = class("sultansBackTaskSingle", function(target)
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function sultansBackTaskSingle:ctor()
	self.finishNode = SoraDGetChildByName(self, "Node_Finish")
	SoraDGetChildByName(self.finishNode, "Text_Finish"):setString(i18n("common_text_2601"))
end
function sultansBackTaskSingle:initData(data, otherData)
	self:setAwardOffsetY(50)
	self.desBgColor = "#D7C39B"
	self.scheduBgColor = "#D7C39B"
	self.scheduValeColor = "#6CDE00"
	self.desColor = "#FFBF00"
	self:initData_imp(data, otherData)
	if not (self.taskStatus ~= gBtnTargetStatusDef.GO or eventQuestRead.isNeedShowGo(data.taskID)) or self.taskStatus == gBtnTargetStatusDef.GOT then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	self.finishNode:setVisible(self.taskStatus == gBtnTargetStatusDef.GOT)
end
function sultansBackTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.view)
	_ENV = nil
	;(nil).questId = taskID
	sultansBackCtrl:reqBackKingTaskReceive(nil)
end
function sultansBackTaskSingle:skipTo(taskDes)
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
return sultansBackTaskSingle

local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local MAX_AWARD_NUM = 4
local sultansBackWarTaskSingle = class("sultansBackWarTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anniversaryFlameTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function sultansBackWarTaskSingle:initData(data, otherData)
	dump(data, "sultansBackWarTaskSingle:initData", 10)
	self:setAwardOffsetY(50)
	self:setRewardOffsetX(50)
	self:setItemWidth(538)
	self:setItemSepX(70)
	self:setItemScale(0.9)
	self.desBgColor = "#A99581"
	self.scheduBgColor = "#A9997E"
	self.desColor = "#FFBF00"
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not sultansBackRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	print(self.Button_go:isVisible())
end
function sultansBackWarTaskSingle:doAction()
	SoraDShowLoading(self.view)
	_ENV = nil
	;(nil).questID = self.data.taskID
	sultansBackCtrl:reqBackWarTaskReceive(nil)
end
function sultansBackWarTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return sultansBackWarTaskSingle

local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local eventQuestRead = include("eventQuestRead")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local shiningStarLightTaskSingle = class("shiningStarLightTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsMainTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function shiningStarLightTaskSingle:ctor()
end
function shiningStarLightTaskSingle:initData(data, otherData)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
end
function shiningStarLightTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.view)
	_ENV = nil
	;(nil).questID = taskID
	shiningStarLightCtrl:reqGloriousStarLampClaimQuestReward(nil)
end
function shiningStarLightTaskSingle:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if not worldMapDefine.isInRadiance() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	dump(self.data, "self.data", 10)
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
return shiningStarLightTaskSingle

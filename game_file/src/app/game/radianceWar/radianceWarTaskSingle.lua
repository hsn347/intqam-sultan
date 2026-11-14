local eventQuestRead = include("eventQuestRead")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarTaskSingle = class("radianceWarTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsMainTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function radianceWarTaskSingle:ctor()
end
function radianceWarTaskSingle:initData(data, otherData)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
		if self.taskStatus == gBtnTargetStatusDef.GO and self.data.taskID == 4206345 then
			local radianceWarUtil = include("radianceWarUtil")
			if not radianceWarUtil.checkCanOccupyAmberMine() then
				self.Button_go:setBright(false)
			end
		end
	end
end
function radianceWarTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.view)
	_ENV = nil
	;(nil).questID = taskID
	radianceActivityCtrl:reqGetReward(nil)
end
function radianceWarTaskSingle:skipTo(taskDes)
	if self.data.taskID == 4206345 then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.checkCanOccupyAmberMine() then
			SoraDShowMsgTip(i18n("brightWar_text_170"))
			return
		end
	end
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if not worldMapDefine.isInRadiance() and tbParam.id ~= gNewPLayerTaskType.RADIANCE_TREAT then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	if guideId then
		tbParam.msg = i18n(taskDes)
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(tbParam.id, tbParam)
		print("ret,notNeedClose", ret, notNeedClose, tbParam.id, taskDes)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return radianceWarTaskSingle

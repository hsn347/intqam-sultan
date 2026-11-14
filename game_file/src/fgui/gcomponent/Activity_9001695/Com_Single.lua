local eventQuestRead = include("eventQuestRead")
local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001695/Com_Single", Com_Single)
function Com_Single:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001695
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_btn:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_btn:setVisible(false)
	self:fixChildrenPos()
end
function Com_Single:onShow()
end
function Com_Single:initData(data)
	self.questID = data.questID
	self.status = data.status
	self.itemList = eventQuestRead.getReward(self.questID)
	self.fields.List_award:setNumItems(#self.itemList)
	self.fields.List_award:setScrollEnable(#self.itemList > 5)
	self.cfg = eventQuestRead.getTaskConfig(self.questID)
	eventQuestRead = nil
	;(nil).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(self.cfg.taskDes.num))
	self.fields.Text_dsc:setString(i18n(self.cfg.taskDes[1], nil))
	local cur = ""
	local progress = taskRushActivityCtrl:getQuestProgress(self.questID, self.activityID)
	if progress >= self.cfg.aim then
		progress = self.cfg.aim
		cur = fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(progress))
	else
		cur = fguiHelper.getColorString("#FF0000", string.formatnumberthousands(progress))
	end
	eventQuestRead = string.formatnumberthousands(progress)
	string.formatnumberthousands(progress).var = cur
	string.formatnumberthousands(progress).var1 = string.formatnumberthousands(self.cfg.aim)
	self.fields.Text_rem:setString(i18n("alliance_stronghold_text_070", string.formatnumberthousands(progress)))
	if self.status == gBtnTargetStatusDef.GET then
		self.fields.Button_btn:setBtnColorIndex(0)
		self.fields.Button_btn:setTitle(i18n("common_text_1146"))
		self.fields.Button_btn:setEnabled(true)
		self.fields.Button_btn:setGrayed(self:isTaskPassed())
		self.fields.Button_btn:setVisible(not self:isTaskPassed())
	elseif self.status == gBtnTargetStatusDef.GO then
		self.fields.Button_btn:setBtnColorIndex(2)
		self.fields.Button_btn:setTitle(i18n("common_text_477"))
		self.fields.Button_btn:setEnabled(true)
		self.fields.Button_btn:setGrayed(self:isTaskPassed())
		self.fields.Button_btn:setVisible(self.cfg.guideId and 0 < #self.cfg.guideId and not self:isTaskPassed())
	elseif self.status == gBtnTargetStatusDef.GOT then
		self.fields.Button_btn:setTitle(i18n("common_text_1892"))
		self.fields.Button_btn:setEnabled(false)
		self.fields.Button_btn:setVisible(true)
	end
end
function Com_Single:isTaskPassed()
	return taskRushActivityCtrl:isBoxCanGet(self.activityID) or taskRushActivityCtrl:isBoxGot(self.activityID)
end
function Com_Single:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function Com_Single:onClickGo()
	SoraDPlaySound()
	if self:isTaskPassed() then
		SoraDShowMsgTip(i18n("tips_task_timeout"))
		return
	end
	if self.status == gBtnTargetStatusDef.GET then
		taskRushActivityCtrl:reqClaimReward(self.questID, self.activityID)
	elseif self.status == gBtnTargetStatusDef.GO then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(self.cfg.guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.cfg.taskDes))
		end
		if self.cfg.guideId then
			local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.cfg.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_Single

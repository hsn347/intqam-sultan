local activity_9001684_Ctrl = SoraDGetCtrl("activity_9001684_Ctrl")
local activity_9001684_Read = include("activity_9001684_Read")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_taskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001684/Com_taskSingle", Com_taskSingle)
function Com_taskSingle:onInit()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function Com_taskSingle:onShow()
end
function Com_taskSingle:initData(cfg, isInfinity)
	self.cfg = cfg
	self.isInfinity = isInfinity
	self.fields.Com_item:initData(cfg.rewards[1].id, cfg.rewards[1].count)
	if cfg.taskId then
		self.fields.Text_des:setString(eventQuestRead.getDesNew(cfg.taskId))
	else
		eventQuestRead = eventQuestRead.getDesNew(cfg.taskId)
		eventQuestRead.getDesNew(cfg.taskId).num = string.formatnumberthousands(cfg.taskNum)
		self.fields.Text_des:setString(i18n(cfg.des, eventQuestRead.getDesNew(cfg.taskId)))
	end
	local aim = cfg.taskId and eventQuestRead.getAim(cfg.taskId) or cfg.taskNum
	self.fields.Bar:setMax(aim)
	local progress = activity_9001684_Ctrl:getTaskProgress(isInfinity and cfg.taskType or cfg.taskId, isInfinity)
	if isInfinity then
		self.fields.Bar:setValue(progress)
	else
		self.fields.Bar:setValue(math.min(aim, progress))
	end
	self.status = cfg.status
	local titleStr = i18n("common_text_477")
	local colorIndex = gBtnColorDef.BLUE
	if self.status == gBtnTargetStatusDef.GET then
		titleStr = i18n("common_text_677")
		colorIndex = gBtnColorDef.GREEN
	elseif self.status == gBtnTargetStatusDef.GOT then
		titleStr = i18n("common_text_1892")
		colorIndex = gBtnColorDef.GREEN
	end
	self.fields.Button_go:setString(titleStr)
	self.fields.Button_go:setBtnColorIndex(colorIndex)
	self.fields.Button_go:setEnabled(self.status ~= gBtnTargetStatusDef.GOT)
end
function Com_taskSingle:btnGoClick()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		if self.isInfinity then
			activity_9001684_Ctrl:reqTaskReward(self.cfg.taskType)
		else
			activity_9001684_Ctrl:reqQuestReward(self.cfg.taskId)
		end
	elseif self.status == gBtnTargetStatusDef.GO then
		local guideId = self.isInfinity and self.cfg.guideId or eventQuestRead.getGuideId(self.cfg.taskId)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_taskSingle

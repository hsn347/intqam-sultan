local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001717_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001717/Com_9001717_task", Com_9001717_task)
function Com_9001717_task:onInit()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.itemRenderer_Award_Scroll))
	self.fields.Button_Task:setTitle(i18n("common_text_477"))
	self.fields.Button_Task:addClickListener(handler(self, self.onClick_Button_Task))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_9001717_task:onShow()
end
function Com_9001717_task:initData(activityID, data)
	self.activityID = activityID
	self.isUnlockAdvance = activity_9001717_Ctrl:getIsAdvanceRewardUnlock()
	self:initDataTaskID(data)
end
function Com_9001717_task:initDataTaskID(params)
	local activityID = params.activityID
	local taskID = params.taskID
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	self.isContinue = false
	local taskStatus = taskComponent:getTaskState(taskID)
	self.taskStatus = taskStatus
	print("taskStatus===", taskID, taskStatus, activity_9001717_Ctrl:isGotTaskPayReward(taskID))
	if taskStatus == gBtnTargetStatusDef.GOT and not activity_9001717_Ctrl:isGotTaskPayReward(taskID) then
		self.taskStatus = gBtnTargetStatusDef.GET
		self.isContinue = true
	end
	self:setBtnStatus()
	if self.isContinue then
		self.taskStatus = gBtnTargetStatusDef.GET
		self.fields.Button_Task:setTitle(i18n("cityUp_btn_01"))
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(self.taskStatus == gBtnTargetStatusDef.GOT and 1 or 0)
	end
	self.fields.icon_double:setVisible(self.isUnlockAdvance)
	activityTaskComponentCtrl = self.fields.icon_double.setVisible
	self.fields.icon_double.setVisible.taskID = taskID
	self.fields.icon_double.setVisible.progress = taskComponent:getTaskProgress(taskID)
	self.fields.icon_double.setVisible.taskStatus = self.taskStatus
	self.fields.icon_double.setVisible.taskDes = eventQuestRead.getDes(taskID)
	self.fields.icon_double.setVisible.award = eventQuestRead.getReward(taskID)
	self.fields.icon_double.setVisible.aim = eventQuestRead.getAim(taskID)
	self.fields.icon_double.setVisible.guideId = eventQuestRead.getGuideId(taskID)
	self.fields.icon_double.setVisible.isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	self.data, self.fields.icon_double.setVisible.activityID = self.fields.icon_double.setVisible, activityID
	local str = clone(self.data.taskDes)
	for i, v in pairs(str) do
		if tolua.type(i) == "string" then
			activityTaskComponentCtrl = i18n("cityUp_btn_01")
			i18n("cityUp_btn_01").color = "#E2AF27"
			i18n("cityUp_btn_01").i = "true"
			str[i] = SoraDWrapHtmlTagByStyle(v, i18n("cityUp_btn_01"))
		end
	end
	activityTaskComponentCtrl = str
	str.color = "#FFEBB9"
	self.fields.Task_Des:setString(SoraDWrapHtmlTagByStyle(i18n(str), str))
	local count = self.data.progress or self.data.count
	local total = self.data.aim or self.data.total
	count = math.min(count, total)
	activityTaskComponentCtrl = count
	count.color = total > count and "#E02B2B" or "#D7C39B"
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(count), count)
	activityTaskComponentCtrl = "/%s"
	;("/%s").color = "#D7C39B"
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("/%s", string.formatnumberthousands(total)), "/%s")
	local value = string.format("%s%s", countStr, totalStr)
	activityTaskComponentCtrl = string.formatnumberthousands(total)
	activityTaskComponentCtrl, activityTaskComponentCtrl, string.formatnumberthousands(total).value = string.formatnumberthousands(total)
	string.formatnumberthousands(total).__default, string.formatnumberthousands(total).color = string.formatnumberthousands(total)
	self.fields.Task_Scedule:setString(_G.i18n_html("complete_text_05", string.formatnumberthousands(total)))
	self.fields.Award_Scroll:setNumItems(#self.data.award)
	if IsArClient and 0 < #self.data.award then
		self.fields.Award_Scroll:scrollToView(0)
	end
end
function Com_9001717_task:setBtnStatus()
	self.fields.Button_Task:setBtnColorIndex(self.taskStatus == gBtnTargetStatusDef.GO and gBtnColorDef.YELLOW or gBtnColorDef.GREEN)
	if self.taskStatus ~= gBtnTargetStatusDef.NONE and self.taskStatus ~= gBtnTargetStatusDef.GOT then
		self.fields.Button_Task:setTitle(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or i18n("common_text_1146"))
	end
end
function Com_9001717_task:setHandler(callbackHandler)
	self.callbackHandler = callbackHandler
end
function Com_9001717_task:itemRenderer_Award_Scroll(index, obj)
	local item = self.data.award[index + 1]
	obj:initData(item.id, item.count)
	if item.lock then
		obj:setItemStatus(item.lock)
	end
	obj:showCoolSquare(item.heightLight or false)
end
function Com_9001717_task:onClick_Button_Task(context)
	SoraDPlaySound()
	if self.isContinue and not self.isUnlockAdvance then
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).rewardType = 2
		uiManager:show("Activity_9001637_BuyGift", nil)
		return
	end
	if self.taskStatus == gBtnTargetStatusDef.GET then
		if self.callbackHandler then
			self.callbackHandler(self.data.taskID)
		else
			activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, self.data.activityID)
		end
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(self.data.guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.data.taskDes))
		end
		if self.data.guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_9001717_task

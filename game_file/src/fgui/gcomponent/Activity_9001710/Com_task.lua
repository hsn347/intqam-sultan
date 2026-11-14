local eventQuestRead = include("eventQuestRead")
local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001710/Com_task", Com_task)
function Com_task:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_Task:setString(i18n("common_text_477"))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self:fixChildrenPos()
end
function Com_task:onItemRender(index, obj)
	obj:initData(self.taskReward[index + 1].id, self.taskReward[index + 1].count)
	obj:setStatus(activity_9001710_Ctrl:isTaskClaimed(self.taskID) and 3 or 2)
end
function Com_task:onShow()
end
function Com_task:initData(taskID)
	eventQuestRead, eventQuestRead, self.taskID = nil, nil, taskID
	;(nil).color = "#ffff00"
	eventQuestRead, (nil).num, (nil).i = nil, nil, "true"
	;(nil).__default, (nil).color = nil, "#d7c39b"
	local styles
	self.fields.Task_Des:setString(eventQuestRead.getDesEx(self.taskID, styles))
	self.taskReward = eventQuestRead.getReward(self.taskID)
	self.fields.List_reward:setNumItems(#self.taskReward)
	self.fields.List_reward:setScrollEnable(#self.taskReward > 5)
	local aim = eventQuestRead.getAim(self.taskID)
	local progress = math.min(aim, activity_9001710_Ctrl:getTaskProgress(self.taskID))
	eventQuestRead = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	activity_9001710_Ctrl:getTaskProgress(self.taskID).count = progress
	eventQuestRead, activity_9001710_Ctrl:getTaskProgress(self.taskID).total = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	if aim <= progress then
		eventQuestRead = activity_9001710_Ctrl:getTaskProgress(self.taskID)
		activity_9001710_Ctrl:getTaskProgress(self.taskID).color = "#d7c39b"
		if activity_9001710_Ctrl:getTaskProgress(self.taskID) then
			goto lbl_66
		end
	end
	eventQuestRead = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	eventQuestRead, activity_9001710_Ctrl:getTaskProgress(self.taskID).count, activity_9001710_Ctrl:getTaskProgress(self.taskID).color = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	::lbl_66::
	eventQuestRead, activity_9001710_Ctrl:getTaskProgress(self.taskID).total, activity_9001710_Ctrl:getTaskProgress(self.taskID).color = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	activity_9001710_Ctrl:getTaskProgress(self.taskID).__default, activity_9001710_Ctrl:getTaskProgress(self.taskID).color = activity_9001710_Ctrl:getTaskProgress(self.taskID)
	self.fields.Task_Scedule:setString(i18n_html("common_text_3683", activity_9001710_Ctrl:getTaskProgress(self.taskID)))
	self.status = activity_9001710_Ctrl:getTaskState(self.taskID)
	self.fields.Button_Task:setVisible(true)
	if self.status == gBtnTargetStatusDef.GOT then
		self.fields.Button_Task:setString(i18n("common_text_2601"))
		self.fields.Button_Task:setEnabled(false)
	elseif self.status == gBtnTargetStatusDef.GET then
		self.fields.Button_Task:setString(i18n("common_text_677"))
		self.fields.Button_Task:setBtnColorIndex(gBtnColorDef.GREEN)
		self.fields.Button_Task:setEnabled(true)
	else
		self.fields.Button_Task:setString(i18n("common_text_477"))
		self.fields.Button_Task:setBtnColorIndex(gBtnColorDef.YELLOW)
		self.fields.Button_Task:setEnabled(true)
		local guideId = string.trim(eventQuestRead.getGuideId(self.taskID))
		self.fields.Button_Task:setVisible(string.len(guideId) > 0)
	end
end
function Com_task:onClickTask()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		activity_9001710_Ctrl:reqQuestReward(self.taskID)
	else
		local guideId = string.trim(eventQuestRead.getGuideId(self.taskID))
		if guideId and string.len(guideId) > 0 then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_task

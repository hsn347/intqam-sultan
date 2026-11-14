local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001643/Com_task", Com_task)
function Com_task:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Text_lock:setString(i18n("common_text_2274"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Bar_time:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Btn_share:fixPos()
end
function Com_task:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_task:onShow()
end
function Com_task:initData(taskID, index, chapter)
	self.taskID = taskID
	self.chapter = chapter
	local taskCfg = activity_9001643_Read.getTaskCfg(self.taskID)
	self.times = taskCfg.times
	activity_9001643_Ctrl = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(taskCfg.reward, nil)
	self.fields.List_reward:setNumItems(#self.reward)
	self.fields.Btn_reward:setEnabled(true)
	self.fields.Btn_reward:getChildByName("Label_reddot"):initData(true)
	local isUnLock = activity_9001643_Ctrl:isTaskUnlock(self.chapter, self.taskID)
	if isUnLock then
		self.status = activity_9001643_Ctrl:getTaskStatus(self.taskID)
		self.fields.Btn_reward:getController("c1"):setSelectedIndex(self.status - 1)
		if self.status == activity_9001643_Read.TASK_STATUS_ENUM.ACCPET then
			self.controllers.c1:setSelectedIndex(2)
			self.fields.Btn_reward:setString(i18n("common_text_477"))
			local leftTime = activity_9001643_Ctrl:getTaskLeftTime(self.taskID)
			if 0 < leftTime then
				self.fields.Bar_time:setMax(self.times)
				self.fields.Text_time:beginTime(leftTime)
			end
		else
			self.controllers.c1:setSelectedIndex(1)
			if self.status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
				self.fields.Btn_reward:setString(i18n("common_text_477"))
			elseif self.status == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE then
				self.fields.Btn_reward:setString(i18n("common_text_1146"))
			elseif self.status == activity_9001643_Read.TASK_STATUS_ENUM.FINISH then
				self.fields.Btn_reward:setString(i18n("common_text_1892"))
				self.fields.Btn_reward:setEnabled(false)
			end
		end
		activity_9001643_Read = i18n("common_text_1892")
		i18n("common_text_1892").num = index
		self.fields.Lab_taskName:setString(i18n("eidal_celebration_text3", i18n("common_text_1892")))
		self.fields.Text_tip:setString(i18n(taskCfg.task_name))
		self.fields.Text_des:setString(i18n(taskCfg.task_des))
	else
		self.controllers.c1:setSelectedIndex(0)
		local cfg = activity_9001643_Read.getChapterCfgById(self.chapter)
		activity_9001643_Read = i18n(taskCfg.task_des)
		i18n(taskCfg.task_des).chapter = i18n(cfg.chapter_name)
		i18n(taskCfg.task_des).num = index - 1
		self.fields.Text_info:setString(i18n("eidal_celebration_text6", i18n(taskCfg.task_des)))
		self.fields.Text_tip:setString(i18n("eidal_celebration_text9"))
	end
end
function Com_task:timeUpdate(time)
	self.fields.Bar_time:setValue(self.times - time)
end
function Com_task:btnShareClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).taskID = self.taskID
	uiManager:show("Activity_9001643_SharePop", nil)
end
function Com_task:btnClick()
	SoraDPlaySound()
	if self.status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
		if activity_9001643_Ctrl:isTaskInited(self.taskID) then
			local pos = activity_9001643_Ctrl:getMapObjPos()
			SoraDGotoWorldMapPoint(pos, true)
			SoraDRemoveAllPanelFromManager()
		else
			activity_9001643_Ctrl:reqInitTask(self.taskID)
		end
	elseif self.status == activity_9001643_Read.TASK_STATUS_ENUM.ACCPET then
		local pos = activity_9001643_Ctrl:getMapObjPos()
		SoraDGotoWorldMapPoint(pos, true)
		SoraDRemoveAllPanelFromManager()
	elseif self.status == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE then
		activity_9001643_Ctrl:reqClaimReward(self.taskID)
	end
end
return Com_task

local activity_9001643_Read = include("activity_9001643_Read")
local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001643_DispatchPanel = class("Activity_9001643_DispatchPanel", baseFguiPanel)
function Activity_9001643_DispatchPanel:ctor(...)
	Activity_9001643_DispatchPanel.super.ctor(self, ...)
	print("Activity_9001643_DispatchPanel:ctor", self.viewName)
end
function Activity_9001643_DispatchPanel:onInit()
	print("=======Activity_9001643_DispatchPanel:onInit")
	self.reward, _ENV = print, print
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_dispatch:setString(i18n("hero_appoint_20"))
	self.fields.Btn_dispatch:addClickListener(handler(self, self.btnClick))
end
function Activity_9001643_DispatchPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001643_DispatchPanel:onShow()
	print("=======Activity_9001643_DispatchPanel:onShow")
end
function Activity_9001643_DispatchPanel:updateView(target, data)
	self:initData(self.data)
end
function Activity_9001643_DispatchPanel:initData(data)
	self.data = data
	self.taskID = self.data.taskID
	local taskCfg = activity_9001643_Read.getTaskCfg(self.taskID)
	self.fields.Icon_event:setSpriteFrame(taskCfg.eventbg)
	self.fields.Text_taskName:setString(i18n(taskCfg.task_name))
	activity_9001643_Ctrl = i18n(taskCfg.task_name)
	i18n(taskCfg.task_name)[1] = "id"
	i18n(taskCfg.task_name)[2] = "count"
	self.reward = serviceFunctions.tableFormat(taskCfg.reward, i18n(taskCfg.task_name))
	self.fields.List_reward:setNumItems(#self.reward)
	self.status = activity_9001643_Ctrl:getTaskStatus(self.taskID)
	if self.status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
		self.fields.Btn_dispatch:setString(i18n("hero_appoint_20"))
		self.fields.Label_time:endTime()
		activity_9001643_Read = i18n("hero_appoint_20")
		i18n("hero_appoint_20").time = SoraDConvertSecondToString(taskCfg.times)
		self.fields.Label_time:setTitle(i18n("lost_ruins_text_15", i18n("hero_appoint_20")))
	elseif self.status == activity_9001643_Read.TASK_STATUS_ENUM.ACCPET then
		self.fields.Btn_dispatch:setString(i18n("activity_text_05"))
		local leftTime = activity_9001643_Ctrl:getTaskLeftTime(self.taskID)
		if 0 < leftTime then
			self.fields.Label_time:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("lost_ruins_text_15", nil)
			end)
			self.fields.Label_time:beginTime(leftTime)
		end
	else
		self:close()
	end
end
function Activity_9001643_DispatchPanel:btnClick()
	SoraDPlaySound()
	if self.status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
		_ENV = nil
		;(nil).taskID = self.taskID
		uiManager:show("Activty_9001643_SelectPop", nil)
	end
end
return Activity_9001643_DispatchPanel

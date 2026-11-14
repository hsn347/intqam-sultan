local baseComponent = require("fgui.base.baseComponent")
local Com_9001604_task = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
fgui.register_extension("ui://Activity_9001604/Com_9001604_task", Com_9001604_task)
local TASK_STATE = activity_9001604_Ctrl.RAMADAN_MOBILIZE_TASK_STATE
function Com_9001604_task:onInit()
	self.fields.txt_status:setString(i18n("common_text_3564"))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001604_UPDATE"
		SoraDSendMessage(nil)
	end)
	self.fields.panel_touch:addEventListener(fgui.UIEventType.Click, handler(self, self.onTaskClick))
	self.fields.btn_commit:setTitle(i18n("common_text_3628"))
	self.fields.btn_commit:addClickEventListener(handler(self, self.onCommit))
	self.fields.btn_abort:addClickEventListener(handler(self, self.onAbort))
	self.fields.btn_refresh:addClickEventListener(handler(self, self.onRefresh))
	self:fixChildrenPos()
end
function Com_9001604_task:onShow()
end
function Com_9001604_task:initData(data)
	self.data = data
	self.fields.txt_name:setString(i18n(data.isMy and "common_text_3563" or data.taskName))
	if data.isEmpty then
		self.fields.icon:setVisible(false)
		self.fields.txt_empty:setVisible(true)
		self.fields.txt_empty:setString(i18n("Ramadan_League_text_08"))
		self.controllers.c1:setSelectedIndex(2)
		return
	end
	self.fields.icon:setVisible(true)
	self.fields.txt_empty:setVisible(false)
	self.fields.icon:setURL(data.taskIcon)
	local lastTime = 0
	if data.state == TASK_STATE.REFRESH or data.state == TASK_STATE.ACCEPT and not data.isMy then
		self.controllers.c1:setSelectedIndex(1)
		lastTime = data.time - serviceFunctions.systemTime()
	else
		self.fields.txt_score:setString("+" .. data.taskScore)
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.btn_refresh:setVisible(not data.isMy and data.isRankR4)
	self.fields.btn_commit:setVisible(false)
	self.fields.btn_abort:setVisible(false)
	if data.isMy then
		lastTime = data.time - serviceFunctions.systemTime()
		dump(lastTime, "Com_9001604_task:initData")
		self.lastTime = lastTime
		if lastTime <= 0 then
			self.fields.txt_empty:setVisible(true)
			self.fields.txt_empty:setString(i18n("tips_task_timeout"))
			self.fields.btn_abort:setVisible(true)
		else
			local isFinish = activity_9001604_Ctrl:isTaskFinished(data.taskID)
			if isFinish then
				self.fields.btn_commit:setVisible(true)
			else
				self.fields.btn_abort:setVisible(true)
			end
		end
	end
	self.fields.txt_status:setVisible(not self.fields.btn_commit:isVisible())
	if 0 < lastTime then
		self.txt_time:setVisible(not self.fields.btn_commit:isVisible())
		self.txt_time:beginTime(lastTime)
	else
		self.txt_time:setVisible(false)
	end
end
function Com_9001604_task:onTaskClick()
	SoraDPlaySound()
	if self.data.isEmpty or self.data.state == TASK_STATE.REFRESH or self.data.state == TASK_STATE.ACCEPT and not self.data.isMy then
		return
	end
	if self.data.isMy and self.lastTime ~= nil and self.lastTime <= 0 then
		return
	end
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("Activity_9001604_Task", nil)
end
function Com_9001604_task:onAbort()
	SoraDPlaySound()
	SoraDShowMsgBoxNew(i18n("Ramadan_League_text_09"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
		if exitType ~= MSGBOX_CALLBACK_YES then
			return
		end
		activity_9001604_Ctrl:reqAbort(self.data.taskIdx)
	end)
end
function Com_9001604_task:onRefresh()
	SoraDPlaySound()
	SoraDShowMsgBoxNew(i18n("Ramadan_League_text_10"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
		if exitType ~= MSGBOX_CALLBACK_YES then
			return
		end
		activity_9001604_Ctrl:reqRefresh(self.data.taskIdx)
	end)
end
function Com_9001604_task:onCommit()
	SoraDPlaySound()
	activity_9001604_Ctrl:reqCommit()
end
return Com_9001604_task

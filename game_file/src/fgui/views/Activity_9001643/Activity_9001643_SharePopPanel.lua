local chatCtrl = SoraDGetCtrl("chatCtrl")
local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001643_SharePopPanel = class("Activity_9001643_SharePopPanel", baseFguiPanel)
function Activity_9001643_SharePopPanel:ctor(...)
	Activity_9001643_SharePopPanel.super.ctor(self, ...)
	print("Activity_9001643_SharePopPanel:ctor", self.viewName)
end
function Activity_9001643_SharePopPanel:onInit()
	print("=======Activity_9001643_SharePopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.fields.Text_tip:setString(i18n("eidal_celebration_text11"))
	self.fields.Btn_share:setString(i18n("common_text_533"))
	self.fields.Btn_share:addClickListener(handler(self, self.btnShareClick))
end
function Activity_9001643_SharePopPanel:onShow()
	print("=======Activity_9001643_SharePopPanel:onShow")
	self.taskID = self.param.taskID
	local cfg = activity_9001643_Read.getTaskCfg(self.taskID)
	_ENV = nil
	;(nil).taskname = i18n(cfg.task_name)
	self.fields.Text_msg:setString(i18n("eidal_celebration_text10", nil))
end
function Activity_9001643_SharePopPanel:btnShareClick()
	SoraDPlaySound()
	local cdTime = activity_9001643_Ctrl:getShareCDTime()
	if 0 < cdTime then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0112"))
	else
		activity_9001643_Ctrl:setShareTime()
		_ENV = i18n("exitic_pavillion_text_0112")
		i18n("exitic_pavillion_text_0112").taskID = self.taskID
		chatCtrl:share(gChatChannel.ALLIANCE, gChatShareType.EID_CELEBRATION_ACTIVITY, i18n("exitic_pavillion_text_0112"))
		self:close()
	end
end
return Activity_9001643_SharePopPanel

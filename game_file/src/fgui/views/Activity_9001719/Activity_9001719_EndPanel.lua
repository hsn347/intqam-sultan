local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_EndPanel = class("Activity_9001719_EndPanel", baseFguiPanel)
function Activity_9001719_EndPanel:ctor(...)
	self.isLRU = true
	Activity_9001719_EndPanel.super.ctor(self, ...)
	print("Activity_9001719_EndPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001719_EndPanel:onInit()
	print("=======Activity_9001719_EndPanel:onInit")
	self.fields.Panel_bg:setString(i18n("surprise_box_035"))
	self.fields.Button_ok:setString(i18n("balloon_hunter_024"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
end
function Activity_9001719_EndPanel:endShow()
	print("=======Activity_9001719_EndPanel:endShow")
	self.score = self.param.score or 0
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", self.score)
	self.fields.Text_score:setString(i18n("alliance_hunt_text_35", nil))
end
function Activity_9001719_EndPanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001719_ENDGAME"
	SoraDSendMessage(nil)
	self:close()
end
return Activity_9001719_EndPanel

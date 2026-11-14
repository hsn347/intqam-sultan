local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_PausePanel = class("Activity_9001719_PausePanel", baseFguiPanel)
function Activity_9001719_PausePanel:ctor(...)
	self.isLRU = true
	Activity_9001719_PausePanel.super.ctor(self, ...)
	print("Activity_9001719_PausePanel:ctor", self.viewName)
end
function Activity_9001719_PausePanel:onInit()
	print("=======Activity_9001719_PausePanel:onInit")
	self.fields.Panel_bg:setString(i18n("balloon_hunter_022"))
	self.fields.Text_tip:setString(i18n("balloon_hunter_023"))
	self.fields.Button_continue:setString(i18n("common_text_3425"))
	self.fields.Button_continue:addClickListener(handler(self, self.btnContinueClick))
	self.fields.Button_quit:setString(i18n("balloon_hunter_024"))
	self.fields.Button_quit:addClickListener(handler(self, self.btnQuitClick))
	self.fields.Button_continue:fixPos()
	self.fields.Button_quit:fixPos()
end
function Activity_9001719_PausePanel:endShow()
	print("=======Activity_9001719_PausePanel:endShow")
	self.callback = self.param.callback
	self.secs = self.param.secs or 0
	self.score = self.param.score or 0
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", self.score)
	self.fields.Text_score:setString(i18n("balloon_hunter_017", nil))
end
function Activity_9001719_PausePanel:btnContinueClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(false)
	end
	self:close()
end
function Activity_9001719_PausePanel:btnQuitClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(true)
	end
	self:close()
end
function Activity_9001719_PausePanel:onHide()
	if self.callback then
		self.callback(false)
	end
end
return Activity_9001719_PausePanel

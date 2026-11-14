local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_PausePanel = class("Activity_9001703_PausePanel", baseFguiPanel)
function Activity_9001703_PausePanel:ctor(...)
	self.isLRU = true
	Activity_9001703_PausePanel.super.ctor(self, ...)
	print("Activity_9001703_PausePanel:ctor", self.viewName)
end
function Activity_9001703_PausePanel:onInit()
	print("=======Activity_9001703_PausePanel:onInit")
	self.fields.Panel_bg:setString(i18n("balloon_hunter_022"))
	self.fields.Text_tip:setString(i18n("balloon_hunter_023"))
	self.fields.Button_continue:setString(i18n("common_text_3425"))
	self.fields.Button_continue:addClickListener(handler(self, self.btnContinueClick))
	self.fields.Button_quit:setString(i18n("balloon_hunter_024"))
	self.fields.Button_quit:addClickListener(handler(self, self.btnQuitClick))
	self.fields.Button_continue:fixPos()
	self.fields.Button_quit:fixPos()
end
function Activity_9001703_PausePanel:endShow()
	print("=======Activity_9001703_PausePanel:endShow")
	self.callback = self.param.callback
	local score = activity_9001703_Ctrl:getScore()
	_ENV = nil
	;(nil).num = score
	self.fields.Text_score:setString(i18n("balloon_hunter_017", nil))
end
function Activity_9001703_PausePanel:btnContinueClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(false)
	end
	self:close()
end
function Activity_9001703_PausePanel:btnQuitClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(true)
	end
	activity_9001703_Ctrl:reqEndGame()
	self:close()
end
function Activity_9001703_PausePanel:onHide()
	if self.callback then
		self.callback(false)
	end
end
return Activity_9001703_PausePanel

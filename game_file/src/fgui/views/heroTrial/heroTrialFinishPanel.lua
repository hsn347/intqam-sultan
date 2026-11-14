local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialFinishPanel = class("heroTrialFinishPanel", baseFguiPanel)
function heroTrialFinishPanel:ctor(...)
	self.isLRU = true
	heroTrialFinishPanel.super.ctor(self, ...)
	print("heroTrialFinishPanel:ctor", self.viewName)
end
function heroTrialFinishPanel:onInit()
	print("=======heroTrialFinishPanel:onInit")
	self.fields.Button_ok:setString(i18n("common_text_054"))
	self.fields.Button_ok:addClickListener(handler(self, self.onConfirm))
end
function heroTrialFinishPanel:endShow()
	print("=======heroTrialFinishPanel:endShow")
	self.isWin = self.param and self.param.isWin or false
	self.cb = self.param and self.param.cb
	self.tips = self.param and self.param.tips
	self.fields.Text_tip:setString(self.tips or self.isWin and i18n("common_text_1748") or i18n("common_text_1718"))
	self.fields.bg:initData(self.isWin)
end
function heroTrialFinishPanel:onConfirm()
	SoraDPlaySound()
	if self.cb then
		self.cb()
	end
	self:close()
end
return heroTrialFinishPanel

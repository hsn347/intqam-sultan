local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSRUnlockPanel = class("MagicLampSRUnlockPanel", baseFguiPanel)
function MagicLampSRUnlockPanel:ctor(...)
	MagicLampSRUnlockPanel.super.ctor(self, ...)
	print("MagicLampSRUnlockPanel:ctor", self.viewName)
end
function MagicLampSRUnlockPanel:onInit()
	print("=======MagicLampSRUnlockPanel:onInit")
	self.fields.title:setString(i18n("jinn_gaglxy_text02"))
	self.fields.Text_tips:setString(i18n("jinn_gaglxy_text03"))
	self.fields.btn_go:setTitle(i18n("NewYear_Gift_02"))
	self.fields.btn_go:addClickEventListener(handler(self, self.onSureClick))
end
function MagicLampSRUnlockPanel:endShow()
	print("=======MagicLampSRUnlockPanel:endShow")
	self.closeCallback = self.param and self.param.closeCallback
end
function MagicLampSRUnlockPanel:onSureClick()
	SoraDPlaySound()
	if self.closeCallback then
		self.closeCallback()
	end
	self:close()
end
function MagicLampSRUnlockPanel:onHide()
	print("=======MagicLampSRUnlockPanel:onHide")
end
return MagicLampSRUnlockPanel

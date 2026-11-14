local baseFguiPanel = require("fgui.base.baseFguiPanel")
local marketNoAlliancePanel = class("marketNoAlliancePanel", baseFguiPanel)
function marketNoAlliancePanel:ctor(...)
	marketNoAlliancePanel.super.ctor(self, ...)
	print("marketNoAlliancePanel:ctor", self.viewName)
end
function marketNoAlliancePanel:onInit()
	print("=======marketNoAlliancePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_180"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("common_text_856"))
	self.fields.Button_join:setString(i18n("common_text_857"))
	self.fields.Button_join:addClickListener(handler(self, self.btnClick))
end
function marketNoAlliancePanel:onShow()
	print("=======marketNoAlliancePanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function marketNoAlliancePanel:btnClick()
	SoraDPlaySound()
	uiManager:show("AllianceJoinView")
end
return marketNoAlliancePanel

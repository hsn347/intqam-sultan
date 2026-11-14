local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceBlackWhiteHelpViewPanel = class("allianceBlackWhiteHelpViewPanel", baseFguiPanel)
function allianceBlackWhiteHelpViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceBlackWhiteHelpViewPanel:ctor", self.viewName)
end
function allianceBlackWhiteHelpViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceBlackWhiteHelpViewPanel:onInit()
	print("=======allianceBlackWhiteHelpViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_1678"))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.view:fixChildrenPos()
end
function allianceBlackWhiteHelpViewPanel:onShow()
	print("=======allianceBlackWhiteHelpViewPanel:onShow")
	self.fields.Text_black:setString(i18n("common_text_1679"))
	self.fields.Text_blackDes:setString(i18n("common_text_1685"))
	self.fields.Text_white:setString(i18n("common_text_1680"))
	self.fields.Text_whiteDes:setString(i18n("common_text_1686"))
end
function allianceBlackWhiteHelpViewPanel:btnOkClick()
	SoraDPlaySound()
	self:close()
end
return allianceBlackWhiteHelpViewPanel

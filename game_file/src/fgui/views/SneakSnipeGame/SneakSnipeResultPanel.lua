local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SneakSnipeResultPanel = class("SneakSnipeResultPanel", baseFguiPanel)
function SneakSnipeResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SneakSnipeResultPanel:ctor", self.viewName)
end
function SneakSnipeResultPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SneakSnipeResultPanel:onInit()
	print("=======SneakSnipeResultPanel:onInit")
	self.fields.button_1:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_1:setTitle(i18n("common_text_204"))
end
function SneakSnipeResultPanel:onShow()
	print("=======SneakSnipeResultPanel:onShow")
	self.isWin = self.proxy.param and self.proxy.param.isWin
	if self.isWin then
		self.fields.text:setString(i18n("snip_text_01"))
	else
		self.fields.text:setString(i18n("snip_text_02"))
	end
	self.controllers.c1:setSelectedIndex(self.isWin and 0 or 1)
end
function SneakSnipeResultPanel:closeSelf()
	SoraDPlaySound()
	self:close()
end
return SneakSnipeResultPanel

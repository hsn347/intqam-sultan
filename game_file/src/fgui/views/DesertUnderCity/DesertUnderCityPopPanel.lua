local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertUnderCityPopPanel = class("DesertUnderCityPopPanel", baseFguiPanel)
function DesertUnderCityPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertUnderCityPopPanel:ctor", self.viewName)
end
function DesertUnderCityPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertUnderCityPopPanel:onInit()
	print("=======DesertUnderCityPopPanel:onInit")
end
function DesertUnderCityPopPanel:onShow()
	print("=======DesertUnderCityPopPanel:onShow")
	self.fields.Text_Tips:setString(i18n("Promise_Summit_text_29"))
	self.fields.Text_content:setString(i18n("fire_sercet_14"))
	self.fields.Item_Icon:setURL(include("publicRead").getIcon(self.proxy.param.id))
end
return DesertUnderCityPopPanel

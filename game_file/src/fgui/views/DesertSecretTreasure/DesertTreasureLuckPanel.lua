local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertTreasureLuckPanel = class("DesertTreasureLuckPanel", baseFguiPanel)
function DesertTreasureLuckPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DesertTreasureLuckPanel:ctor", self.viewName)
end
function DesertTreasureLuckPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
	end
	return self._packageList
end
function DesertTreasureLuckPanel:onInit()
	print("=======DesertTreasureLuckPanel:onInit")
	self.fields.Text_content:setString(i18n("herovault_text_09"))
	self.fields.Panel_bg:setTitle(i18n("Mermaid_title_06"))
end
function DesertTreasureLuckPanel:onShow()
	print("=======DesertTreasureLuckPanel:onShow")
end
function DesertTreasureLuckPanel:onHide()
	print("=======DesertTreasureLuckPanel:onHide")
end
function DesertTreasureLuckPanel:onDispose()
	print("=======DesertTreasureLuckPanel:onDispose")
end
return DesertTreasureLuckPanel

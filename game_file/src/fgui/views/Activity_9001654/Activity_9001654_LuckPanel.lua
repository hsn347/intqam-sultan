local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001654_LuckPanel = class("Activity_9001654_LuckPanel", baseFguiPanel)
function Activity_9001654_LuckPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001654_LuckPanel:ctor", self.viewName)
end
function Activity_9001654_LuckPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertSecretTreasure"
	end
	return self._packageList
end
function Activity_9001654_LuckPanel:onInit()
	print("=======Activity_9001654_LuckPanel:onInit")
	self.fields.Text_content:setString(i18n("herovault_text_09"))
	self.fields.Panel_bg:setTitle(i18n("Mermaid_title_06"))
end
function Activity_9001654_LuckPanel:onShow()
	print("=======Activity_9001654_LuckPanel:onShow")
end
function Activity_9001654_LuckPanel:onHide()
	print("=======Activity_9001654_LuckPanel:onHide")
end
function Activity_9001654_LuckPanel:onDispose()
	print("=======Activity_9001654_LuckPanel:onDispose")
end
return Activity_9001654_LuckPanel

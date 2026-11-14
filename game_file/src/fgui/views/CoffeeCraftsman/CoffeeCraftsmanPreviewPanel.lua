local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CoffeeCraftsmanPreviewPanel = class("CoffeeCraftsmanPreviewPanel", baseFguiPanel)
function CoffeeCraftsmanPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function CoffeeCraftsmanPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function CoffeeCraftsmanPreviewPanel:onInit()
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
end
function CoffeeCraftsmanPreviewPanel:onShow()
end
return CoffeeCraftsmanPreviewPanel

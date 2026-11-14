local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertMasterPreviewPanel = class("DessertMasterPreviewPanel", baseFguiPanel)
function DessertMasterPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function DessertMasterPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DessertMaster"
	end
	return self._packageList
end
function DessertMasterPreviewPanel:onInit()
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
end
function DessertMasterPreviewPanel:onShow()
end
return DessertMasterPreviewPanel

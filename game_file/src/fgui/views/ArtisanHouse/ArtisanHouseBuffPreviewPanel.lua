local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtisanHouseBuffPreviewPanel = class("ArtisanHouseBuffPreviewPanel", baseFguiPanel)
function ArtisanHouseBuffPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ArtisanHouseBuffPreviewPanel:ctor", self.viewName)
end
function ArtisanHouseBuffPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ArtisanHouseBuffPreviewPanel:onInit()
	print("=======ArtisanHouseBuffPreviewPanel:onInit")
end
function ArtisanHouseBuffPreviewPanel:onShow()
	print("=======ArtisanHouseBuffPreviewPanel:onShow")
	self.fields.panel_normal:setTitle(self.proxy.param.title)
end
function ArtisanHouseBuffPreviewPanel:onHide()
	print("=======ArtisanHouseBuffPreviewPanel:onHide")
end
function ArtisanHouseBuffPreviewPanel:onDispose()
	print("=======ArtisanHouseBuffPreviewPanel:onDispose")
end
return ArtisanHouseBuffPreviewPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtisanHouseAwardPreviewPanel = class("ArtisanHouseAwardPreviewPanel", baseFguiPanel)
function ArtisanHouseAwardPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtisanHouseAwardPreviewPanel:ctor", self.viewName)
end
function ArtisanHouseAwardPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
	end
	return self._packageList
end
function ArtisanHouseAwardPreviewPanel:onInit()
	print("=======ArtisanHouseAwardPreviewPanel:onInit")
end
function ArtisanHouseAwardPreviewPanel:onShow()
	print("=======ArtisanHouseAwardPreviewPanel:onShow")
	self.fields.panel_normal:setTitle(self.proxy.param.title)
end
function ArtisanHouseAwardPreviewPanel:onHide()
	print("=======ArtisanHouseAwardPreviewPanel:onHide")
end
function ArtisanHouseAwardPreviewPanel:onDispose()
	print("=======ArtisanHouseAwardPreviewPanel:onDispose")
end
return ArtisanHouseAwardPreviewPanel

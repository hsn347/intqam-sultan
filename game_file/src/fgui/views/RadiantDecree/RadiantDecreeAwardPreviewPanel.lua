local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeAwardPreviewPanel = class("RadiantDecreeAwardPreviewPanel", baseFguiPanel)
function RadiantDecreeAwardPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeAwardPreviewPanel:ctor", self.viewName)
end
function RadiantDecreeAwardPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RadiantDecreeAwardPreviewPanel:onInit()
	print("=======RadiantDecreeAwardPreviewPanel:onInit")
end
function RadiantDecreeAwardPreviewPanel:onShow()
	print("=======RadiantDecreeAwardPreviewPanel:onShow")
	self.fields.panel_normal:setTitle(self.proxy.param.title)
end
return RadiantDecreeAwardPreviewPanel

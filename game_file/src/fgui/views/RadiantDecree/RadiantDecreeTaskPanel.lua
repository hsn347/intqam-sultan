local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeTaskPanel = class("RadiantDecreeTaskPanel", baseFguiPanel)
function RadiantDecreeTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RadiantDecreeTaskPanel:ctor", self.viewName)
end
function RadiantDecreeTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RadiantDecreeTaskPanel:onInit()
	print("=======RadiantDecreeTaskPanel:onInit")
end
function RadiantDecreeTaskPanel:onShow()
	print("=======RadiantDecreeTaskPanel:onShow")
end
return RadiantDecreeTaskPanel

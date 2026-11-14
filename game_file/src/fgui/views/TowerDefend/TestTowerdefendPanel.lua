local baseFguiPanel = require("fgui.base.baseFguiPanel")
local TestTowerdefendPanel = class("TestTowerdefendPanel", baseFguiPanel)
function TestTowerdefendPanel:ctor(...)
	self.super.ctor(self, ...)
	print("TestTowerdefendPanel:ctor", self.viewName)
end
function TestTowerdefendPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function TestTowerdefendPanel:onInit()
	print("=======TestTowerdefendPanel:onInit")
end
function TestTowerdefendPanel:onShow()
	print("=======TestTowerdefendPanel:onShow")
end
function TestTowerdefendPanel:onHide()
	print("=======TestTowerdefendPanel:onHide")
end
function TestTowerdefendPanel:onDispose()
	print("=======TestTowerdefendPanel:onDispose")
end
return TestTowerdefendPanel

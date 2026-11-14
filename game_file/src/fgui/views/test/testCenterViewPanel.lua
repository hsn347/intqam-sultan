local basePanel = require("fgui.base.baseFguiPanel")
local testCenterViewPanel = class("testCenterViewPanel", basePanel)
function testCenterViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("testCenterViewPanel:ctor", self.viewName)
end
function basePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function testCenterViewPanel:onInit()
	print("=======testCenterViewPanel:onInit")
	self.view:addClickListener(function()
		uiManager:show(uiName.testView)
	end)
end
function testCenterViewPanel:onShow()
	print("=======testCenterViewPanel:onShow")
end
function testCenterViewPanel:onHide()
	print("=======testCenterViewPanel:onHide")
end
function testCenterViewPanel:onDispose()
	print("=======testCenterViewPanel:onDispose")
end
return testCenterViewPanel

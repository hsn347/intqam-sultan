local baseFguiPanel = require("fgui.base.baseFguiPanel")
local testpetPanel = class("testpetPanel", baseFguiPanel)
function testpetPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("testpetPanel:ctor", self.viewName)
end
function testpetPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "PetFguiView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function testpetPanel:onInit()
	print("=======testpetPanel:onInit")
end
function testpetPanel:onShow()
	print("=======testpetPanel:onShow")
	dump(self.fields.d_1.initData, "self.fields.d_1")
end
function testpetPanel:onHide()
	print("=======testpetPanel:onHide")
end
function testpetPanel:onDispose()
	print("=======testpetPanel:onDispose")
end
return testpetPanel

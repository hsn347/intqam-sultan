local baseFguiPanel = require("fgui.base.baseFguiPanel")
local testFillPanel = class("testFillPanel", baseFguiPanel)
function testFillPanel:ctor(...)
	self.super.ctor(self, ...)
	print("testFillPanel:ctor", self.viewName)
end
function testFillPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function testFillPanel:onInit()
	print("=======testFillPanel:onInit")
	fgui.GTween:to(0, 1, 2):onUpdate(function(tweener)
		local v = tweener.value.x
		for i = 1, 30 do
			if self.fields["Image" .. i] then
				self.fields["Image" .. i]:setFillAmount(v)
			end
		end
	end):setRepeat(-1):setTarget(self)
end
function testFillPanel:onShow()
	print("=======testFillPanel:onShow")
end
function testFillPanel:onHide()
	print("=======testFillPanel:onHide")
end
function testFillPanel:onDispose()
	print("=======testFillPanel:onDispose")
end
return testFillPanel

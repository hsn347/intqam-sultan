local basePanel = require("fgui.base.baseFguiPanel")
local test2Panel = class("test2Panel", basePanel)
function test2Panel:ctor(...)
	self.super.ctor(self, ...)
	print("test2Panel:ctor", self.viewName)
end
function basePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function test2Panel:onInit()
	print("=======test2Panel:onInit")
	self:addClickListener(function()
		self:close()
	end)
end
function test2Panel:onShow()
	print("=======test2Panel:onShow")
end
function test2Panel:onHide()
	print("=======test2Panel:onHide")
end
function test2Panel:onDispose()
	print("=======test2Panel:onDispose")
end
return test2Panel

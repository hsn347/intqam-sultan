local baseFguiPanel = require("fgui.base.baseFguiPanel")
local test3Panel = class("test3Panel", baseFguiPanel)
function test3Panel:ctor(...)
	self.super.ctor(self, ...)
	print("test3Panel:ctor", self.viewName)
end
function test3Panel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function test3Panel:onInit()
	print("=======test3Panel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function test3Panel:onItemRenderer(index, obj)
	obj:setString(tostring(index + 1))
end
function test3Panel:onShow()
	print("=======test3Panel:onShow")
	self.fields.List:setNumItems(100)
end
function test3Panel:onHide()
	print("=======test3Panel:onHide")
end
function test3Panel:onDispose()
	print("=======test3Panel:onDispose")
end
return test3Panel

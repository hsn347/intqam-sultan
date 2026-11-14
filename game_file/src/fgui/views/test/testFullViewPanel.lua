local basePanel = require("fgui.base.baseFguiPanel")
local testFullViewPanel = class("testFullViewPanel", basePanel)
function testFullViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("testFullViewPanel:ctor", self.viewName)
	print("testFullViewPanel:zorder", self:displayObject():getLocalZOrder())
end
function basePanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
		self._packageList, self._packageList[2] = self._packageList, "Resource"
	end
	return self._packageList
end
function testFullViewPanel:onInit()
	print("=======testFullViewPanel:onInit")
	print("testFullViewPanel:onInit zorder:", self:displayObject():getLocalZOrder())
	self.view:getChild("n11"):addClickListener(function()
		uiManager:show(uiName.testCenterView)
	end)
	self.view:getChild("n1"):addClickListener(function()
		SoraDShowMsgTip("测试提示信息")
	end)
	self.view:getChild("n3"):addClickListener(function()
		local panel = SoraDCreatePanel("cavalryRiseAwardPreviewView")
		panel:setTitle()
		panel:show()
	end)
end
function testFullViewPanel:onShow()
	print("=======testFullViewPanel:onShow")
end
function testFullViewPanel:onHide()
	print("=======testFullViewPanel:onHide")
end
function testFullViewPanel:onDispose()
	print("=======testFullViewPanel:onDispose")
end
return testFullViewPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheckRewardPanel = class("CheckRewardPanel", baseFguiPanel)
function CheckRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CheckRewardPanel:ctor", self.viewName)
end
function CheckRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CheckRewardPanel:onInit()
	print("=======CheckRewardPanel:onInit")
end
function CheckRewardPanel:onShow()
	print("=======CheckRewardPanel:onShow")
end
function CheckRewardPanel:onHide()
	print("=======CheckRewardPanel:onHide")
end
function CheckRewardPanel:onDispose()
	print("=======CheckRewardPanel:onDispose")
end
return CheckRewardPanel

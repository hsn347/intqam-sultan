local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideUIPanel = class("MainCityGuideUIPanel", baseFguiPanel)
function MainCityGuideUIPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideUIPanel:ctor", self.viewName)
end
function MainCityGuideUIPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideUIPanel:onInit()
	print("=======MainCityGuideUIPanel:onInit")
end
function MainCityGuideUIPanel:onShow()
	print("=======MainCityGuideUIPanel:onShow")
end
return MainCityGuideUIPanel

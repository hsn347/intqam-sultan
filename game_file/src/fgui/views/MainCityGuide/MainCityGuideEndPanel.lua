local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideEndPanel = class("MainCityGuideEndPanel", baseFguiPanel)
function MainCityGuideEndPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideEndPanel:ctor", self.viewName)
end
function MainCityGuideEndPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideEndPanel:onInit()
	print("=======MainCityGuideEndPanel:onInit")
	self.fields.btn_next:addEventListener(fgui.UIEventType.Click, handler(self, self.nextClick))
end
function MainCityGuideEndPanel:onShow()
	print("=======MainCityGuideEndPanel:onShow")
end
function MainCityGuideEndPanel:onHide()
	if self.param.closeCallback then
		self.param.closeCallback()
	end
end
function MainCityGuideEndPanel:nextClick()
	self:close()
end
return MainCityGuideEndPanel

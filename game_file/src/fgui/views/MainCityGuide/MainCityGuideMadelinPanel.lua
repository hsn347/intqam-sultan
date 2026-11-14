local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideMadelinPanel = class("MainCityGuideMadelinPanel", baseFguiPanel)
function MainCityGuideMadelinPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideMadelinPanel:ctor", self.viewName)
end
function MainCityGuideMadelinPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideMadelinPanel:onInit()
	print("=======MainCityGuideMadelinPanel:onInit")
	self.fields.btn_next:addEventListener(fgui.UIEventType.Click, handler(self, self.nextClick))
end
function MainCityGuideMadelinPanel:onShow()
	print("=======MainCityGuideMadelinPanel:onShow")
	self:setAlpha(0)
	self:runAction(ffa.fadeIn(0.2))
end
function MainCityGuideMadelinPanel:onHide()
	AudioEngine.stopEffect(self.soundId)
	if self.param and self.param.closeCallback then
		self.param.closeCallback(self)
	end
end
function MainCityGuideMadelinPanel:nextClick()
	self.fields.btn_next:setVisible(false)
	self:runAction(ffa.seq(ffa.fadeOut(0.2), ffa.callFunc(function()
		self:close()
	end)))
end
return MainCityGuideMadelinPanel

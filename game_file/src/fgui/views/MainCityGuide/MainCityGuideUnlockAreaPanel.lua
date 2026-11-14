local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideUnlockAreaPanel = class("MainCityGuideUnlockAreaPanel", baseFguiPanel)
function MainCityGuideUnlockAreaPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideUnlockAreaPanel:ctor", self.viewName)
end
function MainCityGuideUnlockAreaPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideUnlockAreaPanel:onInit()
	print("=======MainCityGuideUnlockAreaPanel:onInit")
end
function MainCityGuideUnlockAreaPanel:onHide()
	if self.param and self.param.closeCallback then
		self.param.closeCallback(self)
	end
end
function MainCityGuideUnlockAreaPanel:onShow()
	print("=======MainCityGuideUnlockAreaPanel:onShow")
	_UPVALUE5_ = print
	print[1] = "new_guide_text_0029"
	print[2] = "new_guide_text_0030"
	print[3] = "new_guide_text_0031"
	print[4] = "new_guide_text_0032"
	local print[5], strs = "new_guide_text_0033", print
	self.fields.title:setString(i18n(strs[self.param.idx]))
	self.fields.bg:setAlpha(0)
	self.fields.title:setAlpha(0)
	_UPVALUE1_ = i18n(strs[self.param.idx])
	i18n(strs[self.param.idx])[1] = ffa.delay(0.8)
	i18n(strs[self.param.idx])[2] = ffa.fadeIn(0.3)
	i18n(strs[self.param.idx])[3] = ffa.fadeIn(0.3)
	self.fields.bg:runAction(ffa.seq(i18n(strs[self.param.idx])))
	_UPVALUE1_ = ffa.seq(i18n(strs[self.param.idx]))
	ffa.seq(i18n(strs[self.param.idx]))[1] = ffa.delay(0.8)
	ffa.seq(i18n(strs[self.param.idx]))[2] = ffa.fadeIn(0.3)
	ffa.seq(i18n(strs[self.param.idx]))[3] = ffa.fadeIn(0.3)
	self.fields.title:runAction(ffa.seq(ffa.seq(i18n(strs[self.param.idx]))))
	self:runAction(ffa.seq(ffa.delay(2), ffa.fadeOut(0.2), ffa.callFunc(function()
		self:removeFromParent()
	end)))
end
return MainCityGuideUnlockAreaPanel

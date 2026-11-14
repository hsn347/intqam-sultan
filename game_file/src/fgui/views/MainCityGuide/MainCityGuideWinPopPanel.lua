local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideWinPopPanel = class("MainCityGuideWinPopPanel", baseFguiPanel)
function MainCityGuideWinPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideWinPopPanel:ctor", self.viewName)
end
function MainCityGuideWinPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideWinPopPanel:onInit()
	print("=======MainCityGuideWinPopPanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	SoraDPlaySound("elimiateGame", 5)
	if display.height > 1136 then
		self.fields.Usm_1:setScale(display.height / 1136)
		self.fields.Usm_2:setScale(display.height / 1136)
		self.fields.Usm_3:setScale(display.height / 1136)
	end
	self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function MainCityGuideWinPopPanel:onShow()
	print("=======MainCityGuideWinPopPanel:onShow")
	self.rewards = self.param.rewards
	self.fields.scroll:setNumItems(#self.rewards)
end
function MainCityGuideWinPopPanel:onItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	obj:initData(reward.id, reward.count)
end
function MainCityGuideWinPopPanel:onHide()
	SoraDMailGainItems(self.rewards, true)
	if self.param.closeCallback then
		self.param.closeCallback()
	end
end
return MainCityGuideWinPopPanel

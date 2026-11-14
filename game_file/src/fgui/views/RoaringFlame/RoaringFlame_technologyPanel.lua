local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_technologyPanel = class("RoaringFlame_technologyPanel", baseFguiPanel)
function RoaringFlame_technologyPanel:ctor(...)
	RoaringFlame_technologyPanel.super.ctor(self, ...)
	print("RoaringFlame_technologyPanel:ctor", self.viewName)
end
function RoaringFlame_technologyPanel:onInit()
	print("=======RoaringFlame_technologyPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text69"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function RoaringFlame_technologyPanel:onShow()
	print("=======RoaringFlame_technologyPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function RoaringFlame_technologyPanel:initData()
	local techPoint = roaringFlameWarCtrl:getTechnologyPoint()
	self.fields.Lab_point:setIcon("1703.png")
	roaringFlameWarCtrl = nil
	;(nil).num = fguiHelper.getColorString("#FFFFFF", techPoint)
	self.fields.Lab_point:setString(i18n("flames_dunes_text310", nil))
	self.fields.tree:updateData()
end
function RoaringFlame_technologyPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule07")
	;(nil).content = i18n("flames_dunes_second_rule08")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_technologyPanel

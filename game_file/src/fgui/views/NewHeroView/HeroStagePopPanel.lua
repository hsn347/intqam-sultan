local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroStagePopPanel = class("HeroStagePopPanel", baseFguiPanel)
function HeroStagePopPanel:ctor(...)
	HeroStagePopPanel.super.ctor(self, ...)
	print("HeroStagePopPanel:ctor", self.viewName)
end
function HeroStagePopPanel:onInit()
	print("=======HeroStagePopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4818"))
	self.fields.n1:fix()
	self.fields.Text_pro:fixPos()
end
function HeroStagePopPanel:onShow()
	print("=======HeroStagePopPanel:onShow")
	self:initData()
end
function HeroStagePopPanel:initData()
	self.fields.Com_stage:initData(self.param.heroID)
	local percent = heroCtrl:getHeroPowerSkillPercent(self.param.heroID)
	heroCtrl = nil
	;(nil).num = fguiHelper.getColorString("#FED24B", percent .. "%")
	self.fields.Text_pro:setString(i18n("common_text_4822", nil))
end
return HeroStagePopPanel

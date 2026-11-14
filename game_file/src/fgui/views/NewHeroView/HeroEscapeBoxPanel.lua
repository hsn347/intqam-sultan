local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroEscapeBoxPanel = class("HeroEscapeBoxPanel", baseFguiPanel)
function HeroEscapeBoxPanel:ctor(...)
	self.isLRU = true
	HeroEscapeBoxPanel.super.ctor(self, ...)
	print("HeroEscapeBoxPanel:ctor", self.viewName)
end
function HeroEscapeBoxPanel:onInit()
	print("=======HeroEscapeBoxPanel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_text_86"))
	self.fields.Button_ok:setTitle(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClick_Button_cancel))
	self.fields.Button_ok:fixPos()
	self.fields.Button_cancel:fixPos()
end
function HeroEscapeBoxPanel:endShow()
	print("=======HeroEscapeBoxPanel:endShow")
	self.heroID = self.param.heroID
	local keyNum = backpackCtrl:getItemCount(gHeroSpecialItems.breakKey)
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", keyNum)
	self.fields.Text_msg:setString(i18n("hero_text_15", nil))
	self.fields.Com_item:initData(gHeroSpecialItems.breakKey, keyNum)
end
function HeroEscapeBoxPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	heroJailCtrl:reqBreaker(self.heroID)
	self:close()
end
function HeroEscapeBoxPanel:onClick_Button_cancel(context)
	SoraDPlaySound()
	self:close()
end
return HeroEscapeBoxPanel

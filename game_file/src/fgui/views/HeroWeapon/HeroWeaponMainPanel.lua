local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponMainPanel = class("HeroWeaponMainPanel", baseFguiPanel)
function HeroWeaponMainPanel:ctor(...)
	HeroWeaponMainPanel.super.ctor(self, ...)
	print("HeroWeaponMainPanel:ctor", self.viewName)
end
function HeroWeaponMainPanel:onInit()
	print("=======HeroWeaponMainPanel:onInit")
	self.fields.Com_title:initData(i18n("HeroWeapon_3"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function HeroWeaponMainPanel:onShow()
	print("=======HeroWeaponMainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function HeroWeaponMainPanel:endShow()
end
function HeroWeaponMainPanel:initData()
	self.fields.Btn_list:setRedDot()
end
function HeroWeaponMainPanel:onClickHelp()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_WEAPON)
end
function HeroWeaponMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Btn_list" then
		return self.fields.Btn_list:getChildByName("Btn")
	else
		return self.fields[itemName]
	end
end
return HeroWeaponMainPanel

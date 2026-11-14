local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponSellProxy = class("HeroWeaponSellProxy", baseProxy)
function HeroWeaponSellProxy:onRegisterEvent()
	print("=======HeroWeaponSellProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_UI_SELL_SELECT", handler(self, self.selectBack))
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponSellProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
function HeroWeaponSellProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponSellProxy

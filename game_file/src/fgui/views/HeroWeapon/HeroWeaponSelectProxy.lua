local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponSelectProxy = class("HeroWeaponSelectProxy", baseProxy)
function HeroWeaponSelectProxy:onRegisterEvent()
	print("=======HeroWeaponSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_UI_WEAR_SELECT", handler(self, self.selectBack))
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponSelectProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
function HeroWeaponSelectProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponSelectProxy

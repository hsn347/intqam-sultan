local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponAdvanceProxy = class("HeroWeaponAdvanceProxy", baseProxy)
function HeroWeaponAdvanceProxy:onRegisterEvent()
	print("=======HeroWeaponAdvanceProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_UI_COST_SELECT", handler(self, self.chooseBack))
end
function HeroWeaponAdvanceProxy:initData(target, data)
	self.view:initData(target, data)
end
function HeroWeaponAdvanceProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
return HeroWeaponAdvanceProxy

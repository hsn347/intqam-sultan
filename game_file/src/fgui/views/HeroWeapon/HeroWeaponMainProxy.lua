local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponMainProxy = class("HeroWeaponMainProxy", baseProxy)
function HeroWeaponMainProxy:onRegisterEvent()
	print("=======HeroWeaponMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponMainProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponMainProxy

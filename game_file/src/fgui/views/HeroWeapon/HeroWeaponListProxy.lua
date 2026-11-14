local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponListProxy = class("HeroWeaponListProxy", baseProxy)
function HeroWeaponListProxy:onRegisterEvent()
	print("=======HeroWeaponListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_WEAPON_WEAR", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponListProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponListProxy

local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponMapProxy = class("HeroWeaponMapProxy", baseProxy)
function HeroWeaponMapProxy:onRegisterEvent()
	print("=======HeroWeaponMapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponMapProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponMapProxy

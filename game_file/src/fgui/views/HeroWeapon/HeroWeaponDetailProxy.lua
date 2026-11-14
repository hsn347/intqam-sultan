local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponDetailProxy = class("HeroWeaponDetailProxy", baseProxy)
function HeroWeaponDetailProxy:onRegisterEvent()
	print("=======HeroWeaponDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_REBIRTH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.updateView))
end
function HeroWeaponDetailProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return HeroWeaponDetailProxy

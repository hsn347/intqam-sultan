local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponStrengthProxy = class("HeroWeaponStrengthProxy", baseProxy)
function HeroWeaponStrengthProxy:onRegisterEvent()
	print("=======HeroWeaponStrengthProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
end
function HeroWeaponStrengthProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponStrengthProxy

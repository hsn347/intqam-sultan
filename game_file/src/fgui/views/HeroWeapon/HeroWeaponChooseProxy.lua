local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponChooseProxy = class("HeroWeaponChooseProxy", baseProxy)
function HeroWeaponChooseProxy:onRegisterEvent()
	print("=======HeroWeaponChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_UI_COST_SELECT_MORE", handler(self, self.chooseBack))
end
function HeroWeaponChooseProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
return HeroWeaponChooseProxy

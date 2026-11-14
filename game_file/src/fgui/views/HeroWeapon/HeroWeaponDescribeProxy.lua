local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponDescribeProxy = class("HeroWeaponDescribeProxy", baseProxy)
function HeroWeaponDescribeProxy:onRegisterEvent()
	print("=======HeroWeaponDescribeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_WEAPON_SERVER_UPDATE", handler(self, self.initData))
end
function HeroWeaponDescribeProxy:initData()
	self.view:initData()
end
return HeroWeaponDescribeProxy

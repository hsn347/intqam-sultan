local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponShopProxy = class("HeroWeaponShopProxy", baseProxy)
function HeroWeaponShopProxy:onRegisterEvent()
	print("=======HeroWeaponShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDayUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initData))
end
function HeroWeaponShopProxy:newDayUpdate(target, data)
	self.view:newDayUpdate(target, data)
end
function HeroWeaponShopProxy:initData(target, data)
	self.view:initData(target, data)
end
return HeroWeaponShopProxy

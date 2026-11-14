local baseProxy = require("fgui.base.baseProxy")
local HeroExchangeShopProxy = class("HeroExchangeShopProxy", baseProxy)
function HeroExchangeShopProxy:onRegisterEvent()
	print("=======HeroExchangeShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_EXCHANGE", handler(self, self.updateExchangeView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updateShopView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateShopView))
end
function HeroExchangeShopProxy:updateExchangeView(target, data)
	self.view:updateExchangeView(target, data)
end
function HeroExchangeShopProxy:updateShopView(target, data)
	self.view:updateShopView(target, data)
end
return HeroExchangeShopProxy

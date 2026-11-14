local baseProxy = require("fgui.base.baseProxy")
local FarmShopProxy = class("FarmShopProxy", baseProxy)
function FarmShopProxy:onRegisterEvent()
	print("=======FarmShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_RECYCLE", handler(self, self.onFarmlandRecycle))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_COIN_UPDATE", handler(self, self.onItemChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.onExchangeMallBuy))
end
function FarmShopProxy:onFarmlandRecycle()
	self.view:updateView()
end
function FarmShopProxy:onItemChange()
	self.view:updateCurrencyNum()
end
function FarmShopProxy:onExchangeMallBuy()
	self.view:updateExchangeStore()
end
return FarmShopProxy

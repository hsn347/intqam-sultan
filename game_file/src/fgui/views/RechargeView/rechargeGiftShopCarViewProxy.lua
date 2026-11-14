local baseProxy = require("fgui.base.baseProxy")
local rechargeGiftShopCarViewProxy = class("rechargeGiftShopCarViewProxy", baseProxy)
function rechargeGiftShopCarViewProxy:onRegisterEvent()
	print("=======rechargeGiftShopCarViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_DATA", handler(self, self.suitData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_UI_SEL", handler(self, self.delSelect))
end
function rechargeGiftShopCarViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function rechargeGiftShopCarViewProxy:suitData(target, data)
	self.view:suitData(target, data)
end
function rechargeGiftShopCarViewProxy:delSelect(target, data)
	self.view:delSelect(target, data)
end
return rechargeGiftShopCarViewProxy

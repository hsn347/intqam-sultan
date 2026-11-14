local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonExchangeProxy = class("BeastCanyonExchangeProxy", baseProxy)
function BeastCanyonExchangeProxy:onRegisterEvent()
	print("=======BeastCanyonExchangeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateTokenInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updataAll))
end
function BeastCanyonExchangeProxy:updateTokenInfo()
	self.view:updateItemNum()
end
function BeastCanyonExchangeProxy:updataScroll()
	self.view:updatScroll()
end
function BeastCanyonExchangeProxy:updataAll()
	self.view:updateItemNum()
	self.view:updatScroll()
end
return BeastCanyonExchangeProxy

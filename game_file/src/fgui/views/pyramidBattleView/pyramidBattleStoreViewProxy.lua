local baseProxy = require("fgui.base.baseProxy")
local pyramidBattleStoreViewProxy = class("pyramidBattleStoreViewProxy", baseProxy)
function pyramidBattleStoreViewProxy:onRegisterEvent()
	print("=======pyramidBattleStoreViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_PYRAMID_SHOP_EXCHANGE_REFRESH", handler(self, self.exchangeRefresh))
	SoraDAddMessage(self, "MESSAGE_PYRAMID_SHOP_NOTICE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_PYRAMID_SHOP_COMMON_REFRESH", handler(self, self.updateView))
end
function pyramidBattleStoreViewProxy:exchangeRefresh(target, data)
	self.view:exchangeRefresh(target, data)
end
function pyramidBattleStoreViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function pyramidBattleStoreViewProxy:updateRed(target, data)
	self.view:updateRed(target, data)
end
return pyramidBattleStoreViewProxy

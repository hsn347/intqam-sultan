local baseProxy = require("fgui.base.baseProxy")
local ExchangeShopMainProxy = class("ExchangeShopMainProxy", baseProxy)
function ExchangeShopMainProxy:onRegisterEvent()
	print("=======ExchangeShopMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.refreshRed))
end
function ExchangeShopMainProxy:initData()
	if self and self.view then
		self.view:initData()
	end
end
function ExchangeShopMainProxy:refreshRed(target, data)
	if self and self.view then
		self.view:refreshRed(target, data)
	end
end
function ExchangeShopMainProxy:judgeClose(target, data)
	if self and self.view then
		self.view:judgeClose()
	end
end
return ExchangeShopMainProxy

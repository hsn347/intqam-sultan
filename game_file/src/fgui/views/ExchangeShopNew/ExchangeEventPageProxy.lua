local baseProxy = require("fgui.base.baseProxy")
local ExchangeEventPageProxy = class("ExchangeEventPageProxy", baseProxy)
function ExchangeEventPageProxy:onRegisterEvent()
	print("=======ExchangeEventPageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initToShop))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SPECIALTIME_REFRESH", handler(self, self.setTime))
end
function ExchangeEventPageProxy:initData(target, data)
	if self.view then
		self.view:initData(target, data)
	end
end
function ExchangeEventPageProxy:initToShop(target, data)
	if self.view then
		self.view:initToShop(target, data)
		self.view:initData(target, data)
	end
end
function ExchangeEventPageProxy:closeLoading()
	print("maybe have some error")
	SoraDCloseLoading(display.object)
	if self.view then
		self.view:closeLoading()
	end
end
function ExchangeEventPageProxy:judgeClose()
	if self.view then
		self.view:judgeClose()
	end
end
function ExchangeEventPageProxy:setTime()
	if self.view then
		self.view:setTime()
		self.view:initData()
	end
end
return ExchangeEventPageProxy

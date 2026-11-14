local baseProxy = require("fgui.base.baseProxy")
local ExchangeRunePageProxy = class("ExchangeRunePageProxy", baseProxy)
function ExchangeRunePageProxy:onRegisterEvent()
	print("=======ExchangeRunePageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SPECIALTIME_REFRESH", handler(self, self.initData))
end
function ExchangeRunePageProxy:initData(target, data)
	if data and data.activityID == gActivityTimeActivityID.RUNE_EXCHANGE_MALL then
		self.view:initData()
	end
end
function ExchangeRunePageProxy:updateView(target, data)
	self.view:initData()
end
return ExchangeRunePageProxy

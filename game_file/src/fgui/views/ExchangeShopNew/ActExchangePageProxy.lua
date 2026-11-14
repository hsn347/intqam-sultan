local baseProxy = require("fgui.base.baseProxy")
local ActExchangePageProxy = class("ActExchangePageProxy", baseProxy)
function ActExchangePageProxy:onRegisterEvent()
	print("=======ActExchangePageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.onMsgExchangeMallRefresh))
end
function ActExchangePageProxy:initData()
	if self.view then
		self.view:initData()
	end
end
function ActExchangePageProxy:onMsgExchangeMallRefresh()
	if self.view then
		self.view:initData()
		self.view:setTime()
	end
end
function ActExchangePageProxy:closeLoading()
end
function ActExchangePageProxy:judgeClose()
	if self.view then
		self.view:judgeClose()
	end
end
return ActExchangePageProxy

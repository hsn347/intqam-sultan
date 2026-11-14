local baseProxy = require("fgui.base.baseProxy")
local ActExchangePageNewProxy = class("ActExchangePageNewProxy", baseProxy)
function ActExchangePageNewProxy:onRegisterEvent()
	print("=======ActExchangePageNewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.onMsgExchangeMallRefresh))
end
function ActExchangePageNewProxy:initData()
	if self.view then
		self.view:initData()
	end
end
function ActExchangePageNewProxy:onMsgExchangeMallRefresh()
	if self.view then
		self.view:initData()
		self.view:setTime()
	end
end
function ActExchangePageNewProxy:closeLoading()
end
function ActExchangePageNewProxy:judgeClose()
	if self.view then
		self.view:judgeClose()
	end
end
return ActExchangePageNewProxy

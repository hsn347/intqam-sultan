local baseProxy = require("fgui.base.baseProxy")
local tradeBoardViewProxy = class("tradeBoardViewProxy", baseProxy)
function tradeBoardViewProxy:onRegisterEvent()
	print("=======tradeBoardViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN", handler(self, self.initTradeBoardView))
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN_CLOSE", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_TRADEBOARDRETURN", handler(self, self.initNewTradeBoardView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_TRADEBOARD_CLEARHINT", handler(self, self.refreshRedPoint))
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_TRADEBOARD_UI", handler(self, self.updateNewTradeBoard))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateNewTradeBoard))
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_RESOURCE_SELECT", handler(self, self.updateResIndex))
end
function tradeBoardViewProxy:initTradeBoardView()
	self.view:initTradeBoardView()
end
function tradeBoardViewProxy:closeMe()
	self.view:closeMe()
end
function tradeBoardViewProxy:judgeClose()
	self.view:judgeClose()
end
function tradeBoardViewProxy:initNewTradeBoardView()
	self.view:initNewTradeBoardView()
end
function tradeBoardViewProxy:refreshRedPoint()
	self.view:refreshRedPoint()
end
function tradeBoardViewProxy:updateNewTradeBoard()
	self.view:updateNewTradeBoard()
end
function tradeBoardViewProxy:updateResIndex(target, data)
	self.view:updateResIndex(target, data)
end
return tradeBoardViewProxy

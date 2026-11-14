local baseProxy = require("fgui.base.baseProxy")
local tradeBoardMoneyViewProxy = class("tradeBoardMoneyViewProxy", baseProxy)
function tradeBoardMoneyViewProxy:onRegisterEvent()
	print("=======tradeBoardMoneyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN", handler(self, self.refreshGold))
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN_GOLDRECORD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN_RECORD", handler(self, self.initData))
end
function tradeBoardMoneyViewProxy:refreshGold(target, data)
	self.view:refreshGold(target, data)
end
function tradeBoardMoneyViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return tradeBoardMoneyViewProxy

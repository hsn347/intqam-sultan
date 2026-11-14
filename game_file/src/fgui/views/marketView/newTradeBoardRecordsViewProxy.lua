local baseProxy = require("fgui.base.baseProxy")
local newTradeBoardRecordsViewProxy = class("newTradeBoardRecordsViewProxy", baseProxy)
function newTradeBoardRecordsViewProxy:onRegisterEvent()
	print("=======newTradeBoardRecordsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_TRADEBOARDRETURN_RECORD", handler(self, self.initData))
end
function newTradeBoardRecordsViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return newTradeBoardRecordsViewProxy

local baseProxy = require("fgui.base.baseProxy")
local newTradeBoardSelfRecordProxy = class("newTradeBoardSelfRecordProxy", baseProxy)
function newTradeBoardSelfRecordProxy:onRegisterEvent()
	print("=======newTradeBoardSelfRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MARKET_NEW_TRADEBOARD_SELFRECORD", handler(self, self.initData))
end
function newTradeBoardSelfRecordProxy:initData()
	self.view:initData()
end
return newTradeBoardSelfRecordProxy

local baseProxy = require("fgui.base.baseProxy")
local marketViewProxy = class("marketViewProxy", baseProxy)
function marketViewProxy:onRegisterEvent()
	print("=======marketViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MARKET_GETUSERINFO", handler(self, self.bindData))
	SoraDAddMessage(self, "MESSAGE_MARKET_REQ_OTHERINFO_BACK", handler(self, self.getOtherInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_ISBETRAYBYUID", handler(self, self.isBetrayBack))
end
function marketViewProxy:bindData(...)
	self.view:bindData(...)
end
function marketViewProxy:getOtherInfo(...)
	self.view:getOtherInfo(...)
end
function marketViewProxy:isBetrayBack(...)
	self.view:isBetrayBack(...)
end
return marketViewProxy

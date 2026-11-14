local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkBuyProxy = class("DivineBeastMarkBuyProxy", baseProxy)
function DivineBeastMarkBuyProxy:onRegisterEvent()
	print("=======DivineBeastMarkBuyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updataAll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updataAll))
end
function DivineBeastMarkBuyProxy:updataAll()
	self.view:updateView()
end
return DivineBeastMarkBuyProxy

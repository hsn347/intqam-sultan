local baseProxy = require("fgui.base.baseProxy")
local Activity_9001558_ExchangeProxy = class("Activity_9001558_ExchangeProxy", baseProxy)
function Activity_9001558_ExchangeProxy:onRegisterEvent()
	print("=======Activity_9001558_ExchangeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001558_EXCHANGE", handler(self, self.onMsgExchangeBack))
end
function Activity_9001558_ExchangeProxy:onMsgExchangeBack(...)
	self.view:onMsgExchangeBack()
end
return Activity_9001558_ExchangeProxy

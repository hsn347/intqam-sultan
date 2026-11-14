local baseProxy = require("fgui.base.baseProxy")
local Activity_9001727_BuyGiftProxy = class("Activity_9001727_BuyGiftProxy", baseProxy)
function Activity_9001727_BuyGiftProxy:onRegisterEvent()
	print("=======Activity_9001727_BuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001727_BUYGIFT", handler(self, self.onMsgBuyGift))
end
function Activity_9001727_BuyGiftProxy:onMsgBuyGift(target, event)
	self.view:close()
end
return Activity_9001727_BuyGiftProxy

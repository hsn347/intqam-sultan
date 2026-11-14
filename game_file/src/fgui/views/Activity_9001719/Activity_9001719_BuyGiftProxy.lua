local baseProxy = require("fgui.base.baseProxy")
local Activity_9001719_BuyGiftProxy = class("Activity_9001719_BuyGiftProxy", baseProxy)
function Activity_9001719_BuyGiftProxy:onRegisterEvent()
	print("=======Activity_9001719_BuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_BUYGIFT", handler(self, self.onBuyGiftMsg))
end
function Activity_9001719_BuyGiftProxy:onBuyGiftMsg(target, data)
	self.view:onBuyGiftMsg(target, data)
end
return Activity_9001719_BuyGiftProxy

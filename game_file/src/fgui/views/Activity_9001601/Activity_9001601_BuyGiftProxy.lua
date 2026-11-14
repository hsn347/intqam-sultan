local baseProxy = require("fgui.base.baseProxy")
local Activity_9001601_BuyGiftProxy = class("Activity_9001601_BuyGiftProxy", baseProxy)
function Activity_9001601_BuyGiftProxy:onRegisterEvent()
	print("=======Activity_9001601_BuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001601_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001601_BuyGiftProxy:onMsgUpdateData(target, event)
	if event.key == "buyGift" then
		self.view:closePanel()
	end
end
return Activity_9001601_BuyGiftProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001735_GiftProxy = class("Activity_9001735_GiftProxy", baseProxy)
function Activity_9001735_GiftProxy:onRegisterEvent()
	print("=======Activity_9001735_GiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001735_BUYGIFT", handler(self, self.buyGiftMsgBack))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onNewDay))
end
function Activity_9001735_GiftProxy:buyGiftMsgBack(target, data)
	self.view:buyGiftMsgBack(target, data)
end
function Activity_9001735_GiftProxy:onNewDay()
	self.view:onNewDay()
end
return Activity_9001735_GiftProxy

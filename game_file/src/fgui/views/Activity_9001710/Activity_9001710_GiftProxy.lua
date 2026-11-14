local baseProxy = require("fgui.base.baseProxy")
local Activity_9001710_GiftProxy = class("Activity_9001710_GiftProxy", baseProxy)
function Activity_9001710_GiftProxy:onRegisterEvent()
	print("=======Activity_9001710_GiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001710_BUYGIFT", handler(self, self.buyGiftBack))
end
function Activity_9001710_GiftProxy:buyGiftBack(target, data)
	self.view:buyGiftBack(target, data)
end
return Activity_9001710_GiftProxy

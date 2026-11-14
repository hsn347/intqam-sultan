local baseProxy = require("fgui.base.baseProxy")
local Activity_9001628_GiftProxy = class("Activity_9001628_GiftProxy", baseProxy)
function Activity_9001628_GiftProxy:onRegisterEvent()
	print("=======Activity_9001628_GiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_PACKAGE", handler(self, self.buyGiftBack))
end
function Activity_9001628_GiftProxy:buyGiftBack()
	self.view:close()
end
return Activity_9001628_GiftProxy

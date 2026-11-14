local baseProxy = require("fgui.base.baseProxy")
local Activity_9001713_GiftProxy = class("Activity_9001713_GiftProxy", baseProxy)
function Activity_9001713_GiftProxy:onRegisterEvent()
	print("=======Activity_9001713_GiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001713_UPDATE", handler(self, self.initView))
end
function Activity_9001713_GiftProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001713_GiftProxy

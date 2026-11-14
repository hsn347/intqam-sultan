local baseProxy = require("fgui.base.baseProxy")
local DashainGiftingPopProxy = class("DashainGiftingPopProxy", baseProxy)
function DashainGiftingPopProxy:onRegisterEvent()
	print("=======DashainGiftingPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001537_UPDATE", handler(self, self.msgUpdateView))
end
function DashainGiftingPopProxy:msgUpdateView()
	self.view:updateStatus()
end
return DashainGiftingPopProxy

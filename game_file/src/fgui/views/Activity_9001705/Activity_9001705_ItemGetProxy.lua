local baseProxy = require("fgui.base.baseProxy")
local Activity_9001705_ItemGetProxy = class("Activity_9001705_ItemGetProxy", baseProxy)
function Activity_9001705_ItemGetProxy:onRegisterEvent()
	print("=======Activity_9001705_ItemGetProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001705_UPDATE", handler(self, self.updateView))
end
function Activity_9001705_ItemGetProxy:updateView(target, data)
	self.view:updateView(data.msgType)
end
return Activity_9001705_ItemGetProxy

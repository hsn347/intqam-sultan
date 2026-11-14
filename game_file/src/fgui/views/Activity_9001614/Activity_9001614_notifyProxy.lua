local baseProxy = require("fgui.base.baseProxy")
local Activity_9001614_notifyProxy = class("Activity_9001614_notifyProxy", baseProxy)
function Activity_9001614_notifyProxy:onRegisterEvent()
	print("=======Activity_9001614_notifyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001614_UPDATE", handler(self, self.closeSelf))
end
function Activity_9001614_notifyProxy:closeSelf(target, data)
	self.view:closeSelf(target, data)
end
return Activity_9001614_notifyProxy

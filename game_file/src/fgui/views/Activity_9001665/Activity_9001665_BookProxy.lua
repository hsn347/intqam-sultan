local baseProxy = require("fgui.base.baseProxy")
local Activity_9001665_BookProxy = class("Activity_9001665_BookProxy", baseProxy)
function Activity_9001665_BookProxy:onRegisterEvent()
	print("=======Activity_9001665_BookProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001665_UPDATE", handler(self, self.onUpdate))
end
function Activity_9001665_BookProxy:onUpdate(target, data)
	self.view:updateView()
end
return Activity_9001665_BookProxy

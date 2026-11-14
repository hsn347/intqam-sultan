local baseProxy = require("fgui.base.baseProxy")
local Activity_9001643_mainProxy = class("Activity_9001643_mainProxy", baseProxy)
function Activity_9001643_mainProxy:onRegisterEvent()
	print("=======Activity_9001643_mainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001643_UPDATE", handler(self, self.updateView))
end
function Activity_9001643_mainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001643_mainProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001710_MainProxy = class("Activity_9001710_MainProxy", baseProxy)
function Activity_9001710_MainProxy:onRegisterEvent()
	print("=======Activity_9001710_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001710_UPDATE", handler(self, self.updateUI))
end
function Activity_9001710_MainProxy:updateUI(target, data)
	self.view:updateUI(target, data)
end
return Activity_9001710_MainProxy

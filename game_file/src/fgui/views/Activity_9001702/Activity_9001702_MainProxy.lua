local baseProxy = require("fgui.base.baseProxy")
local Activity_9001702_MainProxy = class("Activity_9001702_MainProxy", baseProxy)
function Activity_9001702_MainProxy:onRegisterEvent()
	print("=======Activity_9001702_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID, handler(self, self.updateActivityHandler))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Activity_9001702_MainProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
function Activity_9001702_MainProxy:updateActivityHandler(...)
	self.view:updateActivityHandler(...)
end
return Activity_9001702_MainProxy

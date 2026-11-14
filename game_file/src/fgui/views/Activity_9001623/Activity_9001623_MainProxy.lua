local baseProxy = require("fgui.base.baseProxy")
local Activity_9001623_MainProxy = class("Activity_9001623_MainProxy", baseProxy)
function Activity_9001623_MainProxy:onRegisterEvent()
	print("=======Activity_9001623_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE", handler(self, self.onMsgCommonSignUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onMsgNewDay))
end
function Activity_9001623_MainProxy:onMsgCommonSignUpdate(...)
	self.view:onMsgCommonSignUpdate(...)
end
function Activity_9001623_MainProxy:onMsgNewDay(...)
	self.view:onMsgNewDay(...)
end
return Activity_9001623_MainProxy

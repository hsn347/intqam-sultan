local baseProxy = require("fgui.base.baseProxy")
local Activity_9001631_MainProxy = class("Activity_9001631_MainProxy", baseProxy)
function Activity_9001631_MainProxy:onRegisterEvent()
	print("=======Activity_9001631_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001631_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001631_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001631_MainProxy

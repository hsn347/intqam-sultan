local baseProxy = require("fgui.base.baseProxy")
local Activity_9001704_MainProxy = class("Activity_9001704_MainProxy", baseProxy)
function Activity_9001704_MainProxy:onRegisterEvent()
	print("=======Activity_9001704_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001704_UPDATE", handler(self, self.onMsgUpdateView))
end
function Activity_9001704_MainProxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
return Activity_9001704_MainProxy

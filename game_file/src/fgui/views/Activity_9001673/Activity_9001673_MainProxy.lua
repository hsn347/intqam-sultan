local baseProxy = require("fgui.base.baseProxy")
local Activity_9001673_MainProxy = class("Activity_9001673_MainProxy", baseProxy)
function Activity_9001673_MainProxy:onRegisterEvent()
	print("=======Activity_9001673_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001673_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001673_MainProxy:onMsgUpdateData(target, data)
	self.view:onMsgUpdateData(target, data)
end
return Activity_9001673_MainProxy

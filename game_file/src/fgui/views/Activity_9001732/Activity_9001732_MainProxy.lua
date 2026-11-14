local baseProxy = require("fgui.base.baseProxy")
local Activity_9001732_MainProxy = class("Activity_9001732_MainProxy", baseProxy)
function Activity_9001732_MainProxy:onRegisterEvent()
	print("=======Activity_9001732_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_DECREE_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001732_MainProxy:onMsgUpdateData(target, event)
	if event.activityID ~= self.view.activityID then
		return
	end
	self.view:onMsgUpdateData(target, event)
end
return Activity_9001732_MainProxy

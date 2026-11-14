local baseProxy = require("fgui.base.baseProxy")
local Activity_9001670_TaskProxy = class("Activity_9001670_TaskProxy", baseProxy)
function Activity_9001670_TaskProxy:onRegisterEvent()
	print("=======Activity_9001670_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001670_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001670_TaskProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001670_TaskProxy

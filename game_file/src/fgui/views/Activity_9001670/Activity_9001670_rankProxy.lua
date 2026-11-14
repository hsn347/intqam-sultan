local baseProxy = require("fgui.base.baseProxy")
local Activity_9001670_rankProxy = class("Activity_9001670_rankProxy", baseProxy)
function Activity_9001670_rankProxy:onRegisterEvent()
	print("=======Activity_9001670_rankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001670_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001670_rankProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001670_rankProxy

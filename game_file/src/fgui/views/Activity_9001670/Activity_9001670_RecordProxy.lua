local baseProxy = require("fgui.base.baseProxy")
local Activity_9001670_RecordProxy = class("Activity_9001670_RecordProxy", baseProxy)
function Activity_9001670_RecordProxy:onRegisterEvent()
	print("=======Activity_9001670_RecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001670_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001670_RecordProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001670_RecordProxy

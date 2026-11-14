local baseProxy = require("fgui.base.baseProxy")
local Activity_9001702_RecordProxy = class("Activity_9001702_RecordProxy", baseProxy)
function Activity_9001702_RecordProxy:onRegisterEvent()
	print("=======Activity_9001702_RecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Activity_9001702_RecordProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
return Activity_9001702_RecordProxy

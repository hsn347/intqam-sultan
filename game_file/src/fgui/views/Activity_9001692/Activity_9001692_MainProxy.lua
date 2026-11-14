local baseProxy = require("fgui.base.baseProxy")
local Activity_9001692_MainProxy = class("Activity_9001692_MainProxy", baseProxy)
function Activity_9001692_MainProxy:onRegisterEvent()
	print("=======Activity_9001692_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE", handler(self, self.onMsgMergeUpdate))
end
function Activity_9001692_MainProxy:onMsgMergeUpdate(...)
	self.view:onMsgMergeUpdate(...)
end
return Activity_9001692_MainProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001663_mainProxy = class("Activity_9001663_mainProxy", baseProxy)
function Activity_9001663_mainProxy:onRegisterEvent()
	print("=======Activity_9001663_mainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE", handler(self, self.onMsgMergeUpdate))
end
function Activity_9001663_mainProxy:onMsgMergeUpdate(...)
	self.view:onMsgMergeUpdate(...)
end
return Activity_9001663_mainProxy

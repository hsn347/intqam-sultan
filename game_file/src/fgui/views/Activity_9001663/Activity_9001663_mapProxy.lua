local baseProxy = require("fgui.base.baseProxy")
local Activity_9001663_mapProxy = class("Activity_9001663_mapProxy", baseProxy)
function Activity_9001663_mapProxy:onRegisterEvent()
	print("=======Activity_9001663_mapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE", handler(self, self.onMsgMergeUpdate))
end
function Activity_9001663_mapProxy:onMsgMergeUpdate(...)
	self.view:onMsgMergeUpdate(...)
end
return Activity_9001663_mapProxy

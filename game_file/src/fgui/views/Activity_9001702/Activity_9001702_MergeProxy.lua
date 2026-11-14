local baseProxy = require("fgui.base.baseProxy")
local Activity_9001702_MergeProxy = class("Activity_9001702_MergeProxy", baseProxy)
function Activity_9001702_MergeProxy:onRegisterEvent()
	print("=======Activity_9001702_MergeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
	SoraDAddMessage(self, "MESSAGE_DROP_ACTIVITY_CURDAY_REFRESH", handler(self, self.onMsgUpdateDropData))
end
function Activity_9001702_MergeProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
function Activity_9001702_MergeProxy:onMsgUpdateDropData(...)
	self.view:onMsgUpdateDropData(...)
end
return Activity_9001702_MergeProxy

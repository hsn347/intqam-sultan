local baseProxy = require("fgui.base.baseProxy")
local Activity_9001702_RewardProxy = class("Activity_9001702_RewardProxy", baseProxy)
function Activity_9001702_RewardProxy:onRegisterEvent()
	print("=======Activity_9001702_RewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Activity_9001702_RewardProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
return Activity_9001702_RewardProxy

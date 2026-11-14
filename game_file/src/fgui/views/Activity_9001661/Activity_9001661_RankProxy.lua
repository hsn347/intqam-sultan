local baseProxy = require("fgui.base.baseProxy")
local Activity_9001661_RankProxy = class("Activity_9001661_RankProxy", baseProxy)
function Activity_9001661_RankProxy:onRegisterEvent()
	print("=======Activity_9001661_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001661_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001661_RankProxy:onMsgUpdateData(target, data)
	self.view:onMsgUpdateData(target, data)
end
return Activity_9001661_RankProxy

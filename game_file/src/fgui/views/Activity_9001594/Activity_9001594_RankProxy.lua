local baseProxy = require("fgui.base.baseProxy")
local Activity_9001594_RankProxy = class("Activity_9001594_RankProxy", baseProxy)
function Activity_9001594_RankProxy:onRegisterEvent()
	print("=======Activity_9001594_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001594_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001594_RankProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001594_RankProxy

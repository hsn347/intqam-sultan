local baseProxy = require("fgui.base.baseProxy")
local Activity_9001719_RankProxy = class("Activity_9001719_RankProxy", baseProxy)
function Activity_9001719_RankProxy:onRegisterEvent()
	print("=======Activity_9001719_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_RANK", handler(self, self.rankMsgBack))
end
function Activity_9001719_RankProxy:rankMsgBack(target, data)
	self.view:rankMsgBack(target, data)
end
return Activity_9001719_RankProxy

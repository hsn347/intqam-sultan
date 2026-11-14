local baseProxy = require("fgui.base.baseProxy")
local Activity_9001676_RankProxy = class("Activity_9001676_RankProxy", baseProxy)
function Activity_9001676_RankProxy:onRegisterEvent()
	print("=======Activity_9001676_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001676_UPDATE", handler(self, self.rankMsgBack))
end
function Activity_9001676_RankProxy:rankMsgBack(target, data)
	if data.msgType == "PlayerSpeedRank" then
		self.view:rankMsgBack(target, data)
	end
end
return Activity_9001676_RankProxy

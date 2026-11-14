local baseProxy = require("fgui.base.baseProxy")
local Activity_9001479_RankProxy = class("Activity_9001479_RankProxy", baseProxy)
function Activity_9001479_RankProxy:onRegisterEvent()
	print("=======Activity_9001479_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_RANK", handler(self, self.onMsgUpdateRank))
end
function Activity_9001479_RankProxy:onMsgUpdateRank(target, event)
	self.view:onMsgUpdateRank(target, event)
end
return Activity_9001479_RankProxy

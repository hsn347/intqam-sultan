local baseProxy = require("fgui.base.baseProxy")
local Activity_9001597_RankProxy = class("Activity_9001597_RankProxy", baseProxy)
function Activity_9001597_RankProxy:onRegisterEvent()
	print("=======Activity_9001597_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001597_RANK", handler(self, self.onMsgUpdateRank))
end
function Activity_9001597_RankProxy:onMsgUpdateRank(target, event)
	print("Activity_9001597_RankProxy:onMsgUpdateRank")
	self.view:onMsgUpdateRank(target, event)
end
return Activity_9001597_RankProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_Common_RankProxy = class("Activity_Common_RankProxy", baseProxy)
function Activity_Common_RankProxy:onRegisterEvent()
	print("=======Activity_Common_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_RANK_UPDATE", handler(self, self.onMsgUpdateRank))
end
function Activity_Common_RankProxy:onMsgUpdateRank(...)
	self.view:onMsgUpdateRank(...)
end
return Activity_Common_RankProxy

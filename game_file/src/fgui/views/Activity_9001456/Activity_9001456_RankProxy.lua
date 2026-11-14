local baseProxy = require("fgui.base.baseProxy")
local Activity_9001456_RankProxy = class("Activity_9001456_RankProxy", baseProxy)
function Activity_9001456_RankProxy:onRegisterEvent()
	print("=======Activity_9001456_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_RANK_UPDATE", handler(self, self.onMsgUpdateRank))
end
function Activity_9001456_RankProxy:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateRank(event.rspdata)
end
return Activity_9001456_RankProxy

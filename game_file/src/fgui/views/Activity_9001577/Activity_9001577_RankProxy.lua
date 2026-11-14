local baseProxy = require("fgui.base.baseProxy")
local Activity_9001577_RankProxy = class("Activity_9001577_RankProxy", baseProxy)
function Activity_9001577_RankProxy:onRegisterEvent()
	print("=======Activity_9001577_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onStageRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onTotalRank))
end
function Activity_9001577_RankProxy:onStageRank(target, data)
	self.view:onStageRank(data.stage)
end
function Activity_9001577_RankProxy:onTotalRank()
	self.view:onTotalRank()
end
return Activity_9001577_RankProxy

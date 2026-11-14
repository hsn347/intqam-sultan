local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionRankProxy = class("NebulaCompetitionRankProxy", baseProxy)
function NebulaCompetitionRankProxy:onRegisterEvent()
	print("=======NebulaCompetitionRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onStageRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onTotalRank))
end
function NebulaCompetitionRankProxy:onStageRank(target, data)
	self.view:onStageRank(data.stage)
end
function NebulaCompetitionRankProxy:onTotalRank()
	self.view:onTotalRank()
end
return NebulaCompetitionRankProxy

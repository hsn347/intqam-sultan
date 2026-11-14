local baseProxy = require("fgui.base.baseProxy")
local NebulaKingRankProxy = class("NebulaKingRankProxy", baseProxy)
function NebulaKingRankProxy:onRegisterEvent()
	print("=======NebulaKingRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onStageRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onTotalRank))
end
function NebulaKingRankProxy:onStageRank(target, data)
	self.view:onStageRank(data.stage)
end
function NebulaKingRankProxy:onTotalRank()
	self.view:onTotalRank()
end
return NebulaKingRankProxy

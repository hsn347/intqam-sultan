local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionHistoryProxy = class("NebulaCompetitionHistoryProxy", baseProxy)
function NebulaCompetitionHistoryProxy:onRegisterEvent()
	print("=======NebulaCompetitionHistoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_HISTORY_RANK", handler(self, self.onHistoryRank))
end
function NebulaCompetitionHistoryProxy:onHistoryRank(target, data)
	self.view:updateRank(data.historyRankInfo)
end
return NebulaCompetitionHistoryProxy

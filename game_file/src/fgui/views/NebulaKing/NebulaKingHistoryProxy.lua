local baseProxy = require("fgui.base.baseProxy")
local NebulaKingHistoryProxy = class("NebulaKingHistoryProxy", baseProxy)
function NebulaKingHistoryProxy:onRegisterEvent()
	print("=======NebulaKingHistoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_HISTORY_RANK", handler(self, self.onHistoryRank))
end
function NebulaKingHistoryProxy:onHistoryRank(target, data)
	self.view:updateRank(data.historyRankInfo)
end
return NebulaKingHistoryProxy

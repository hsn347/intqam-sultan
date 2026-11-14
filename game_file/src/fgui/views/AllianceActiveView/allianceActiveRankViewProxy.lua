local baseProxy = require("fgui.base.baseProxy")
local allianceActiveRankViewProxy = class("allianceActiveRankViewProxy", baseProxy)
function allianceActiveRankViewProxy:onRegisterEvent()
	print("=======allianceActiveRankViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_RANK_UPDATE", handler(self, self.updateRank))
end
function allianceActiveRankViewProxy:updateRank(target, data)
	self.view:updateRank(target, data)
end
return allianceActiveRankViewProxy

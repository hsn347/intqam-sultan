local baseProxy = require("fgui.base.baseProxy")
local allianceDonateRankingsViewProxy = class("allianceDonateRankingsViewProxy", baseProxy)
function allianceDonateRankingsViewProxy:onRegisterEvent()
	print("=======allianceDonateRankingsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_DONATE_RANK_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
end
function allianceDonateRankingsViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
return allianceDonateRankingsViewProxy

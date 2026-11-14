local baseProxy = require("fgui.base.baseProxy")
local allianceHuntRankProxy = class("allianceHuntRankProxy", baseProxy)
function allianceHuntRankProxy:onRegisterEvent()
	print("=======allianceHuntRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_SUCCESS", handler(self, self.msgHuntRankDataSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_FAILED", handler(self, self.msgHuntRankDataFailed))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function allianceHuntRankProxy:msgHuntRankDataSuccess(...)
	self.view:msgHuntRankDataSuccess(...)
end
function allianceHuntRankProxy:msgHuntRankDataFailed(...)
	self.view:msgHuntRankDataFailed(...)
end
function allianceHuntRankProxy:serverMessageGetLordInfo(...)
	self.view:serverMessageGetLordInfo(...)
end
return allianceHuntRankProxy

local baseProxy = require("fgui.base.baseProxy")
local allianceHuntChallengeProxy = class("allianceHuntChallengeProxy", baseProxy)
function allianceHuntChallengeProxy:onRegisterEvent()
	print("=======allianceHuntChallengeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_SUCCESS", handler(self, self.msgHuntRankDataSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_FAILED", handler(self, self.msgHuntRankDataFailed))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function allianceHuntChallengeProxy:msgHuntRankDataSuccess(...)
	self.view:msgHuntRankDataSuccess(...)
end
function allianceHuntChallengeProxy:msgHuntRankDataFailed(...)
	self.view:msgHuntRankDataFailed(...)
end
function allianceHuntChallengeProxy:serverMessageGetLordInfo(...)
	self.view:serverMessageGetLordInfo(...)
end
return allianceHuntChallengeProxy

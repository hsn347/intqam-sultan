local baseProxy = require("fgui.base.baseProxy")
local legendaryKingStarStageRewardProxy = class("legendaryKingStarStageRewardProxy", baseProxy)
function legendaryKingStarStageRewardProxy:onRegisterEvent()
	print("=======legendaryKingStarStageRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_STAGE_REWARD_INFO_BACK", handler(self, self.sMsgRewardInfoBack))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.sMsgTeamUPdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_STAGE_REWARD_KILL_OR_LOSE", handler(self, self.sMsgRewardInfoBack))
end
function legendaryKingStarStageRewardProxy:sMsgRewardInfoBack(target, data)
	dump(data, "legendStageReward:sMsgRewardInfoBack")
	self.view:onMsgRewardInfoBack(target, data)
end
function legendaryKingStarStageRewardProxy:sMsgTeamUPdate(target, data)
	self.view:onMsgTeamUPdate(target, data)
end
return legendaryKingStarStageRewardProxy

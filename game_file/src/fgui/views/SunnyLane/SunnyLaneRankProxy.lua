local baseProxy = require("fgui.base.baseProxy")
local SunnyLaneRankProxy = class("SunnyLaneRankProxy", baseProxy)
function SunnyLaneRankProxy:onRegisterEvent()
	print("=======SunnyLaneRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MONSTER_INVASION_RANK", handler(self, self.onMsgUpdateRank))
end
function SunnyLaneRankProxy:onMsgUpdateRank(target, event)
	self.view:onMsgUpdateRank(target, event)
end
return SunnyLaneRankProxy

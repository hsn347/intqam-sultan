local baseProxy = require("fgui.base.baseProxy")
local SnowmanAllianceRankProxy = class("SnowmanAllianceRankProxy", baseProxy)
function SnowmanAllianceRankProxy:onRegisterEvent()
	print("=======SnowmanAllianceRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_ALLIANCE_RANK", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_RANK_TIME", handler(self, self.refreshTimer))
end
function SnowmanAllianceRankProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function SnowmanAllianceRankProxy:refreshTimer()
	if self.view then
		self.view:refreshTimer(data)
	end
end
return SnowmanAllianceRankProxy

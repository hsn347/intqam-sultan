local baseProxy = require("fgui.base.baseProxy")
local Activity_9001738_RankProxy = class("Activity_9001738_RankProxy", baseProxy)
function Activity_9001738_RankProxy:onRegisterEvent()
	print("=======Activity_9001738_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_RANKING", handler(self, self.onRankUpdate))
end
function Activity_9001738_RankProxy:onRankUpdate(target, data)
	if self.view and self.view.onRankBack then
		self.view:onRankBack(data)
	end
end
return Activity_9001738_RankProxy

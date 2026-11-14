local baseProxy = require("fgui.base.baseProxy")
local Activity_9001737_RankProxy = class("Activity_9001737_RankProxy", baseProxy)
function Activity_9001737_RankProxy:onRegisterEvent()
	print("=======Activity_9001737_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001737_UPDATE", handler(self, self.updateRankView))
end
function Activity_9001737_RankProxy:updateRankView(target, data)
	print("=======Activity_9001737_RankProxy:initAssign")
	self.view:updateRankView(target, data)
end
return Activity_9001737_RankProxy

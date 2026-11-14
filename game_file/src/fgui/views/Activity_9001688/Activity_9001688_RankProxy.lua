local baseProxy = require("fgui.base.baseProxy")
local Activity_9001688_RankProxy = class("Activity_9001688_RankProxy", baseProxy)
function Activity_9001688_RankProxy:onRegisterEvent()
	print("=======Activity_9001688_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001688_UPDATE", handler(self, self.rankBack))
end
function Activity_9001688_RankProxy:rankBack(target, data)
	if data and data.key == "rank" then
		self.view:rankBack(target, data)
	end
end
return Activity_9001688_RankProxy

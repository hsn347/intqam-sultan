local baseProxy = require("fgui.base.baseProxy")
local Activity_9001666_AchievementProxy = class("Activity_9001666_AchievementProxy", baseProxy)
function Activity_9001666_AchievementProxy:onRegisterEvent()
	print("=======Activity_9001666_AchievementProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001666_UPDATE", handler(self, self.updateView))
end
function Activity_9001666_AchievementProxy:updateView()
	self.view:updateView()
end
return Activity_9001666_AchievementProxy

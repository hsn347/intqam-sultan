local baseProxy = require("fgui.base.baseProxy")
local Activity_9001615_RewardPoolUpProxy = class("Activity_9001615_RewardPoolUpProxy", baseProxy)
function Activity_9001615_RewardPoolUpProxy:onRegisterEvent()
	print("=======Activity_9001615_RewardPoolUpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_DATA", function(target, data)
		self.view:reInit()
	end)
end
return Activity_9001615_RewardPoolUpProxy

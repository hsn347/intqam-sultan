local baseProxy = require("fgui.base.baseProxy")
local Activity_9001628_RewardProxy = class("Activity_9001628_RewardProxy", baseProxy)
function Activity_9001628_RewardProxy:onRegisterEvent()
	print("=======Activity_9001628_RewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:updateView()
	end)
end
return Activity_9001628_RewardProxy

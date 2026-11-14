local baseProxy = require("fgui.base.baseProxy")
local Activity_9001157_RewardProxy = class("Activity_9001157_RewardProxy", baseProxy)
function Activity_9001157_RewardProxy:onRegisterEvent()
	print("=======Activity_9001157_RewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_OUTSTANDINGS_RECEIVI_REWARD_BACK", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:removeFromParent()
	end)
end
return Activity_9001157_RewardProxy

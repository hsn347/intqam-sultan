local baseProxy = require("fgui.base.baseProxy")
local PickupStarsAgainRewardProxy = class("PickupStarsAgainRewardProxy", baseProxy)
function PickupStarsAgainRewardProxy:onRegisterEvent()
	print("=======PickupStarsAgainRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_GET_REWARD", handler(self, self.onGetReward))
end
function PickupStarsAgainRewardProxy:onGetReward()
	self.view:close()
end
return PickupStarsAgainRewardProxy

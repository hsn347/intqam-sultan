local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeAccuRewardProxy = class("StarEnergyCubeAccuRewardProxy", baseProxy)
function StarEnergyCubeAccuRewardProxy:onRegisterEvent()
	print("=======StarEnergyCubeAccuRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STAR_ENERGY_CUBE", handler(self, self.refreshView))
end
function StarEnergyCubeAccuRewardProxy:refreshView(target, data)
	if self.view and data and data.subMsg == "stageReward" then
		self.view:showReward(data)
	end
end
return StarEnergyCubeAccuRewardProxy

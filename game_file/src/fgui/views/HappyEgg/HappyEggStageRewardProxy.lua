local baseProxy = require("fgui.base.baseProxy")
local HappyEggStageRewardProxy = class("HappyEggStageRewardProxy", baseProxy)
function HappyEggStageRewardProxy:onRegisterEvent()
	print("=======HappyEggStageRewardProxy:onRegisterEvent")
end
return HappyEggStageRewardProxy

local baseProxy = require("fgui.base.baseProxy")
local DesertMiningStageRewardProxy = class("DesertMiningStageRewardProxy", baseProxy)
function DesertMiningStageRewardProxy:onRegisterEvent()
	print("=======DesertMiningStageRewardProxy:onRegisterEvent")
end
return DesertMiningStageRewardProxy

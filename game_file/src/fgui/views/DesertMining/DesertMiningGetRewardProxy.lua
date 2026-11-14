local baseProxy = require("fgui.base.baseProxy")
local DesertMiningGetRewardProxy = class("DesertMiningGetRewardProxy", baseProxy)
function DesertMiningGetRewardProxy:onRegisterEvent()
	print("=======DesertMiningGetRewardProxy:onRegisterEvent")
end
return DesertMiningGetRewardProxy

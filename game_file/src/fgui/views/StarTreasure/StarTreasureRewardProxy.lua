local baseProxy = require("fgui.base.baseProxy")
local StarTreasureRewardProxy = class("StarTreasureRewardProxy", baseProxy)
function StarTreasureRewardProxy:onRegisterEvent()
	print("=======StarTreasureRewardProxy:onRegisterEvent")
end
return StarTreasureRewardProxy

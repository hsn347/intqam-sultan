local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureRewardProxy = class("NebulaTreasureRewardProxy", baseProxy)
function NebulaTreasureRewardProxy:onRegisterEvent()
	print("=======NebulaTreasureRewardProxy:onRegisterEvent")
end
return NebulaTreasureRewardProxy

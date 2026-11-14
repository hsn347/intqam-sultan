local baseProxy = require("fgui.base.baseProxy")
local AtlantisTreasureRewardProxy = class("AtlantisTreasureRewardProxy", baseProxy)
function AtlantisTreasureRewardProxy:onRegisterEvent()
	print("=======AtlantisTreasureRewardProxy:onRegisterEvent")
end
return AtlantisTreasureRewardProxy

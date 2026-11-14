local baseProxy = require("fgui.base.baseProxy")
local FruitCultivateRewardProxy = class("FruitCultivateRewardProxy", baseProxy)
function FruitCultivateRewardProxy:onRegisterEvent()
	print("=======FruitCultivateRewardProxy:onRegisterEvent")
end
return FruitCultivateRewardProxy

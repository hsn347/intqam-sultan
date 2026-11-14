local baseProxy = require("fgui.base.baseProxy")
local MagicLampMaigcPowerRewardProxy = class("MagicLampMaigcPowerRewardProxy", baseProxy)
function MagicLampMaigcPowerRewardProxy:onRegisterEvent()
	print("=======MagicLampMaigcPowerRewardProxy:onRegisterEvent")
end
return MagicLampMaigcPowerRewardProxy

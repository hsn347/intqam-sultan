local baseProxy = require("fgui.base.baseProxy")
local MagicLampMaigcPowerGainProxy = class("MagicLampMaigcPowerGainProxy", baseProxy)
function MagicLampMaigcPowerGainProxy:onRegisterEvent()
	print("=======MagicLampMaigcPowerGainProxy:onRegisterEvent")
end
return MagicLampMaigcPowerGainProxy

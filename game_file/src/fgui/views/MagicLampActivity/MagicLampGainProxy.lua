local baseProxy = require("fgui.base.baseProxy")
local MagicLampGainProxy = class("MagicLampGainProxy", baseProxy)
function MagicLampGainProxy:onRegisterEvent()
	print("=======MagicLampGainProxy:onRegisterEvent")
end
return MagicLampGainProxy

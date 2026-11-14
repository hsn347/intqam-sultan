local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchGetProxy = class("MagicLampHatchGetProxy", baseProxy)
function MagicLampHatchGetProxy:onRegisterEvent()
	print("=======MagicLampHatchGetProxy:onRegisterEvent")
end
return MagicLampHatchGetProxy

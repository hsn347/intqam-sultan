local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchAwardProxy = class("MagicLampHatchAwardProxy", baseProxy)
function MagicLampHatchAwardProxy:onRegisterEvent()
	print("=======MagicLampHatchAwardProxy:onRegisterEvent")
end
return MagicLampHatchAwardProxy

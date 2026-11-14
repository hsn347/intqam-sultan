local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchChooseProxy = class("MagicLampHatchChooseProxy", baseProxy)
function MagicLampHatchChooseProxy:onRegisterEvent()
	print("=======MagicLampHatchChooseProxy:onRegisterEvent")
end
return MagicLampHatchChooseProxy

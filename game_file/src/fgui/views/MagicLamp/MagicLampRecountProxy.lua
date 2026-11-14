local baseProxy = require("fgui.base.baseProxy")
local MagicLampRecountProxy = class("MagicLampRecountProxy", baseProxy)
function MagicLampRecountProxy:onRegisterEvent()
	print("=======MagicLampRecountProxy:onRegisterEvent")
end
return MagicLampRecountProxy

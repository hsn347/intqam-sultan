local baseProxy = require("fgui.base.baseProxy")
local MagicLampMailRecountProxy = class("MagicLampMailRecountProxy", baseProxy)
function MagicLampMailRecountProxy:onRegisterEvent()
	print("=======MagicLampMailRecountProxy:onRegisterEvent")
end
return MagicLampMailRecountProxy

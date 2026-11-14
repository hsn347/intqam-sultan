local baseProxy = require("fgui.base.baseProxy")
local MagicLampLogProxy = class("MagicLampLogProxy", baseProxy)
function MagicLampLogProxy:onRegisterEvent()
	print("=======MagicLampLogProxy:onRegisterEvent")
end
return MagicLampLogProxy

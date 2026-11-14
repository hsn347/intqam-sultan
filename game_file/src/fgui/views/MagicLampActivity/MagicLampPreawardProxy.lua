local baseProxy = require("fgui.base.baseProxy")
local MagicLampPreawardProxy = class("MagicLampPreawardProxy", baseProxy)
function MagicLampPreawardProxy:onRegisterEvent()
	print("=======MagicLampPreawardProxy:onRegisterEvent")
end
return MagicLampPreawardProxy

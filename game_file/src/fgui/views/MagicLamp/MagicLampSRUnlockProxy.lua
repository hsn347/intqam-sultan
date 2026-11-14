local baseProxy = require("fgui.base.baseProxy")
local MagicLampSRUnlockProxy = class("MagicLampSRUnlockProxy", baseProxy)
function MagicLampSRUnlockProxy:onRegisterEvent()
	print("=======MagicLampSRUnlockProxy:onRegisterEvent")
end
return MagicLampSRUnlockProxy

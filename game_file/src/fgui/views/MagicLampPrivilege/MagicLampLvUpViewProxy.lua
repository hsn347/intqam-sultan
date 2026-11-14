local baseProxy = require("fgui.base.baseProxy")
local MagicLampLvUpViewProxy = class("MagicLampLvUpViewProxy", baseProxy)
function MagicLampLvUpViewProxy:onRegisterEvent()
	print("=======MagicLampLvUpViewProxy:onRegisterEvent")
end
return MagicLampLvUpViewProxy

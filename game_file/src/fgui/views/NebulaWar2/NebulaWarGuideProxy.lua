local baseProxy = require("fgui.base.baseProxy")
local NebulaWarGuideProxy = class("NebulaWarGuideProxy", baseProxy)
function NebulaWarGuideProxy:onRegisterEvent()
	print("=======NebulaWarGuideProxy:onRegisterEvent")
end
return NebulaWarGuideProxy

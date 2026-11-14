local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarFAQProxy = class("NebulaAllStarFAQProxy", baseProxy)
function NebulaAllStarFAQProxy:onRegisterEvent()
	print("=======NebulaAllStarFAQProxy:onRegisterEvent")
end
return NebulaAllStarFAQProxy

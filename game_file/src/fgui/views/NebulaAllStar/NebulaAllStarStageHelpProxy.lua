local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarStageHelpProxy = class("NebulaAllStarStageHelpProxy", baseProxy)
function NebulaAllStarStageHelpProxy:onRegisterEvent()
	print("=======NebulaAllStarStageHelpProxy:onRegisterEvent")
end
return NebulaAllStarStageHelpProxy

local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarSetArmyProxy = class("NebulaAllStarSetArmyProxy", baseProxy)
function NebulaAllStarSetArmyProxy:onRegisterEvent()
	print("=======NebulaAllStarSetArmyProxy:onRegisterEvent")
end
return NebulaAllStarSetArmyProxy

local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeArmyInfoProxy = class("StarEnergyCubeArmyInfoProxy", baseProxy)
function StarEnergyCubeArmyInfoProxy:onRegisterEvent()
	print("=======StarEnergyCubeArmyInfoProxy:onRegisterEvent")
end
return StarEnergyCubeArmyInfoProxy

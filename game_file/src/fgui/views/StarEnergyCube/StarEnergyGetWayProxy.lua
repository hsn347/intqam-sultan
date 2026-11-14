local baseProxy = require("fgui.base.baseProxy")
local StarEnergyGetWayProxy = class("StarEnergyGetWayProxy", baseProxy)
function StarEnergyGetWayProxy:onRegisterEvent()
	print("=======StarEnergyGetWayProxy:onRegisterEvent")
end
return StarEnergyGetWayProxy

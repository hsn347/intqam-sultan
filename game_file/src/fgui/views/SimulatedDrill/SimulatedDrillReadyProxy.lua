local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillReadyProxy = class("SimulatedDrillReadyProxy", baseProxy)
function SimulatedDrillReadyProxy:onRegisterEvent()
	print("=======SimulatedDrillReadyProxy:onRegisterEvent")
end
return SimulatedDrillReadyProxy

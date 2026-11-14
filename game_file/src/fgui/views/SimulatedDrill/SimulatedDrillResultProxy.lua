local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillResultProxy = class("SimulatedDrillResultProxy", baseProxy)
function SimulatedDrillResultProxy:onRegisterEvent()
	print("=======SimulatedDrillResultProxy:onRegisterEvent")
end
return SimulatedDrillResultProxy

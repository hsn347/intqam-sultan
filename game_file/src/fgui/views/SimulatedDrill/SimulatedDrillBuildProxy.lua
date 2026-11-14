local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillBuildProxy = class("SimulatedDrillBuildProxy", baseProxy)
function SimulatedDrillBuildProxy:onRegisterEvent()
	print("=======SimulatedDrillBuildProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_BUILD_UPDATE", handler(self, self.onMsgBuildUpdate))
end
function SimulatedDrillBuildProxy:onMsgBuildUpdate(...)
	self.view:onMsgBuildUpdate(...)
end
return SimulatedDrillBuildProxy

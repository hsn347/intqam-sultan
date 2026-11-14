local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillCampProxy = class("SimulatedDrillCampProxy", baseProxy)
function SimulatedDrillCampProxy:onRegisterEvent()
	print("=======SimulatedDrillCampProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_ROOM_DATA", handler(self, self.onMsgUpdateRoomData))
end
function SimulatedDrillCampProxy:onMsgUpdateRoomData(...)
	self.view:onMsgUpdateRoomData(...)
end
return SimulatedDrillCampProxy

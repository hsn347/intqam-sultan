local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillRoomProxy = class("SimulatedDrillRoomProxy", baseProxy)
function SimulatedDrillRoomProxy:onRegisterEvent()
	print("=======SimulatedDrillRoomProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_ROOM_DATA", handler(self, self.onMsgUpdateRoomData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.onMsgUpdateTeamMsg))
end
function SimulatedDrillRoomProxy:onMsgUpdateRoomData(...)
	self.view:onMsgUpdateRoomData(...)
end
function SimulatedDrillRoomProxy:onMsgUpdateTeamMsg(...)
	self.view:onMsgUpdateTeamMsg(...)
end
return SimulatedDrillRoomProxy

local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillRoomListProxy = class("SimulatedDrillRoomListProxy", baseProxy)
function SimulatedDrillRoomListProxy:onRegisterEvent()
	print("=======SimulatedDrillRoomListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_ROOM_LIST", handler(self, self.onMsgUpdateRoomList))
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_ROOM_DATA", handler(self, self.onMsgUpdateRoomData))
end
function SimulatedDrillRoomListProxy:onMsgUpdateRoomList(...)
	self.view:onMsgUpdateRoomList(...)
end
function SimulatedDrillRoomListProxy:onMsgUpdateRoomData(...)
	self.view:onMsgUpdateRoomData(...)
end
return SimulatedDrillRoomListProxy

local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillJoinRoomProxy = class("SimulatedDrillJoinRoomProxy", baseProxy)
function SimulatedDrillJoinRoomProxy:onRegisterEvent()
	print("=======SimulatedDrillJoinRoomProxy:onRegisterEvent")
end
return SimulatedDrillJoinRoomProxy

local baseProxy = require("fgui.base.baseProxy")
local SimulatedDrillCreateRoomProxy = class("SimulatedDrillCreateRoomProxy", baseProxy)
function SimulatedDrillCreateRoomProxy:onRegisterEvent()
	print("=======SimulatedDrillCreateRoomProxy:onRegisterEvent")
end
return SimulatedDrillCreateRoomProxy

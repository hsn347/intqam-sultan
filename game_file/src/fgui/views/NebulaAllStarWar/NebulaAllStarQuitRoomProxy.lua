local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarQuitRoomProxy = class("NebulaAllStarQuitRoomProxy", baseProxy)
function NebulaAllStarQuitRoomProxy:onRegisterEvent()
	print("=======NebulaAllStarQuitRoomProxy:onRegisterEvent")
end
return NebulaAllStarQuitRoomProxy

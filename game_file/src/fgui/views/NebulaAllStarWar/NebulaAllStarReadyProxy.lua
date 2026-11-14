local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarReadyProxy = class("NebulaAllStarReadyProxy", baseProxy)
function NebulaAllStarReadyProxy:onRegisterEvent()
	print("=======NebulaAllStarReadyProxy:onRegisterEvent")
end
return NebulaAllStarReadyProxy

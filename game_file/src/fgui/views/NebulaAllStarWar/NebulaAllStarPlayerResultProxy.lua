local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarPlayerResultProxy = class("NebulaAllStarPlayerResultProxy", baseProxy)
function NebulaAllStarPlayerResultProxy:onRegisterEvent()
	print("=======NebulaAllStarPlayerResultProxy:onRegisterEvent")
end
return NebulaAllStarPlayerResultProxy

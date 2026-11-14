local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarRewardProxy = class("NebulaAllStarRewardProxy", baseProxy)
function NebulaAllStarRewardProxy:onRegisterEvent()
	print("=======NebulaAllStarRewardProxy:onRegisterEvent")
end
return NebulaAllStarRewardProxy

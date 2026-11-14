local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarBarrageSettingProxy = class("NebulaAllStarBarrageSettingProxy", baseProxy)
function NebulaAllStarBarrageSettingProxy:onRegisterEvent()
	print("=======NebulaAllStarBarrageSettingProxy:onRegisterEvent")
end
return NebulaAllStarBarrageSettingProxy

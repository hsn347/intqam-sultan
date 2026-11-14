local baseProxy = require("fgui.base.baseProxy")
local NebulaRegionSwitchProxy = class("NebulaRegionSwitchProxy", baseProxy)
function NebulaRegionSwitchProxy:onRegisterEvent()
	print("=======NebulaRegionSwitchProxy:onRegisterEvent")
end
return NebulaRegionSwitchProxy

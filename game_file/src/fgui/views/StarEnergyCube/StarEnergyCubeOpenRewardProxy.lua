local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeOpenRewardProxy = class("StarEnergyCubeOpenRewardProxy", baseProxy)
function StarEnergyCubeOpenRewardProxy:onRegisterEvent()
	print("=======StarEnergyCubeOpenRewardProxy:onRegisterEvent")
end
return StarEnergyCubeOpenRewardProxy

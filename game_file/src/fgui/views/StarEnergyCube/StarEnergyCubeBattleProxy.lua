local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeSettleProxy = class("StarEnergyCubeSettleProxy", baseProxy)
function StarEnergyCubeSettleProxy:onRegisterEvent()
	print("=======StarEnergyCubeSettleProxy:onRegisterEvent")
end
return StarEnergyCubeSettleProxy

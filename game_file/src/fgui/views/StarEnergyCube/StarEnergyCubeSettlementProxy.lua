local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeSettlementProxy = class("StarEnergyCubeSettlementProxy", baseProxy)
function StarEnergyCubeSettlementProxy:onRegisterEvent()
	print("=======StarEnergyCubeSettlementProxy:onRegisterEvent")
end
return StarEnergyCubeSettlementProxy

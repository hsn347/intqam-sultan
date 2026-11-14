local baseProxy = require("fgui.base.baseProxy")
local soldiersQuickTrainProxy = class("soldiersQuickTrainProxy", baseProxy)
function soldiersQuickTrainProxy:onRegisterEvent()
	print("=======soldiersQuickTrainProxy:onRegisterEvent")
end
return soldiersQuickTrainProxy

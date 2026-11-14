local baseProxy = require("fgui.base.baseProxy")
local soldiersPromoteTSuccessProxy = class("soldiersPromoteTSuccessProxy", baseProxy)
function soldiersPromoteTSuccessProxy:onRegisterEvent()
	print("=======soldiersPromoteTSuccessProxy:onRegisterEvent")
end
return soldiersPromoteTSuccessProxy

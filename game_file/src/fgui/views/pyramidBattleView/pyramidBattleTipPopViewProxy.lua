local baseProxy = require("fgui.base.baseProxy")
local pyramidBattleTipPopViewProxy = class("pyramidBattleTipPopViewProxy", baseProxy)
function pyramidBattleTipPopViewProxy:onRegisterEvent()
	print("=======pyramidBattleTipPopViewProxy:onRegisterEvent")
end
return pyramidBattleTipPopViewProxy

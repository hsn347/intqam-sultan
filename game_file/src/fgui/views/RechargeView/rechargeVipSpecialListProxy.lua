local baseProxy = require("fgui.base.baseProxy")
local rechargeVipSpecialListProxy = class("rechargeVipSpecialListProxy", baseProxy)
function rechargeVipSpecialListProxy:onRegisterEvent()
	print("=======rechargeVipSpecialListProxy:onRegisterEvent")
end
return rechargeVipSpecialListProxy

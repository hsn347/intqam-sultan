local baseProxy = require("fgui.base.baseProxy")
local rechargeVipLimitBoxProxy = class("rechargeVipLimitBoxProxy", baseProxy)
function rechargeVipLimitBoxProxy:onRegisterEvent()
	print("=======rechargeVipLimitBoxProxy:onRegisterEvent")
end
return rechargeVipLimitBoxProxy

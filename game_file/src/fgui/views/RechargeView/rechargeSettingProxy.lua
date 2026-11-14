local baseProxy = require("fgui.base.baseProxy")
local rechargeSettingProxy = class("rechargeSettingProxy", baseProxy)
function rechargeSettingProxy:onRegisterEvent()
	print("=======rechargeSettingProxy:onRegisterEvent")
end
return rechargeSettingProxy

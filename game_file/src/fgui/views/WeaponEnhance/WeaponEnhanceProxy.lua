local baseProxy = require("fgui.base.baseProxy")
local WeaponEnhanceProxy = class("WeaponEnhanceProxy", baseProxy)
function WeaponEnhanceProxy:onRegisterEvent()
	print("=======WeaponEnhanceProxy:onRegisterEvent")
end
return WeaponEnhanceProxy

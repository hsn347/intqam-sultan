local baseProxy = require("fgui.base.baseProxy")
local WeaponEnhancePopupProxy = class("WeaponEnhancePopupProxy", baseProxy)
function WeaponEnhancePopupProxy:onRegisterEvent()
	print("=======WeaponEnhancePopupProxy:onRegisterEvent")
end
return WeaponEnhancePopupProxy

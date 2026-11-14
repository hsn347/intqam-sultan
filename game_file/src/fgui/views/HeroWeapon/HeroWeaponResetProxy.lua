local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponResetProxy = class("HeroWeaponResetProxy", baseProxy)
function HeroWeaponResetProxy:onRegisterEvent()
	print("=======HeroWeaponResetProxy:onRegisterEvent")
end
return HeroWeaponResetProxy

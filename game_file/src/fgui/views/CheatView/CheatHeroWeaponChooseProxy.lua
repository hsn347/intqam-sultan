local baseProxy = require("fgui.base.baseProxy")
local CheatHeroWeaponChooseProxy = class("CheatHeroWeaponChooseProxy", baseProxy)
function CheatHeroWeaponChooseProxy:onRegisterEvent()
	print("=======CheatHeroWeaponChooseProxy:onRegisterEvent")
end
return CheatHeroWeaponChooseProxy

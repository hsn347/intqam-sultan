local baseProxy = require("fgui.base.baseProxy")
local HeroWeaponHeroSelectProxy = class("HeroWeaponHeroSelectProxy", baseProxy)
function HeroWeaponHeroSelectProxy:onRegisterEvent()
	print("=======HeroWeaponHeroSelectProxy:onRegisterEvent")
end
return HeroWeaponHeroSelectProxy

local baseProxy = require("fgui.base.baseProxy")
local HeroSkinPopProxy = class("HeroSkinPopProxy", baseProxy)
function HeroSkinPopProxy:onRegisterEvent()
	print("=======HeroSkinPopProxy:onRegisterEvent")
end
return HeroSkinPopProxy

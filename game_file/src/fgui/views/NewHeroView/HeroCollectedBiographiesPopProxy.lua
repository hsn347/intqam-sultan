local baseProxy = require("fgui.base.baseProxy")
local HeroCollectedBiographiesPopProxy = class("HeroCollectedBiographiesPopProxy", baseProxy)
function HeroCollectedBiographiesPopProxy:onRegisterEvent()
	print("=======HeroCollectedBiographiesPopProxy:onRegisterEvent")
end
return HeroCollectedBiographiesPopProxy

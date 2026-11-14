local baseProxy = require("fgui.base.baseProxy")
local HeroAttributeProxy = class("HeroAttributeProxy", baseProxy)
function HeroAttributeProxy:onRegisterEvent()
	print("=======HeroAttributeProxy:onRegisterEvent")
end
return HeroAttributeProxy

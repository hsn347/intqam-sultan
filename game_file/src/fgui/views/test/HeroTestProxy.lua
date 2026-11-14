local baseProxy = require("fgui.base.baseProxy")
local HeroTestProxy = class("HeroTestProxy", baseProxy)
function HeroTestProxy:onRegisterEvent()
	print("=======HeroTestProxy:onRegisterEvent")
end
return HeroTestProxy

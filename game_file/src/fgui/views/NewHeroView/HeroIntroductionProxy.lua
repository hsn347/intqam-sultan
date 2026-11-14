local baseProxy = require("fgui.base.baseProxy")
local HeroIntroductionProxy = class("HeroIntroductionProxy", baseProxy)
function HeroIntroductionProxy:onRegisterEvent()
	print("=======HeroIntroductionProxy:onRegisterEvent")
end
return HeroIntroductionProxy

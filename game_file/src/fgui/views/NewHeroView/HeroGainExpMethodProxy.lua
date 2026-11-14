local baseProxy = require("fgui.base.baseProxy")
local HeroGainExpMethodProxy = class("HeroGainExpMethodProxy", baseProxy)
function HeroGainExpMethodProxy:onRegisterEvent()
	print("=======HeroGainExpMethodProxy:onRegisterEvent")
end
return HeroGainExpMethodProxy

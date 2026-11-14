local baseProxy = require("fgui.base.baseProxy")
local HeroTaskSelectPopProxy = class("HeroTaskSelectPopProxy", baseProxy)
function HeroTaskSelectPopProxy:onRegisterEvent()
	print("=======HeroTaskSelectPopProxy:onRegisterEvent")
end
return HeroTaskSelectPopProxy

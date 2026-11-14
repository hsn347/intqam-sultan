local baseProxy = require("fgui.base.baseProxy")
local HeroEscapeBoxProxy = class("HeroEscapeBoxProxy", baseProxy)
function HeroEscapeBoxProxy:onRegisterEvent()
	print("=======HeroEscapeBoxProxy:onRegisterEvent")
end
return HeroEscapeBoxProxy

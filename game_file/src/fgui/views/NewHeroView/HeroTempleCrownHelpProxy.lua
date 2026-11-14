local baseProxy = require("fgui.base.baseProxy")
local HeroTempleCrownHelpProxy = class("HeroTempleCrownHelpProxy", baseProxy)
function HeroTempleCrownHelpProxy:onRegisterEvent()
	print("=======HeroTempleCrownHelpProxy:onRegisterEvent")
end
return HeroTempleCrownHelpProxy

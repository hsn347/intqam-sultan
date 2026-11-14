local baseProxy = require("fgui.base.baseProxy")
local HeroTempleMainProxy = class("HeroTempleMainProxy", baseProxy)
function HeroTempleMainProxy:onRegisterEvent()
	print("=======HeroTempleMainProxy:onRegisterEvent")
end
return HeroTempleMainProxy

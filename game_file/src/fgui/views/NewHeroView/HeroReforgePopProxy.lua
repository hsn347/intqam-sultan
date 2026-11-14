local baseProxy = require("fgui.base.baseProxy")
local HeroReforgePopProxy = class("HeroReforgePopProxy", baseProxy)
function HeroReforgePopProxy:onRegisterEvent()
	print("=======HeroReforgePopProxy:onRegisterEvent")
end
return HeroReforgePopProxy

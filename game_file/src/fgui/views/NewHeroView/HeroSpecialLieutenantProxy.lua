local baseProxy = require("fgui.base.baseProxy")
local HeroSpecialLieutenantProxy = class("HeroSpecialLieutenantProxy", baseProxy)
function HeroSpecialLieutenantProxy:onRegisterEvent()
	print("=======HeroSpecialLieutenantProxy:onRegisterEvent")
end
return HeroSpecialLieutenantProxy

local baseProxy = require("fgui.base.baseProxy")
local HappyEggPopProxy = class("HappyEggPopProxy", baseProxy)
function HappyEggPopProxy:onRegisterEvent()
	print("=======HappyEggPopProxy:onRegisterEvent")
end
return HappyEggPopProxy

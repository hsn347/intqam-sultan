local baseProxy = require("fgui.base.baseProxy")
local HeroJailExecuteProxy = class("HeroJailExecuteProxy", baseProxy)
function HeroJailExecuteProxy:onRegisterEvent()
	print("=======HeroJailExecuteProxy:onRegisterEvent")
end
return HeroJailExecuteProxy

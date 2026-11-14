local baseProxy = require("fgui.base.baseProxy")
local HeroDressGainProxy = class("HeroDressGainProxy", baseProxy)
function HeroDressGainProxy:onRegisterEvent()
	print("=======HeroDressGainProxy:onRegisterEvent")
end
return HeroDressGainProxy

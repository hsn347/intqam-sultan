local baseProxy = require("fgui.base.baseProxy")
local HeroPaeanRewardProxy = class("HeroPaeanRewardProxy", baseProxy)
function HeroPaeanRewardProxy:onRegisterEvent()
	print("=======HeroPaeanRewardProxy:onRegisterEvent")
end
return HeroPaeanRewardProxy

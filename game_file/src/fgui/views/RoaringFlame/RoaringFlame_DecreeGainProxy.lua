local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_DecreeGainProxy = class("RoaringFlame_DecreeGainProxy", baseProxy)
function RoaringFlame_DecreeGainProxy:onRegisterEvent()
	print("=======RoaringFlame_DecreeGainProxy:onRegisterEvent")
end
return RoaringFlame_DecreeGainProxy

local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_TechDetailProxy = class("RoaringFlame_TechDetailProxy", baseProxy)
function RoaringFlame_TechDetailProxy:onRegisterEvent()
	print("=======RoaringFlame_TechDetailProxy:onRegisterEvent")
end
return RoaringFlame_TechDetailProxy

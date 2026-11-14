local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_MVPProxy = class("RoaringFlameWar_MVPProxy", baseProxy)
function RoaringFlameWar_MVPProxy:onRegisterEvent()
	print("=======RoaringFlameWar_MVPProxy:onRegisterEvent")
end
return RoaringFlameWar_MVPProxy

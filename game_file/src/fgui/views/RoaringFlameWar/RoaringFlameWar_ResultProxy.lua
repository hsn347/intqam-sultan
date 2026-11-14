local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_ResultProxy = class("RoaringFlameWar_ResultProxy", baseProxy)
function RoaringFlameWar_ResultProxy:onRegisterEvent()
	print("=======RoaringFlameWar_ResultProxy:onRegisterEvent")
end
return RoaringFlameWar_ResultProxy

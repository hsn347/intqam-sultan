local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_BuildProxy = class("RoaringFlameWar_BuildProxy", baseProxy)
function RoaringFlameWar_BuildProxy:onRegisterEvent()
	print("=======RoaringFlameWar_BuildProxy:onRegisterEvent")
end
return RoaringFlameWar_BuildProxy

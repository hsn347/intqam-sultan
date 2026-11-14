local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_CollectProxy = class("RoaringFlameWar_CollectProxy", baseProxy)
function RoaringFlameWar_CollectProxy:onRegisterEvent()
	print("=======RoaringFlameWar_CollectProxy:onRegisterEvent")
end
return RoaringFlameWar_CollectProxy

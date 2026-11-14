local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_FightBuildProxy = class("RoaringFlameWar_FightBuildProxy", baseProxy)
function RoaringFlameWar_FightBuildProxy:onRegisterEvent()
	print("=======RoaringFlameWar_FightBuildProxy:onRegisterEvent")
end
return RoaringFlameWar_FightBuildProxy

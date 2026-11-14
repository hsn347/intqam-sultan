local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_RankInfoProxy = class("RoaringFlame_RankInfoProxy", baseProxy)
function RoaringFlame_RankInfoProxy:onRegisterEvent()
	print("=======RoaringFlame_RankInfoProxy:onRegisterEvent")
end
return RoaringFlame_RankInfoProxy

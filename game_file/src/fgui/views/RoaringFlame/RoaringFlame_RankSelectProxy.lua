local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_RankSelectProxy = class("RoaringFlame_RankSelectProxy", baseProxy)
function RoaringFlame_RankSelectProxy:onRegisterEvent()
	print("=======RoaringFlame_RankSelectProxy:onRegisterEvent")
end
return RoaringFlame_RankSelectProxy

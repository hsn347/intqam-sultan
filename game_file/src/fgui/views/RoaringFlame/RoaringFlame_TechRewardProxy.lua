local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_TechRewardProxy = class("RoaringFlame_TechRewardProxy", baseProxy)
function RoaringFlame_TechRewardProxy:onRegisterEvent()
	print("=======RoaringFlame_TechRewardProxy:onRegisterEvent")
end
return RoaringFlame_TechRewardProxy

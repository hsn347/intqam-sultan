local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_RewardViewProxy = class("RoaringFlame_RewardViewProxy", baseProxy)
function RoaringFlame_RewardViewProxy:onRegisterEvent()
	print("=======RoaringFlame_RewardViewProxy:onRegisterEvent")
end
return RoaringFlame_RewardViewProxy

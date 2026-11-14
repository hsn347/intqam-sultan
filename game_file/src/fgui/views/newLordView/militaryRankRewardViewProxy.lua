local baseProxy = require("fgui.base.baseProxy")
local militaryRankRewardViewProxy = class("militaryRankRewardViewProxy", baseProxy)
function militaryRankRewardViewProxy:onRegisterEvent()
	print("=======militaryRankRewardViewProxy:onRegisterEvent")
end
return militaryRankRewardViewProxy

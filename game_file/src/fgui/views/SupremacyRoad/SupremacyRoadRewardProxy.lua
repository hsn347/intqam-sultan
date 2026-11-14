local baseProxy = require("fgui.base.baseProxy")
local SupremacyRoadRewardProxy = class("SupremacyRoadRewardProxy", baseProxy)
function SupremacyRoadRewardProxy:onRegisterEvent()
	print("=======SupremacyRoadRewardProxy:onRegisterEvent")
end
return SupremacyRoadRewardProxy

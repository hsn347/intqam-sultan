local baseProxy = require("fgui.base.baseProxy")
local CaveExploreRewardProxy = class("CaveExploreRewardProxy", baseProxy)
function CaveExploreRewardProxy:onRegisterEvent()
	print("=======CaveExploreRewardProxy:onRegisterEvent")
end
return CaveExploreRewardProxy

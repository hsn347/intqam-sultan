local baseProxy = require("fgui.base.baseProxy")
local HeroJourneyRewardProxy = class("HeroJourneyRewardProxy", baseProxy)
function HeroJourneyRewardProxy:onRegisterEvent()
	print("=======HeroJourneyRewardProxy:onRegisterEvent")
end
return HeroJourneyRewardProxy

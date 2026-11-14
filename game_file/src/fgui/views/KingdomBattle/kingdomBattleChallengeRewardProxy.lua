local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleChallengeRewardProxy = class("kingdomBattleChallengeRewardProxy", baseProxy)
function kingdomBattleChallengeRewardProxy:onRegisterEvent()
	print("=======kingdomBattleChallengeRewardProxy:onRegisterEvent")
end
return kingdomBattleChallengeRewardProxy

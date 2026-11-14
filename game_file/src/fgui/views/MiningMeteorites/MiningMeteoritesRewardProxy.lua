local baseProxy = require("fgui.base.baseProxy")
local MiningMeteoritesRewardProxy = class("MiningMeteoritesRewardProxy", baseProxy)
function MiningMeteoritesRewardProxy:onRegisterEvent()
	print("=======MiningMeteoritesRewardProxy:onRegisterEvent")
end
return MiningMeteoritesRewardProxy

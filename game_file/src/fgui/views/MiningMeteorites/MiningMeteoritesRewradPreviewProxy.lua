local baseProxy = require("fgui.base.baseProxy")
local MiningMeteoritesRewradPreviewProxy = class("MiningMeteoritesRewradPreviewProxy", baseProxy)
function MiningMeteoritesRewradPreviewProxy:onRegisterEvent()
	print("=======MiningMeteoritesRewradPreviewProxy:onRegisterEvent")
end
return MiningMeteoritesRewradPreviewProxy

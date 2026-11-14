local baseProxy = require("fgui.base.baseProxy")
local CaveExploreRewradPreviewProxy = class("CaveExploreRewradPreviewProxy", baseProxy)
function CaveExploreRewradPreviewProxy:onRegisterEvent()
	print("=======CaveExploreRewradPreviewProxy:onRegisterEvent")
end
return CaveExploreRewradPreviewProxy

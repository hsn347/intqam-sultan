local baseProxy = require("fgui.base.baseProxy")
local ArtifactBuyPopProxy = class("ArtifactBuyPopProxy", baseProxy)
function ArtifactBuyPopProxy:onRegisterEvent()
	print("=======ArtifactBuyPopProxy:onRegisterEvent")
end
return ArtifactBuyPopProxy

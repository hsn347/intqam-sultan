local baseProxy = require("fgui.base.baseProxy")
local ArtifactsShareBoxProxy = class("ArtifactsShareBoxProxy", baseProxy)
function ArtifactsShareBoxProxy:onRegisterEvent()
	print("=======ArtifactsShareBoxProxy:onRegisterEvent")
end
return ArtifactsShareBoxProxy

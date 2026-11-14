local baseProxy = require("fgui.base.baseProxy")
local ArtifactSelectProxy = class("ArtifactSelectProxy", baseProxy)
function ArtifactSelectProxy:onRegisterEvent()
	print("=======ArtifactSelectProxy:onRegisterEvent")
end
return ArtifactSelectProxy

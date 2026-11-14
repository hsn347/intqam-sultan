local baseProxy = require("fgui.base.baseProxy")
local ArtifactSkillInfoProxy = class("ArtifactSkillInfoProxy", baseProxy)
function ArtifactSkillInfoProxy:onRegisterEvent()
	print("=======ArtifactSkillInfoProxy:onRegisterEvent")
end
return ArtifactSkillInfoProxy

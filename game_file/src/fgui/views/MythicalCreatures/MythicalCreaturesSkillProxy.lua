local baseProxy = require("fgui.base.baseProxy")
local MythicalCreaturesSkillProxy = class("MythicalCreaturesSkillProxy", baseProxy)
function MythicalCreaturesSkillProxy:onRegisterEvent()
	print("=======MythicalCreaturesSkillProxy:onRegisterEvent")
end
return MythicalCreaturesSkillProxy

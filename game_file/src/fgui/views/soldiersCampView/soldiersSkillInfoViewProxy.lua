local baseProxy = require("fgui.base.baseProxy")
local soldiersSkillInfoViewProxy = class("soldiersSkillInfoViewProxy", baseProxy)
function soldiersSkillInfoViewProxy:onRegisterEvent()
	print("=======soldiersSkillInfoViewProxy:onRegisterEvent")
end
return soldiersSkillInfoViewProxy

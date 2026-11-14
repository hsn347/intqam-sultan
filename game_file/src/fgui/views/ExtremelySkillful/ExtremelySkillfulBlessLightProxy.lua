local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulBlessLightProxy = class("ExtremelySkillfulBlessLightProxy", baseProxy)
function ExtremelySkillfulBlessLightProxy:onRegisterEvent()
	print("=======ExtremelySkillfulBlessLightProxy:onRegisterEvent")
end
return ExtremelySkillfulBlessLightProxy

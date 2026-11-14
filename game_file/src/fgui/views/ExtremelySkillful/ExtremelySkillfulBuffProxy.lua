local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulBuffProxy = class("ExtremelySkillfulBuffProxy", baseProxy)
function ExtremelySkillfulBuffProxy:onRegisterEvent()
	print("=======ExtremelySkillfulBuffProxy:onRegisterEvent")
end
return ExtremelySkillfulBuffProxy

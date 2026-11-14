local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulUnlockProxy = class("ExtremelySkillfulUnlockProxy", baseProxy)
function ExtremelySkillfulUnlockProxy:onRegisterEvent()
	print("=======ExtremelySkillfulUnlockProxy:onRegisterEvent")
end
return ExtremelySkillfulUnlockProxy

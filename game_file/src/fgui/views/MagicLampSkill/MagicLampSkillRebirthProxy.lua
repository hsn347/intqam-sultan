local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillRebirthProxy = class("MagicLampSkillRebirthProxy", baseProxy)
function MagicLampSkillRebirthProxy:onRegisterEvent()
	print("=======MagicLampSkillRebirthProxy:onRegisterEvent")
end
return MagicLampSkillRebirthProxy

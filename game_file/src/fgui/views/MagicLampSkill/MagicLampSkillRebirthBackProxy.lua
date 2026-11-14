local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillRebirthBackProxy = class("MagicLampSkillRebirthBackProxy", baseProxy)
function MagicLampSkillRebirthBackProxy:onRegisterEvent()
	print("=======MagicLampSkillRebirthBackProxy:onRegisterEvent")
end
return MagicLampSkillRebirthBackProxy

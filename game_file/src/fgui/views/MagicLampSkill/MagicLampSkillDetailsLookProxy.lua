local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillDetailsLookProxy = class("MagicLampSkillDetailsLookProxy", baseProxy)
function MagicLampSkillDetailsLookProxy:onRegisterEvent()
	print("=======MagicLampSkillDetailsLookProxy:onRegisterEvent")
end
return MagicLampSkillDetailsLookProxy

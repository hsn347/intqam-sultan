local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillAdvanceProxy = class("MagicLampSkillAdvanceProxy", baseProxy)
function MagicLampSkillAdvanceProxy:onRegisterEvent()
	print("=======MagicLampSkillAdvanceProxy:onRegisterEvent")
end
return MagicLampSkillAdvanceProxy

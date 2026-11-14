local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillChooseProxy = class("MagicLampSkillChooseProxy", baseProxy)
function MagicLampSkillChooseProxy:onRegisterEvent()
	print("=======MagicLampSkillChooseProxy:onRegisterEvent")
end
return MagicLampSkillChooseProxy

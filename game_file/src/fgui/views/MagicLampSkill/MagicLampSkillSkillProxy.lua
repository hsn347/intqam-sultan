local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillSkillProxy = class("MagicLampSkillSkillProxy", baseProxy)
function MagicLampSkillSkillProxy:onRegisterEvent()
	print("=======MagicLampSkillSkillProxy:onRegisterEvent")
end
return MagicLampSkillSkillProxy

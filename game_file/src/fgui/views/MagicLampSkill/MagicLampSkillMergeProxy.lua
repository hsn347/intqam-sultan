local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillMergeProxy = class("MagicLampSkillMergeProxy", baseProxy)
function MagicLampSkillMergeProxy:onRegisterEvent()
	print("=======MagicLampSkillMergeProxy:onRegisterEvent")
end
return MagicLampSkillMergeProxy

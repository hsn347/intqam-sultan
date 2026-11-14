local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillBagProxy = class("MagicLampSkillBagProxy", baseProxy)
function MagicLampSkillBagProxy:onRegisterEvent()
	print("=======MagicLampSkillBagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_MERGE", handler(self, self.onMsgAfterMerge))
end
function MagicLampSkillBagProxy:onMsgAfterMerge(...)
	self.view:onMsgAfterMerge(...)
end
return MagicLampSkillBagProxy

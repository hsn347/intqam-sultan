local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillResolveProxy = class("MagicLampSkillResolveProxy", baseProxy)
function MagicLampSkillResolveProxy:onRegisterEvent()
	print("=======MagicLampSkillResolveProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_RESOLVE", handler(self, self.onMsgResolveBack))
end
function MagicLampSkillResolveProxy:onMsgResolveBack(...)
	self.view:onMsgResolveBack()
end
return MagicLampSkillResolveProxy

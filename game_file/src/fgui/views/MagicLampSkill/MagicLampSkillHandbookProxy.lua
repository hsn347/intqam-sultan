local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillHandbookProxy = class("MagicLampSkillHandbookProxy", baseProxy)
function MagicLampSkillHandbookProxy:onRegisterEvent()
	print("=======MagicLampSkillHandbookProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_MERGE", handler(self, self.onMsgAfterMerge))
end
function MagicLampSkillHandbookProxy:onMsgAfterMerge(...)
	self.view:onMsgAfterMerge(...)
end
return MagicLampSkillHandbookProxy

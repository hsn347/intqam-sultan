local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillGroupProxy = class("MagicLampSkillGroupProxy", baseProxy)
function MagicLampSkillGroupProxy:onRegisterEvent()
	print("=======MagicLampSkillGroupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampSkillGroupProxy:msgUpdateView()
	self.view:onMagicLampUpdate()
end
return MagicLampSkillGroupProxy

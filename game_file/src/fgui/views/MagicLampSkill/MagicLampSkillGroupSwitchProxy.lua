local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillGroupSwitchProxy = class("MagicLampSkillGroupSwitchProxy", baseProxy)
function MagicLampSkillGroupSwitchProxy:onRegisterEvent()
	print("=======MagicLampSkillGroupSwitchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampSkillGroupSwitchProxy:msgUpdateView()
	self.view:onMagicLampUpdate()
end
return MagicLampSkillGroupSwitchProxy

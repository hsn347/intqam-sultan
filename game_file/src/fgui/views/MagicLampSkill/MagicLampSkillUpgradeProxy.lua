local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillUpgradeProxy = class("MagicLampSkillUpgradeProxy", baseProxy)
function MagicLampSkillUpgradeProxy:onRegisterEvent()
	print("=======MagicLampSkillUpgradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_UPGRADE_LV", handler(self, self.onMsgUpgradeLvBack))
end
function MagicLampSkillUpgradeProxy:onMsgUpgradeLvBack(...)
	self.view:onMsgUpgradeLvBack()
end
return MagicLampSkillUpgradeProxy

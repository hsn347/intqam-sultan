local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillDetailsProxy = class("MagicLampSkillDetailsProxy", baseProxy)
function MagicLampSkillDetailsProxy:onRegisterEvent()
	print("=======MagicLampSkillDetailsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_UPGRADE_LV", handler(self, self.onMsgUpgradeLvBack))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_UPGRADE_CLASS", handler(self, self.onMsgUpgradeClassBack))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOCK", handler(self, self.onMsgUpdateLock))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_MERGE", handler(self, self.onMsgAfterMerge))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_REBIRTH", handler(self, self.onMsgAfterRebirth))
end
function MagicLampSkillDetailsProxy:onMsgUpgradeLvBack(...)
	self.view:onMsgUpgradeLvBack()
end
function MagicLampSkillDetailsProxy:onMsgUpgradeClassBack(...)
	self.view:onMsgUpgradeClassBack()
end
function MagicLampSkillDetailsProxy:onMsgUpdateLock(...)
	self.view:onMsgUpdateLock()
end
function MagicLampSkillDetailsProxy:onMsgAfterMerge(...)
	self.view:onMsgAfterMerge(...)
end
function MagicLampSkillDetailsProxy:onMsgAfterRebirth(...)
	self.view:onMsgAfterRebirth(...)
end
return MagicLampSkillDetailsProxy

local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillMainProxy = class("MagicLampSkillMainProxy", baseProxy)
function MagicLampSkillMainProxy:onRegisterEvent()
	print("=======MagicLampSkillMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_ENERGY", handler(self, self.onMsgUpdateEnergyCount))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_MERGE", handler(self, self.onMsgAfterMerge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.updateButtonState))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updateButtonState))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.updateButtonState))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updateButtonState))
end
function MagicLampSkillMainProxy:onMsgUpdateEnergyCount(...)
	self.view:updateEnergyCount()
end
function MagicLampSkillMainProxy:onMsgAfterMerge(...)
	self.view:updateButtonState()
end
function MagicLampSkillMainProxy:updateButtonState(target, data)
	if self.view then
		self.view:updateButtonState()
	end
end
return MagicLampSkillMainProxy

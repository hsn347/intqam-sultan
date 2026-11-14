local baseProxy = require("fgui.base.baseProxy")
local MagicLampPowerProxy = class("MagicLampPowerProxy", baseProxy)
function MagicLampPowerProxy:onRegisterEvent()
	print("=======MagicLampPowerProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampPowerProxy:msgUpdateView()
	self.view:updateSkills()
	self.view:updateView()
end
return MagicLampPowerProxy

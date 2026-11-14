local baseProxy = require("fgui.base.baseProxy")
local heroTrialDispatchArmyProxy = class("heroTrialDispatchArmyProxy", baseProxy)
function heroTrialDispatchArmyProxy:onRegisterEvent()
	print("=======heroTrialDispatchArmyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", handler(self, self.cityBuffAdd))
end
function heroTrialDispatchArmyProxy:cityBuffAdd(target, data)
	self.view:cityBuffAdd(target, data)
end
return heroTrialDispatchArmyProxy

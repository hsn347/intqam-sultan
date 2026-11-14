local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorEnergyProxy = class("NebulaEmperorEnergyProxy", baseProxy)
function NebulaEmperorEnergyProxy:onRegisterEvent()
	print("=======NebulaEmperorEnergyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_DATA", handler(self, self.onMsgEnergyDataBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_EXCHANGE", handler(self, self.onMsgEnergyExchangeBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_ENERGY_EXCHANGE", handler(self, self.onMsgEnergyExchangeBack))
end
function NebulaEmperorEnergyProxy:onMsgEnergyDataBack(...)
	self.view:onMsgEnergyDataBack()
end
function NebulaEmperorEnergyProxy:onMsgEnergyExchangeBack(...)
	self.view:onMsgEnergyExchangeBack()
end
return NebulaEmperorEnergyProxy

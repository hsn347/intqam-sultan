local baseProxy = require("fgui.base.baseProxy")
local SoldierRushGateInfoProxy = class("SoldierRushGateInfoProxy", baseProxy)
function SoldierRushGateInfoProxy:onRegisterEvent()
	print("=======SoldierRushGateInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_GATE_ARMYLV_INFO", handler(self, self.showArmyInfo))
end
function SoldierRushGateInfoProxy:showArmyInfo(target, data)
	self.view:showArmyInfo(target, data)
end
return SoldierRushGateInfoProxy

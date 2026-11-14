local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleReinforcementProxy = class("kingdomBattleReinforcementProxy", baseProxy)
function kingdomBattleReinforcementProxy:onRegisterEvent()
	print("=======kingdomBattleReinforcementProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", handler(self, self.msgBack))
end
function kingdomBattleReinforcementProxy:msgBack(target, data)
	if data.subMsg == "reinforcementsList" then
		self.view:updateView(data.rspdata)
	end
end
return kingdomBattleReinforcementProxy

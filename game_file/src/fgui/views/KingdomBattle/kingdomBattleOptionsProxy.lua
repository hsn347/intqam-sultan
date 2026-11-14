local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleOptionsProxy = class("kingdomBattleOptionsProxy", baseProxy)
function kingdomBattleOptionsProxy:onRegisterEvent()
	print("=======kingdomBattleOptionsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", handler(self, self.onMsgCallBack))
end
function kingdomBattleOptionsProxy:onMsgCallBack(target, data)
	if data.subMsg == "ReinforcementsChoose" and not data.isSuccess then
		self.view:updateButton()
	end
end
return kingdomBattleOptionsProxy

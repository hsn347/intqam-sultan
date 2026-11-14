local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleReadyProxy = class("kingdomBattleReadyProxy", baseProxy)
function kingdomBattleReadyProxy:onRegisterEvent()
	print("=======kingdomBattleReadyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH", handler(self, self.onReqInitBack))
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", handler(self, self.updatRed))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updatShopRed))
end
function kingdomBattleReadyProxy:onReqInitBack(target, info)
	SoraDCloseLoading()
	self.view:initData()
end
function kingdomBattleReadyProxy:updatRed(target, data)
	self.view:updatRed()
end
function kingdomBattleReadyProxy:updatShopRed(target, data)
	self.view:updatRed()
end
return kingdomBattleReadyProxy

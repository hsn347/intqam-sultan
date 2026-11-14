local baseProxy = require("fgui.base.baseProxy")
local allianceHuntViewProxy = class("allianceHuntViewProxy", baseProxy)
function allianceHuntViewProxy:onRegisterEvent()
	print("=======allianceHuntViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BATTLE_END", handler(self, self.sMsgHandlerBattleEnd))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_UPDATE_EXCHANGE_POINT", handler(self, self.msgUpdateExhcangeRedPoint))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_DAILY_REFRESH", handler(self, self.sMsgHandlerDailyRefresh))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS", handler(self, self.sMsgBuySuccess))
end
function allianceHuntViewProxy:sMsgHandlerBattleEnd(...)
	self.view:sMsgHandlerBattleEnd(...)
end
function allianceHuntViewProxy:msgUpdateExhcangeRedPoint(...)
	self.view:msgUpdateExhcangeRedPoint(...)
end
function allianceHuntViewProxy:sMsgHandlerDailyRefresh(...)
	self.view:sMsgHandlerDailyRefresh(...)
end
function allianceHuntViewProxy:sMsgBuySuccess(...)
	self.view:sMsgBuySuccess(...)
end
return allianceHuntViewProxy

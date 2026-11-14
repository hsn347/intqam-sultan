local baseProxy = require("fgui.base.baseProxy")
local KingStarActivityProxy = class("KingStarActivityProxy", baseProxy)
function KingStarActivityProxy:onRegisterEvent()
	print("=======KingStarActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM", handler(self, self.updateWatchingNum))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.sMsgTeamUPdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.updateExchangeNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updateExchangeNum))
end
function KingStarActivityProxy:sMsgCommonRefresh(target, data)
	self.view:sMsgCommonRefresh(target, data)
end
function KingStarActivityProxy:updateWatchingNum(target, data)
	self.view:updateWatchingNum(target, data)
end
function KingStarActivityProxy:sMsgTeamUPdate(target, data)
	self.view:sMsgTeamUPdate(target, data)
end
function KingStarActivityProxy:updateExchangeNum(target, data)
	self.view:updateExchangeNum(target, data)
end
return KingStarActivityProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001738_ViewProxy = class("Activity_9001738_ViewProxy", baseProxy)
function Activity_9001738_ViewProxy:onRegisterEvent()
	print("=======Activity_9001738_ViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_BUY_GIFT", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.onRedDotRefresh))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onExchangeRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onExchangeRefresh))
	self:registerActivityCloseEvent(gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY)
end
function Activity_9001738_ViewProxy:onUpdateView(target, data)
	if self.view and self.view.updateView then
		self.view:updateView()
	end
end
function Activity_9001738_ViewProxy:onRedDotRefresh(target, data)
	if self.view and data.eventID == self.view.activityID then
		self.view:updateReddot()
	end
end
function Activity_9001738_ViewProxy:onExchangeRefresh(target, data)
	if self.view then
		self.view:refreshBattlePass()
		self.view:updateReddot()
	end
end
return Activity_9001738_ViewProxy

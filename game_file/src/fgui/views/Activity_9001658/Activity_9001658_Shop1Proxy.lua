local baseProxy = require("fgui.base.baseProxy")
local Activity_9001658_Shop1Proxy = class("Activity_9001658_Shop1Proxy", baseProxy)
function Activity_9001658_Shop1Proxy:onRegisterEvent()
	print("=======Activity_9001658_Shop1Proxy:onRegisterEvent")
	self.activityID = self.view.activityID
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.onMsgExchangeMallRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgActivityUpdate))
end
function Activity_9001658_Shop1Proxy:onMsgExchangeMallRefresh(...)
	self.view:onMsgExchangeMallRefresh(...)
end
function Activity_9001658_Shop1Proxy:onMsgActivityUpdate(target, event)
	local activityIDList = event.activityID
	if not activityIDList or type(activityIDList) ~= "table" then
		return
	end
	if table.indexof(activityIDList, self.activityID) then
		self.view:updateActivityState()
	end
end
return Activity_9001658_Shop1Proxy

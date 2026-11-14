local baseProxy = require("fgui.base.baseProxy")
local Activity_9001733_ProduceProxy = class("Activity_9001733_ProduceProxy", baseProxy)
function Activity_9001733_ProduceProxy:onRegisterEvent()
	print("=======Activity_9001733_ProduceProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001733_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.onRedDotRefresh))
	self:registerActivityCloseEvent(gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY)
end
function Activity_9001733_ProduceProxy:onUpdateView(target, data)
	if not self.view then
		return
	end
	SoraDCloseLoading(self.view)
	if data and data.subMsg == "claimFootball" then
		self.view:onClaimFootball()
		return
	end
	self.view:updateView()
end
function Activity_9001733_ProduceProxy:onRedDotRefresh(target, data)
	if not (self.view and data) or data.eventID ~= gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY then
		return
	end
	self.view:refreshClaimFootballState()
end
return Activity_9001733_ProduceProxy

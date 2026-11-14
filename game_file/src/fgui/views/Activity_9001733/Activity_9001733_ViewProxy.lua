local baseProxy = require("fgui.base.baseProxy")
local Activity_9001733_ViewProxy = class("Activity_9001733_ViewProxy", baseProxy)
function Activity_9001733_ViewProxy:onRegisterEvent()
	print("=======Activity_9001733_ViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001733_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.onRedDotRefresh))
	self:registerActivityCloseEvent(gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY)
end
function Activity_9001733_ViewProxy:onUpdateView(target, data)
	if self.view then
		self.view:updateView(data)
	end
end
function Activity_9001733_ViewProxy:onUpdateTask(target, data)
	if not (self.view and data) or data.activityID ~= self.view.activityID then
		return
	end
	SoraDCloseLoading(self.view)
	self.view:updateTask()
	self.view:updatRed()
end
function Activity_9001733_ViewProxy:onRedDotRefresh(target, data)
	if self.view and data and data.eventID == self.view.activityID then
		self.view:updatRed()
	end
	return data
end
return Activity_9001733_ViewProxy

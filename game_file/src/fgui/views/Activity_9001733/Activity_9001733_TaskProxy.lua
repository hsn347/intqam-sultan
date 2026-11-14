local baseProxy = require("fgui.base.baseProxy")
local Activity_9001733_TaskProxy = class("Activity_9001733_TaskProxy", baseProxy)
function Activity_9001733_TaskProxy:onRegisterEvent()
	print("=======Activity_9001733_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001733_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001733_NOTIFY", handler(self, self.onUpdateView))
	self:registerActivityCloseEvent(gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY)
end
function Activity_9001733_TaskProxy:onUpdateTask(target, data)
	if not (self.view and data) or data.activityID ~= self.view.activityID then
		return
	end
	SoraDCloseLoading(self.view)
	self.view:updateView()
end
function Activity_9001733_TaskProxy:onUpdateView()
	if not self.view then
		return
	end
	SoraDCloseLoading(self.view)
	self.view:updateView()
end
return Activity_9001733_TaskProxy

local baseProxy = require("fgui.base.baseProxy")
local WarHornMainProxy = class("WarHornMainProxy", baseProxy)
function WarHornMainProxy:onRegisterEvent()
	print("=======WarHornMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001581_REFRESH", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001581_BUY_GIFT", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function WarHornMainProxy:onUpdateTask(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updateTask()
		self.view:updatRed()
	end
end
function WarHornMainProxy:onUpdateTips(target, data)
	self.view:updateView()
end
function WarHornMainProxy:onUpdateRewardView(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updatRed()
		self.view:updateView()
	end
end
function WarHornMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return WarHornMainProxy

local baseProxy = require("fgui.base.baseProxy")
local BraqueTestMainProxy = class("BraqueTestMainProxy", baseProxy)
function BraqueTestMainProxy:onRegisterEvent()
	print("=======BraqueTestMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001562_REFRESH", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function BraqueTestMainProxy:onUpdateTask(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updateTask()
		self.view:updatRed()
	end
end
function BraqueTestMainProxy:onUpdateTips(target, data)
	self.view:updateView()
end
function BraqueTestMainProxy:onUpdateRewardView(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updateReward()
		self.view:updatRed()
		self.view:updateView()
	end
end
function BraqueTestMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return BraqueTestMainProxy

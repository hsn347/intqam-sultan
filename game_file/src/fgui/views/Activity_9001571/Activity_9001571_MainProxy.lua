local baseProxy = require("fgui.base.baseProxy")
local Activity_9001571_MainProxy = class("Activity_9001571_MainProxy", baseProxy)
function Activity_9001571_MainProxy:onRegisterEvent()
	print("=======Activity_9001571_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001571_UPDATE", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001571_MainProxy:onUpdateTask(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updateTask()
		self.view:updatRed()
	end
end
function Activity_9001571_MainProxy:onUpdateRewardView(target, data)
	SoraDCloseLoading(self.view)
	if data.subMsg == "changeGroup" then
		self.view:onInitView()
	else
		self.view:updateReward()
		self.view:updatRed()
		self.view:updateView()
	end
end
function Activity_9001571_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001571_MainProxy

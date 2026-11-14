local baseProxy = require("fgui.base.baseProxy")
local RamadanSurpriseProxy = class("RamadanSurpriseProxy", baseProxy)
function RamadanSurpriseProxy:onRegisterEvent()
	print("=======RamadanSurpriseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RAMADAN_SURPRISE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.getTaskReward))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
end
function RamadanSurpriseProxy:refreshView(target, data)
	if self.view then
		dump(data, "RamadanSurpriseProxy:refreshV")
		self.view:refreshView(data)
	end
end
function RamadanSurpriseProxy:onUpdateTask(target, data)
	if data.activityID == gActivityTimeActivityID.RAMADAN_SURPRISE_ACTIVITY then
		self.view:initData()
	end
end
function RamadanSurpriseProxy:getTaskReward(target, data)
	if data.activityID == gActivityTimeActivityID.RAMADAN_SURPRISE_ACTIVITY then
		dump(data, "RamadanSurpriseProxy:getTaskReward")
		self.view:initData()
	end
end
function RamadanSurpriseProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_SURPRISE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanSurpriseProxy

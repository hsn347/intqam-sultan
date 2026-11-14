local baseProxy = require("fgui.base.baseProxy")
local Activity_9001576_mainProxy = class("Activity_9001576_mainProxy", baseProxy)
function Activity_9001576_mainProxy:onRegisterEvent()
	print("=======Activity_9001576_mainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIGNREWARD_9001576_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001576_mainProxy:initData()
	self.view:initData()
end
function Activity_9001576_mainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001576_mainProxy

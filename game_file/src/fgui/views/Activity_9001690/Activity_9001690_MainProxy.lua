local baseProxy = require("fgui.base.baseProxy")
local Activity_9001690_MainProxy = class("Activity_9001690_MainProxy", baseProxy)
function Activity_9001690_MainProxy:onRegisterEvent()
	print("=======Activity_9001690_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001690_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	else
		self.view:initData()
	end
end
return Activity_9001690_MainProxy

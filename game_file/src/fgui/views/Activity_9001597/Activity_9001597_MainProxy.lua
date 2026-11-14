local baseProxy = require("fgui.base.baseProxy")
local Activity_9001597_MainProxy = class("Activity_9001597_MainProxy", baseProxy)
function Activity_9001597_MainProxy:onRegisterEvent()
	print("=======Activity_9001597_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001597_UPDATE", handler(self, self.updateView))
end
function Activity_9001597_MainProxy:updateView()
	self.view:updateView()
end
function Activity_9001597_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001597_MainProxy

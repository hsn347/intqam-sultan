local baseProxy = require("fgui.base.baseProxy")
local Activity_9001723_MainProxy = class("Activity_9001723_MainProxy", baseProxy)
function Activity_9001723_MainProxy:onRegisterEvent()
	print("=======Activity_9001723_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001723_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIVERSARY_2025_9001723) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001723_MainProxy

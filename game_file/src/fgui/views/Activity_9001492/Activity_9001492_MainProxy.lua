local baseProxy = require("fgui.base.baseProxy")
local Activity_9001492_MainProxy = class("Activity_9001492_MainProxy", baseProxy)
function Activity_9001492_MainProxy:onRegisterEvent()
	print("=======Activity_9001492_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001492_UPDATE", handler(self, self.onMsgActivityUpdate))
end
function Activity_9001492_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_LIGHT_LAMP_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001492_MainProxy:onMsgActivityUpdate(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateBtnState()
end
return Activity_9001492_MainProxy

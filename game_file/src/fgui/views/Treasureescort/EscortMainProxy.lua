local baseProxy = require("fgui.base.baseProxy")
local EscortMainProxy = class("EscortMainProxy", baseProxy)
function EscortMainProxy:onRegisterEvent()
	print("=======EscortMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ALLIANCEESCORT_UPDATE", handler(self.view, self.view.refreshView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self.view, self.view.newDay))
end
function EscortMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ALLIANCE_ESCORT_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return EscortMainProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001656_MainProxy = class("Activity_9001656_MainProxy", baseProxy)
function Activity_9001656_MainProxy:onRegisterEvent()
	print("=======Activity_9001656_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001656_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001656_MainProxy:onUpdateView()
	self.view:updateView()
end
function Activity_9001656_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001656_MainProxy

local baseProxy = require("fgui.base.baseProxy")
local EighthAnniversaryMainProxy = class("EighthAnniversaryMainProxy", baseProxy)
function EighthAnniversaryMainProxy:onRegisterEvent()
	print("=======EighthAnniversaryMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function EighthAnniversaryMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		self.view:close()
		return
	end
end
return EighthAnniversaryMainProxy

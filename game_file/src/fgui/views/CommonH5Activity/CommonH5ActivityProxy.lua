local baseProxy = require("fgui.base.baseProxy")
local CommonH5ActivityProxy = class("CommonH5ActivityProxy", baseProxy)
function CommonH5ActivityProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function CommonH5ActivityProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		self.view:close()
	end
end
return CommonH5ActivityProxy

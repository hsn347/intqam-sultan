local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarNoticeProxy = class("NebulaAllStarNoticeProxy", baseProxy)
function NebulaAllStarNoticeProxy:onRegisterEvent()
	print("=======NebulaAllStarNoticeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaAllStarNoticeProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaAllStarNoticeProxy

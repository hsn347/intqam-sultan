local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorProxy = class("NebulaEmperorProxy", baseProxy)
function NebulaEmperorProxy:onRegisterEvent()
	print("=======NebulaEmperorProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaEmperorProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaEmperorProxy

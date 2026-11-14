local baseProxy = require("fgui.base.baseProxy")
local Activity_9001038_MainProxy = class("Activity_9001038_MainProxy", baseProxy)
function Activity_9001038_MainProxy:onRegisterEvent()
	print("=======Activity_9001038_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_EVENTCHANGE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_BLOCKREFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH", handler(self, self.initView))
end
function Activity_9001038_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001038_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001038_MainProxy

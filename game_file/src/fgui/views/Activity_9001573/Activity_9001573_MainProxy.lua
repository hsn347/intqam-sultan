local baseProxy = require("fgui.base.baseProxy")
local Activity_9001573_MainProxy = class("Activity_9001573_MainProxy", baseProxy)
function Activity_9001573_MainProxy:onRegisterEvent()
	print("=======Activity_9001573_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_POINT_REWARD", handler(self, self.updateData))
end
function Activity_9001573_MainProxy:updateData()
	self.view:initData()
end
function Activity_9001573_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NORMAL_ACTIVITY_9001573) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001573_MainProxy

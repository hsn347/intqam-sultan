local baseProxy = require("fgui.base.baseProxy")
local Activity_9001596_MainProxy = class("Activity_9001596_MainProxy", baseProxy)
function Activity_9001596_MainProxy:onRegisterEvent()
	print("=======Activity_9001596_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001596_UI_PART_SELECT", handler(self, self.partSelect))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001596_UPDATE", handler(self, self.setPartInfo))
end
function Activity_9001596_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001596_MainProxy:partSelect(target, data)
	self.view:partSelect(target, data)
end
function Activity_9001596_MainProxy:setPartInfo(target, data)
	self.view:setPartInfo(target, data)
end
return Activity_9001596_MainProxy

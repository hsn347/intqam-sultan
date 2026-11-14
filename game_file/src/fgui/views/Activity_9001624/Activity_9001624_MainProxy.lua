local baseProxy = require("fgui.base.baseProxy")
local Activity_9001624_MainProxy = class("Activity_9001624_MainProxy", baseProxy)
function Activity_9001624_MainProxy:onRegisterEvent()
	print("=======Activity_9001624_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001624_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001637_UPDATE", handler(self, self.onUpdateView_9001637))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001624_MainProxy:onUpdateView()
	if self.view.activityID ~= gActivityTimeActivityID.NORMAL_ACTIVITY_9001624 then
		return
	end
	self.view:updateView()
end
function Activity_9001624_MainProxy:onUpdateView_9001637()
	if self.view.activityID ~= gActivityTimeActivityID.CELEBRATE_CORBAN then
		return
	end
	self.view:updateView()
end
function Activity_9001624_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001624_MainProxy

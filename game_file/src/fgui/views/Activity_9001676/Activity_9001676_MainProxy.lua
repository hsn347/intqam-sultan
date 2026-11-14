local baseProxy = require("fgui.base.baseProxy")
local Activity_9001676_MainProxy = class("Activity_9001676_MainProxy", baseProxy)
function Activity_9001676_MainProxy:onRegisterEvent()
	print("=======Activity_9001676_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001676_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateView))
end
function Activity_9001676_MainProxy:updateView(target, data)
	self.view:updateView(data.msgType)
end
function Activity_9001676_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001676_MainProxy:onBackClick()
	if not tolua.isnull(self.view) then
		self.view:onBackClick()
	end
end
return Activity_9001676_MainProxy

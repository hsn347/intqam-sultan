local baseProxy = require("fgui.base.baseProxy")
local Activity_9001680_MainProxy = class("Activity_9001680_MainProxy", baseProxy)
function Activity_9001680_MainProxy:onRegisterEvent()
	print("=======Activity_9001680_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001680_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItem))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateItem))
end
function Activity_9001680_MainProxy:updateView(target, data)
	self.view:updateView(data)
end
function Activity_9001680_MainProxy:updateItem(target, data)
	self.view:updateItem()
end
function Activity_9001680_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001680_MainProxy

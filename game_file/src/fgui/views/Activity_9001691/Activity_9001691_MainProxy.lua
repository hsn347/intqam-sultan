local baseProxy = require("fgui.base.baseProxy")
local Activity_9001691_MainProxy = class("Activity_9001691_MainProxy", baseProxy)
function Activity_9001691_MainProxy:onRegisterEvent()
	print("=======Activity_9001691_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001691_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateView))
end
function Activity_9001691_MainProxy:updateView(target, data)
	if data.msgType == "begin" then
		self.view:startGame(data)
	elseif data.msgType == nil or data.msgType == "" then
		self.view:updateView()
	end
end
function Activity_9001691_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001691_MainProxy:obSystemBackKeyClick()
	if not tolua.isnull(self.view) then
		self.view:obSystemBackKeyClick()
	end
end
return Activity_9001691_MainProxy

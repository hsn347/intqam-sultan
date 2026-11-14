local baseProxy = require("fgui.base.baseProxy")
local DashainGiftingMainProxy = class("DashainGiftingMainProxy", baseProxy)
function DashainGiftingMainProxy:onRegisterEvent()
	print("=======DashainGiftingMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001537_UPDATE", handler(self, self.msgUpdateView))
end
function DashainGiftingMainProxy:msgUpdateView(target, data)
	SoraDCloseLoading()
	self.view:updateView()
end
function DashainGiftingMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return DashainGiftingMainProxy

local baseProxy = require("fgui.base.baseProxy")
local PopupWindowProxy = class("PopupWindowProxy", baseProxy)
function PopupWindowProxy:onRegisterEvent()
	print("=======PopupWindowProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.refreshPresentGold))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_EXTRA_UI_REFRESH", handler(self, self.refreshPresentGold))
end
function PopupWindowProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.param.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function PopupWindowProxy:refreshPresentGold(target, data)
	self.view:refreshPresentGold(target, data)
end
return PopupWindowProxy

local baseProxy = require("fgui.base.baseProxy")
local evilPalaceReadyViewProxy = class("evilPalaceReadyViewProxy", baseProxy)
function evilPalaceReadyViewProxy:onRegisterEvent()
	print("=======evilPalaceReadyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_ENTRANCE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_REFRESHINFO", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_UPDATEACTIVESTATUS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_MONSTERPALACE_UPDATETIPS", handler(self, self.checkTips))
end
function evilPalaceReadyViewProxy:judgeEventClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function evilPalaceReadyViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function evilPalaceReadyViewProxy:checkTips(target, data)
	self.view:checkTips(target, data)
end
return evilPalaceReadyViewProxy

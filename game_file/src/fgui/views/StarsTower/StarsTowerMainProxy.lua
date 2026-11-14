local baseProxy = require("fgui.base.baseProxy")
local StarsTowerMainProxy = class("StarsTowerMainProxy", baseProxy)
function StarsTowerMainProxy:onRegisterEvent()
	print("=======StarsTowerMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_STARSTOWER_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_STARSTOWER_UI_SELECT", handler(self, self.updateMenu))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateGift))
end
function StarsTowerMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function StarsTowerMainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function StarsTowerMainProxy:updateMenu(target, data)
	self.view:updateMenu(target, data)
end
function StarsTowerMainProxy:updateGift(target, data)
	self.view:updateGift(target, data)
end
return StarsTowerMainProxy

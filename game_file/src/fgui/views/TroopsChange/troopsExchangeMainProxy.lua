local baseProxy = require("fgui.base.baseProxy")
local troopsExchangeMainProxy = class("troopsExchangeMainProxy", baseProxy)
function troopsExchangeMainProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.judgeClose))
end
function troopsExchangeMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	else
		self.view:updateScroll()
	end
end
return troopsExchangeMainProxy

local baseProxy = require("fgui.base.baseProxy")
local hanselactivityProxy = class("hanselactivityProxy", baseProxy)
function hanselactivityProxy:onRegisterEvent()
	print("=======hanselactivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH", handler(self, self.updateePresentGold))
end
function hanselactivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_YEAR_RECAHRGE_PRESENT) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function hanselactivityProxy:updateePresentGold(...)
	self.view:updateePresentGold()
end
return hanselactivityProxy

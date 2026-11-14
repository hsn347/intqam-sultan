local baseProxy = require("fgui.base.baseProxy")
local ArisanHouseBuffPopProxy = class("ArisanHouseBuffPopProxy", baseProxy)
function ArisanHouseBuffPopProxy:onRegisterEvent()
	print("=======ArisanHouseBuffPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ArisanHouseBuffPopProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	elseif self.view then
		self.view:initData()
	end
end
return ArisanHouseBuffPopProxy

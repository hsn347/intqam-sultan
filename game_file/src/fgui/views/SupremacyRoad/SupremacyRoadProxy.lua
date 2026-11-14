local baseProxy = require("fgui.base.baseProxy")
local SupremacyRoadProxy = class("SupremacyRoadProxy", baseProxy)
function SupremacyRoadProxy:onRegisterEvent()
	print("=======SupremacyRoadProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SUPREMACY_ROAD_INIT_BACK", handler(self, self.onMsgInitBack))
end
function SupremacyRoadProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SUPREMACY_ROAD_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function SupremacyRoadProxy:onMsgInitBack(target, event)
	self.view:onMsgInitBack(target, event)
end
return SupremacyRoadProxy

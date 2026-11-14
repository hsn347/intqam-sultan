local baseProxy = require("fgui.base.baseProxy")
local AllianceCounterSysViewProxy = class("AllianceCounterSysViewProxy", baseProxy)
function AllianceCounterSysViewProxy:onRegisterEvent()
	print("=======AllianceCounterSysViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COUNTER_LIST_MOVE", handler(self, self.updateGuideAcion))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COUNTER_OWN_REFRESH", handler(self, self.onRefresh))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.onUpdatePoint))
end
function AllianceCounterSysViewProxy:updateGuideAcion(...)
	self.view:updateGuideAcion(...)
end
function AllianceCounterSysViewProxy:onRefresh(...)
	self.view:onRefresh(...)
end
function AllianceCounterSysViewProxy:onUpdatePoint(...)
	self.view:onUpdatePoint(...)
end
function AllianceCounterSysViewProxy:tabChange(...)
	self.view:tabChange(...)
end
return AllianceCounterSysViewProxy

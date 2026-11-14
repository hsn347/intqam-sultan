local baseProxy = require("fgui.base.baseProxy")
local allianceEventLogViewProxy = class("allianceEventLogViewProxy", baseProxy)
function allianceEventLogViewProxy:onRegisterEvent()
	print("=======allianceEventLogViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_LOG_SUCCESS", handler(self, self.updateLogData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_NOTICE_CHANGE_SUCCESS", handler(self, self.updateLogData))
end
function allianceEventLogViewProxy:updateLogData(target, data)
	self.view:updateLogData(target, data)
end
return allianceEventLogViewProxy

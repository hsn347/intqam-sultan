local baseProxy = require("fgui.base.baseProxy")
local AllianceWarHistoryProxy = class("AllianceWarHistoryProxy", baseProxy)
function AllianceWarHistoryProxy:onRegisterEvent()
	print("=======AllianceWarHistoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_WAR_HISTORY_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function AllianceWarHistoryProxy:updateData(...)
	self.view:updateData(...)
end
function AllianceWarHistoryProxy:sMsgReqInfoBack(...)
	self.view:sMsgReqInfoBack(...)
end
return AllianceWarHistoryProxy

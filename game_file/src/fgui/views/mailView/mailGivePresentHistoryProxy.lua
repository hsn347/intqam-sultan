local baseProxy = require("fgui.base.baseProxy")
local mailGivePresentHistoryProxy = class("mailGivePresentHistoryProxy", baseProxy)
function mailGivePresentHistoryProxy:onRegisterEvent()
	print("=======mailGivePresentHistoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_GIVE_HISTORY_SUCCESS", handler(self, self.updateData))
end
function mailGivePresentHistoryProxy:updateData(target, data)
	self.view:updateData(target, data)
end
return mailGivePresentHistoryProxy

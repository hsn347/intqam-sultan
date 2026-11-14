local baseProxy = require("fgui.base.baseProxy")
local mailSharePopViewProxy = class("mailSharePopViewProxy", baseProxy)
function mailSharePopViewProxy:onRegisterEvent()
	print("=======mailSharePopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_SHARE_MAIL", handler(self, self.onMsgShareBack))
end
function mailSharePopViewProxy:onMsgShareBack(target, data)
	self.view:onMsgShareBack(target, data)
end
return mailSharePopViewProxy

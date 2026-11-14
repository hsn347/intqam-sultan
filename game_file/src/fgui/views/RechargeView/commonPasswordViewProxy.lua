local baseProxy = require("fgui.base.baseProxy")
local commonPasswordViewProxy = class("commonPasswordViewProxy", baseProxy)
function commonPasswordViewProxy:onRegisterEvent()
	print("=======commonPasswordViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_RECHARGEVIP_CLOSEPASSWORD", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD", handler(self, self.pwdBack))
end
function commonPasswordViewProxy:closeMe(target, data)
	self.view:closeMe(target, data)
end
function commonPasswordViewProxy:pwdBack(target, data)
	self.view:pwdBack(target, data)
end
return commonPasswordViewProxy

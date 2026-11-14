local baseProxy = require("fgui.base.baseProxy")
local gameVerificationCodeProxy = class("gameVerificationCodeProxy", baseProxy)
function gameVerificationCodeProxy:onRegisterEvent()
	print("=======gameVerificationCodeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WEB_PAY_VERIFY_TOKEN_REFRESH", handler(self, self.onUpdateView))
end
function gameVerificationCodeProxy:onUpdateView()
	self.view:updateView()
end
return gameVerificationCodeProxy

local baseProxy = require("fgui.base.baseProxy")
local gameActivationCodeProxy = class("gameActivationCodeProxy", baseProxy)
function gameActivationCodeProxy:onRegisterEvent()
	print("=======gameActivationCodeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_ACTIVECODESUCCESS", handler(self, self.closeMe))
end
function gameActivationCodeProxy:closeMe()
	self.view:removeFromParent()
end
return gameActivationCodeProxy

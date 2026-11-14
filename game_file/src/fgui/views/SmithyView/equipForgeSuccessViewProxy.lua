local baseProxy = require("fgui.base.baseProxy")
local equipForgeSuccessViewProxy = class("equipForgeSuccessViewProxy", baseProxy)
function equipForgeSuccessViewProxy:onRegisterEvent()
	print("=======equipForgeSuccessViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.equipLimitTimeOut))
end
function equipForgeSuccessViewProxy:equipLimitTimeOut(target, data)
	self.view:equipLimitTimeOut(target, data)
end
return equipForgeSuccessViewProxy

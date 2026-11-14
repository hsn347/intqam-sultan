local baseProxy = require("fgui.base.baseProxy")
local guardianPopViewProxy = class("guardianPopViewProxy", baseProxy)
function guardianPopViewProxy:onRegisterEvent()
	print("=======guardianPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GUARDIAN_REFRESH", handler(self, self.updataData))
end
function guardianPopViewProxy:updataData(target, data)
	self.view:updataData(target, data)
end
return guardianPopViewProxy

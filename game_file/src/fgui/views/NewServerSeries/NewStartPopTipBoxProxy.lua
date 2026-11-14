local baseProxy = require("fgui.base.baseProxy")
local NewStartPopTipBoxProxy = class("NewStartPopTipBoxProxy", baseProxy)
function NewStartPopTipBoxProxy:onRegisterEvent()
	print("=======NewStartPopTipBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEW_START_CODE_REFRESH", handler(self, self.refreshCode))
end
function NewStartPopTipBoxProxy:refreshCode(target, event)
	self.view:refreshCode(target, event)
end
return NewStartPopTipBoxProxy

local baseProxy = require("fgui.base.baseProxy")
local medalPopViewProxy = class("medalPopViewProxy", baseProxy)
function medalPopViewProxy:onRegisterEvent()
	print("=======medalPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_MEDALONSHOW", handler(self, self.msgBackData))
end
function medalPopViewProxy:msgBackData(target, data)
	self.view:msgBackData(target, data)
end
return medalPopViewProxy

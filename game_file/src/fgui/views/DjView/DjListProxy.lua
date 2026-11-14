local baseProxy = require("fgui.base.baseProxy")
local DjListProxy = class("DjListProxy", baseProxy)
function DjListProxy:onRegisterEvent()
	print("=======DjListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ATTENTION_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateView))
end
function DjListProxy:updateView()
	self.view:updateView()
end
return DjListProxy

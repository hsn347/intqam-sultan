local baseProxy = require("fgui.base.baseProxy")
local DjInfoProxy = class("DjInfoProxy", baseProxy)
function DjInfoProxy:onRegisterEvent()
	print("=======DjInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_BACK", handler(self, self.initView))
end
function DjInfoProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjInfoProxy

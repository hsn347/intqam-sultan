local baseProxy = require("fgui.base.baseProxy")
local DjSearchProxy = class("DjSearchProxy", baseProxy)
function DjSearchProxy:onRegisterEvent()
	print("=======DjSearchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_AUDIENCE_LIST", handler(self, self.initView))
end
function DjSearchProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjSearchProxy

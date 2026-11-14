local baseProxy = require("fgui.base.baseProxy")
local DjBlackPopProxy = class("DjBlackPopProxy", baseProxy)
function DjBlackPopProxy:onRegisterEvent()
	print("=======DjBlackPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_BLACK_LIST_BACK", handler(self, self.initView))
end
function DjBlackPopProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjBlackPopProxy

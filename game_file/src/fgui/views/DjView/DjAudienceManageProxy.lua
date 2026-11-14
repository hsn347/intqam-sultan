local baseProxy = require("fgui.base.baseProxy")
local DjAudienceManageProxy = class("DjAudienceManageProxy", baseProxy)
function DjAudienceManageProxy:onRegisterEvent()
	print("=======DjAudienceManageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_AUDIENCE_INFO", handler(self, self.initView))
end
function DjAudienceManageProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjAudienceManageProxy

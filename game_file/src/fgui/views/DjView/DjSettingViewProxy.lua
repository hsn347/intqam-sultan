local baseProxy = require("fgui.base.baseProxy")
local DjSettingViewProxy = class("DjSettingViewProxy", baseProxy)
function DjSettingViewProxy:onRegisterEvent()
	print("=======DjSettingViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_BACK", handler(self, self.initView))
end
function DjSettingViewProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjSettingViewProxy

local baseProxy = require("fgui.base.baseProxy")
local DjApplyListProxy = class("DjApplyListProxy", baseProxy)
function DjApplyListProxy:onRegisterEvent()
	print("=======DjApplyListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_APPLY_LIST_BACK", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ROOM_SPEAK_UPDATE", handler(self, self.updateView))
end
function DjApplyListProxy:initView(target, data)
	self.view:initView(target, data)
end
function DjApplyListProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return DjApplyListProxy

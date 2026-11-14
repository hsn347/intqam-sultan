local baseProxy = require("fgui.base.baseProxy")
local ManorLayoutEditProxy = class("ManorLayoutEditProxy", baseProxy)
function ManorLayoutEditProxy:onRegisterEvent()
	print("=======ManorLayoutEditProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_SAVE", handler(self, self.onMsgManorLayoutSave))
end
function ManorLayoutEditProxy:onMsgManorLayoutSave(...)
	self.view:onMsgManorLayoutSave(...)
end
return ManorLayoutEditProxy

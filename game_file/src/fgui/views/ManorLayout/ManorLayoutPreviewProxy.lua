local baseProxy = require("fgui.base.baseProxy")
local ManorLayoutPreviewProxy = class("ManorLayoutPreviewProxy", baseProxy)
function ManorLayoutPreviewProxy:onRegisterEvent()
	print("=======ManorLayoutPreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_LIKE", handler(self, self.onMsgManorLayoutLike))
end
function ManorLayoutPreviewProxy:onMsgManorLayoutLike(...)
	self.view:onMsgManorLayoutLike(...)
end
return ManorLayoutPreviewProxy

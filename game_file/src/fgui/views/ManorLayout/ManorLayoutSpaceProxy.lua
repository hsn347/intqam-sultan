local baseProxy = require("fgui.base.baseProxy")
local ManorLayoutSpaceProxy = class("ManorLayoutSpaceProxy", baseProxy)
function ManorLayoutSpaceProxy:onRegisterEvent()
	print("=======ManorLayoutSpaceProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_RANDOM", handler(self, self.onMsgManorLayoutRandom))
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_LIKE", handler(self, self.onMsgManorLayoutLike))
end
function ManorLayoutSpaceProxy:onMsgManorLayoutRandom(...)
	self.view:onMsgManorLayoutRandom(...)
end
function ManorLayoutSpaceProxy:onMsgManorLayoutLike(...)
	self.view:onMsgManorLayoutLike(...)
end
return ManorLayoutSpaceProxy

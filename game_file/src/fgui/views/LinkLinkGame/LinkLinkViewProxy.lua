local baseProxy = require("fgui.base.baseProxy")
local LinkLinkViewProxy = class("LinkLinkViewProxy", baseProxy)
function LinkLinkViewProxy:onRegisterEvent()
	print("=======LinkLinkViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LINKLINK_CHOOSE", handler(self, self.judgeLink))
	SoraDAddMessage(self, "MESSAGE_LINKLINK_SHADOW", handler(self, self.updateClick))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
end
function LinkLinkViewProxy:judgeLink(target, data)
	self.view:judgeLink(data.index)
end
function LinkLinkViewProxy:updateClick(target, data)
	self.view:updateClick(data.isShadow)
end
function LinkLinkViewProxy:onResultClose()
	self.view:close()
end
return LinkLinkViewProxy

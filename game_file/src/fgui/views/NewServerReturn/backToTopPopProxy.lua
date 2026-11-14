local baseProxy = require("fgui.base.baseProxy")
local backToTopPopProxy = class("backToTopPopProxy", baseProxy)
function backToTopPopProxy:onRegisterEvent()
	print("=======backToTopPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_BACK_TO_TOP_UNLOCK", handler(self, self.unlockGift))
end
function backToTopPopProxy:unlockGift(target, data)
	self.view:close()
end
return backToTopPopProxy

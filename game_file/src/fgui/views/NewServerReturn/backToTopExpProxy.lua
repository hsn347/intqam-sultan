local baseProxy = require("fgui.base.baseProxy")
local backToTopExpProxy = class("backToTopExpProxy", baseProxy)
function backToTopExpProxy:onRegisterEvent()
	print("=======backToTopExpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_BACK_TO_TOP_EXP_GIFT", handler(self, self.unlockGift))
end
function backToTopExpProxy:unlockGift(target, data)
	self.view:close()
end
return backToTopExpProxy

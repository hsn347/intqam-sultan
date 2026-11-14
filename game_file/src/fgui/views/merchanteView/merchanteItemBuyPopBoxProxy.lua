local baseProxy = require("fgui.base.baseProxy")
local merchanteItemBuyPopBoxProxy = class("merchanteItemBuyPopBoxProxy", baseProxy)
function merchanteItemBuyPopBoxProxy:onRegisterEvent()
	print("=======merchanteItemBuyPopBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STORES_PURCHASE", handler(self, self.playUseAction))
end
function merchanteItemBuyPopBoxProxy:playUseAction(target, data)
	self.view:playUseAction(target, data)
end
return merchanteItemBuyPopBoxProxy

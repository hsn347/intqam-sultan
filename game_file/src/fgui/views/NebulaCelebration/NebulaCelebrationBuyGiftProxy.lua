local baseProxy = require("fgui.base.baseProxy")
local NebulaCelebrationBuyGiftProxy = class("NebulaCelebrationBuyGiftProxy", baseProxy)
function NebulaCelebrationBuyGiftProxy:onRegisterEvent()
	print("=======NebulaCelebrationBuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_BUY_GIFT_SUCCESS", handler(self, self.onBuyGiftSuccess))
end
function NebulaCelebrationBuyGiftProxy:onBuyGiftSuccess()
	self.view:close()
end
return NebulaCelebrationBuyGiftProxy

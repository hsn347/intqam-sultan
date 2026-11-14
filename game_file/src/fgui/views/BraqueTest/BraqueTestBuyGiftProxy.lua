local baseProxy = require("fgui.base.baseProxy")
local BraqueTestBuyGiftProxy = class("BraqueTestBuyGiftProxy", baseProxy)
function BraqueTestBuyGiftProxy:onRegisterEvent()
	print("=======BraqueTestBuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001562_BUY_GIFT", handler(self, self.onMsgBuyGift))
end
function BraqueTestBuyGiftProxy:onMsgBuyGift(target, event)
	if event.activityID == self.view.activityID then
		self.view:removeFromParent()
	end
end
return BraqueTestBuyGiftProxy

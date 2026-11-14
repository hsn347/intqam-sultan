local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_DecreeGiftProxy = class("RoaringFlame_DecreeGiftProxy", baseProxy)
function RoaringFlame_DecreeGiftProxy:onRegisterEvent()
	print("=======RoaringFlame_DecreeGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUYGIFT", handler(self, self.onBuyGiftMsg))
end
function RoaringFlame_DecreeGiftProxy:onBuyGiftMsg(target, data)
	self.view:onBuyGiftMsg(target, data)
end
return RoaringFlame_DecreeGiftProxy

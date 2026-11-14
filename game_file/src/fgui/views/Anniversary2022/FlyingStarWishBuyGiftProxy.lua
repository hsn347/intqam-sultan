local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseProxy = require("fgui.base.baseProxy")
local FlyingStarWishBuyGiftProxy = class("FlyingStarWishBuyGiftProxy", baseProxy)
function FlyingStarWishBuyGiftProxy:onRegisterEvent()
	print("=======FlyingStarWishBuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FLYING_STAR_WISH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateData))
end
function FlyingStarWishBuyGiftProxy:refreshView(target, data)
	if self.view then
		if data.subMsg == "buyListUpdate" then
			self.view:initData()
		elseif data.subMsg == "buySuccess" then
			self.view:clearBuyList()
			self.view:close()
		elseif data.subMsg == "giveTimeEnd" then
			SoraDShowMsgTip(i18n("giftgiving_text_7"))
			self.view:clearBuyList()
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end
end
function FlyingStarWishBuyGiftProxy:updateData()
	if self.view then
		self.view:initData()
	end
end
return FlyingStarWishBuyGiftProxy

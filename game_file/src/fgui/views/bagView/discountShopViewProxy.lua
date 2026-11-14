local baseProxy = require("fgui.base.baseProxy")
local discountShopViewProxy = class("discountShopViewProxy", baseProxy)
function discountShopViewProxy:onRegisterEvent()
	print("=======discountShopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_DISCOUNT_BUY_BACK", handler(self, self.updateScroll))
end
function discountShopViewProxy:updateScroll()
	self.view:updateScroll()
end
return discountShopViewProxy

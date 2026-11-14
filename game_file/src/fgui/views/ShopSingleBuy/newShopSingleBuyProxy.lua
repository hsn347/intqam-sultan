local baseProxy = require("fgui.base.baseProxy")
local newShopSingleBuyProxy = class("newShopSingleBuyProxy", baseProxy)
function newShopSingleBuyProxy:onRegisterEvent()
	print("=======newShopSingleBuyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.checkLimitItem))
end
function newShopSingleBuyProxy:checkLimitItem(target, data)
	self.view:checkLimitItem(target, data)
end
return newShopSingleBuyProxy

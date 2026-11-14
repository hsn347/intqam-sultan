local baseProxy = require("fgui.base.baseProxy")
local PropBuyViewProxy = class("PropBuyViewProxy", baseProxy)
function PropBuyViewProxy:onRegisterEvent()
	print("=======PropBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.refreshData))
end
function PropBuyViewProxy:refreshData()
	self.view:refreshData()
end
return PropBuyViewProxy

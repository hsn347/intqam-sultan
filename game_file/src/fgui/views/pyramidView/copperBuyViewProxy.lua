local baseProxy = require("fgui.base.baseProxy")
local copperBuyViewProxy = class("copperBuyViewProxy", baseProxy)
function copperBuyViewProxy:onRegisterEvent()
	print("=======copperBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
end
function copperBuyViewProxy:refreshData()
	self.view:refreshData()
end
return copperBuyViewProxy

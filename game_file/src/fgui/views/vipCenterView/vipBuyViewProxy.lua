local baseProxy = require("fgui.base.baseProxy")
local vipBuyViewProxy = class("vipBuyViewProxy", baseProxy)
function vipBuyViewProxy:onRegisterEvent()
	print("=======vipBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
end
function vipBuyViewProxy:refreshData(target, data)
	self.view:refreshData(target, data)
end
return vipBuyViewProxy

local baseProxy = require("fgui.base.baseProxy")
local resourceBuyViewProxy = class("resourceBuyViewProxy", baseProxy)
function resourceBuyViewProxy:onRegisterEvent()
	print("=======resourceBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESBUY_TAB_BACK", handler(self, self.updateTab))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
end
function resourceBuyViewProxy:updateTab(target, data)
	self.view:updateTab(data.rid)
end
function resourceBuyViewProxy:refreshRes(target, data)
	self.view:refreshRes()
end
function resourceBuyViewProxy:update(target, data)
	self.view:initData()
end
return resourceBuyViewProxy

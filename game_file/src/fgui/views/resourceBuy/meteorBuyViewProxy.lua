local baseProxy = require("fgui.base.baseProxy")
local meteorBuyViewProxy = class("meteorBuyViewProxy", baseProxy)
function meteorBuyViewProxy:onRegisterEvent()
	print("=======meteorBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_RESBUY_TAB_BACK", handler(self, self.updateTab))
end
function meteorBuyViewProxy:update(target, data)
	self.view:initData()
end
function meteorBuyViewProxy:updateTab(target, data)
	self.view:updateTab(data.rid)
end
return meteorBuyViewProxy

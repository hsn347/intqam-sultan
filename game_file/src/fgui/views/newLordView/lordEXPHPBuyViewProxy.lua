local baseProxy = require("fgui.base.baseProxy")
local lordEXPHPBuyViewProxy = class("lordEXPHPBuyViewProxy", baseProxy)
function lordEXPHPBuyViewProxy:onRegisterEvent()
	print("=======lordEXPHPBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.initData))
end
function lordEXPHPBuyViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return lordEXPHPBuyViewProxy

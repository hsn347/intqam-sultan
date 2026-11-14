local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_ShopProxy = class("RoaringFlame_ShopProxy", baseProxy)
function RoaringFlame_ShopProxy:onRegisterEvent()
	print("=======RoaringFlame_ShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initView))
end
function RoaringFlame_ShopProxy:initView()
	self.view:initView()
end
return RoaringFlame_ShopProxy

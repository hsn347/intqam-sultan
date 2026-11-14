local baseProxy = require("fgui.base.baseProxy")
local MeteoriteExpBuyProxy = class("MeteoriteExpBuyProxy", baseProxy)
function MeteoriteExpBuyProxy:onRegisterEvent()
	print("=======MeteoriteExpBuyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.updateView))
end
function MeteoriteExpBuyProxy:updateView()
	self.view:updateView()
end
return MeteoriteExpBuyProxy

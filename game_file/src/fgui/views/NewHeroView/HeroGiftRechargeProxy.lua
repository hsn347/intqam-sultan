local baseProxy = require("fgui.base.baseProxy")
local HeroGiftRechargeProxy = class("HeroGiftRechargeProxy", baseProxy)
function HeroGiftRechargeProxy:onRegisterEvent()
	print("=======HeroGiftRechargeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_GIFT_RECHARGE_REFRESH", handler(self, self.msgCallBack))
end
function HeroGiftRechargeProxy:msgCallBack(target, data)
	self.view:msgCallBack(target, data)
end
return HeroGiftRechargeProxy

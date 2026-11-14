local baseProxy = require("fgui.base.baseProxy")
local RechargeViewMonthlyBuyBoxProxy = class("RechargeViewMonthlyBuyBoxProxy", baseProxy)
function RechargeViewMonthlyBuyBoxProxy:onRegisterEvent()
	print("=======RechargeViewMonthlyBuyBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", function(...)
		self:removeView(self.view)
	end)
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", function(...)
		self:removeView(self.view)
	end)
end
return RechargeViewMonthlyBuyBoxProxy

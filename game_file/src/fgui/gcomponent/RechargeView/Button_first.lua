local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_first = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_first", Button_first)
function Button_first:onInit()
	self.road = gRechargeActiveFromEnum.ROAD03
	self:addClickListener(handler(self, self.btnClick))
end
function Button_first:onShow()
	self:updateData(true)
end
function Button_first:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.updateData))
end
function Button_first:updateData(bShow)
	local isRechargeAccout = rechargeActivityCtrl:getIsAccountFirstRecharge()
	local isRecharge = rechargeActivityCtrl:getIsDayFirstRecharge()
	if bShow and isRecharge then
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function Button_first:setRoad(from)
	self.road = from
end
function Button_first:btnClick()
	SoraDPlaySound()
	uiManager:show("rechargeFirstAwardDetail")
	if self.road then
		print("userSDKManager.logEvent", self.road)
		_ENV = self.road
		self.road.entrance = self.road
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_first_award_view, self.road)
	end
end
return Button_first

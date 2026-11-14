local Activity_9001624_BuyGiftPanel = include_fgui("Activity_9001624_BuyGiftPanel")
local Activity_9001637_BuyGiftPanel = class("Activity_9001637_BuyGiftPanel", Activity_9001624_BuyGiftPanel)
function Activity_9001637_BuyGiftPanel:ctor(...)
	Activity_9001637_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001637_BuyGiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATE_CORBAN
end
function Activity_9001637_BuyGiftPanel:onInit()
	local activityID = self.param and self.param.activityID
	if activityID then
		self.activityID = activityID
	end
	Activity_9001637_BuyGiftPanel.super.onInit(self)
end
function Activity_9001637_BuyGiftPanel:updateView(...)
	Activity_9001637_BuyGiftPanel.super.updateView(self, ...)
	self.fields.GiftAward:scrollToView(0)
end
function Activity_9001637_BuyGiftPanel:onSpecialItemRenderer(index, obj)
	local item = self.allSpecialAward[index + 1]
	_UPVALUE0_ = nil
	;(nil).index = index + 1
	obj:initData(item, nil)
end
return Activity_9001637_BuyGiftPanel

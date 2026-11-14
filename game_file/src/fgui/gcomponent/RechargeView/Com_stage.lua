local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_stage", Com_stage)
function Com_stage:onInit()
	self.curVal = 0
	self.boxStatus = 0
	self.fields.Text_treasury:setString(i18n("spcial_office_text_01"))
	self.fields.Button_specialGift:addClickListener(handler(self, self.btnClickSpecialGifts))
	self.fields.Button_specialGift:fixPos()
	self.fields.Text_treasury:fixPos()
	self.fields.Bar:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Text_progressBar:fixPos()
	self.fields.n1:fixPos()
	self.fields.n2:fixPos()
end
function Com_stage:onShow()
end
function Com_stage:initData(curVal, maxVal, isReceiveSpecialGift)
	self.curVal = curVal
	self.maxVal = maxVal
	self.boxStatus = 0
	self.fields.Bar:setMax(self.maxVal)
	self.fields.Bar:setValue(self.curVal)
	_ENV = nil
	;(nil).member = self.curVal
	;(nil).total = self.maxVal
	self.fields.Text_progressBar:setString(i18n("common_text_155", nil))
	if isReceiveSpecialGift then
		self.boxStatus = 2
	else
		self.boxStatus = self.curVal >= self.maxVal and 1 or 0
	end
	self.fields.Button_specialGift:setStatus(self.boxStatus)
end
function Com_stage:btnClickSpecialGifts()
	SoraDPlaySound()
	if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
		local dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
		_ENV = activityShowCtrl
		activityShowCtrl.content = i18n("spcial_office_text_03")
		if not dailyDiscountGiftCtrl:getspecialGiftData() then
			_ENV = dailyDiscountGiftCtrl:getspecialGiftData()
		end
		activityShowCtrl.giftsData = dailyDiscountGiftCtrl:getspecialGiftData()
		activityShowCtrl.receiveTime = dailyDiscountGiftData.rewardGiftTime
		activityShowCtrl.curType = "special"
		local activityShowCtrl.buyGiftCount, data = self.curVal, activityShowCtrl
		_ENV = nil
		;(nil).data = data
		uiManager:show("rechargeDailyPopView", nil)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return Com_stage

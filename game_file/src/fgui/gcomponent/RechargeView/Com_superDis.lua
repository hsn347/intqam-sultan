local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_superDis = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_superDis", Com_superDis)
function Com_superDis:onInit()
	self.buyStatus = 0
	self.payType = 1
	self.superRID = nil
	self.fields.Text_superDes1:setString(i18n("recharge_special_001"))
	self.fields.Text_superDes2:setString(i18n("recharge_special_002"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Btn_OAP:addClickListener(handler(self, self.onClickBuy))
	self.fields.Lab_discount:fixPos()
	self.fields.Text_superDes1:fixPos()
end
function Com_superDis:onShow()
end
function Com_superDis:initData(data, payType, superRID)
	self.payType = payType
	self.superRID = superRID
	self.fields.Lab_discount:setString(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")
	self.fields.Button_buy:setVisible(payType == 1)
	self.fields.Btn_OAP:setVisible(payType ~= 1)
	if payType == 1 then
		self.fields.Button_buy:initData(data.priceForDollar, data.originalPriceForDollar)
	else
		self.fields.Btn_OAP:initData(data.priceForDollar, data.originalPriceForDollar, superRID)
	end
	self.dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
	local buyGiftList = self.dailyDiscountGiftData.buyGiftList
	if buyGiftList[tostring(self.superRID)] then
		self.buyStatus = 2
		self.fields.Button_buy:setEnabled(false)
		self.fields.Button_buy:setTitle(i18n("common_text_4376"))
		if payType ~= 1 then
			self.fields.Button_buy:setVisible(true)
			self.fields.Btn_OAP:setVisible(false)
		end
	else
		if table.nums(buyGiftList) > 0 then
			self.fields.Button_buy:setBright(false)
			self.fields.Button_buy:setTouchEnabled(true)
			self.buyStatus = 1
		else
			self.fields.Button_buy:setEnabled(true)
			self.buyStatus = 0
		end
		self.fields.Button_buy:initData(data.priceForDollar, data.originalPriceForDollar)
	end
end
function Com_superDis:onClickBuy(button, event)
	SoraDPlaySound()
	if self.buyStatus == 0 then
		if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
			if SoraDCheckOAPIsOpen(self.superRID) and self.payType == 2 then
				SoraDShowH5PurchaseView(self.superRID)
			else
				paymentManager.normalGiftBuyClassify(self.superRID)
			end
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif self.buyStatus == 1 then
		SoraDShowMsgTip(i18n("recharge_special_003"))
	end
end
return Com_superDis

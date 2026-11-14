local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeGiftItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeGiftItem", rechargeGiftItem)
function rechargeGiftItem:onInit()
	self.giftsList, _ENV = nil, nil
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.CCS_OAPButton:addClickListener(handler(self, self.onClickBuy))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.nbg:fix()
	self:fixChildrenPos()
end
function rechargeGiftItem:onShow()
end
function rechargeGiftItem:onItemRenderer(index, obj)
	obj:initData(self.giftsList[index + 1].id, self.giftsList[index + 1].count)
end
function rechargeGiftItem:initData(data, payType, hasBuySuper)
	self.giftData = data
	self.payType = payType
	self.hasBuySuper = hasBuySuper
	self.fields.Button_buy:setString(self.giftData.priceForDollar)
	self.fields.Text_brfore_price:setString(self.giftData.originalPriceForDollar)
	self.fields.Text_gift_name:setString(self.giftData.titleName)
	self.fields.Lab_discount:setString(tostring(math.floor(self.giftData.originalPrice / self.giftData.price * 100)) .. "%")
	if self.giftData.state == 1 then
		self.fields.Text_brfore_price:setVisible(false)
		self.fields.line:setVisible(false)
		self.fields.Button_buy:setString(i18n("common_text_4376"))
		self.fields.Button_buy:setEnabled(false)
	else
		self.fields.Text_brfore_price:setVisible(true)
		self.fields.line:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
		if self.hasBuySuper then
			self.fields.Button_buy:setEnabled(false)
		end
	end
	if self.payType == 2 then
		if SoraDCheckOAPIsOpen(self.giftData.rechargeID) and self.giftData.state ~= 1 then
			self.fields.CCS_OAPButton:setVisible(true)
			self.fields.Button_buy:setVisible(false)
			self.fields.CCS_OAPButton:initData(self.giftData.priceForDollar, self.giftData.originalPriceForDollar, self.giftData.rechargeID)
			self.fields.Text_brfore_price:setVisible(false)
			self.fields.line:setVisible(false)
			if self.hasBuySuper then
				self.fields.CCS_OAPButton:setEnabled(false)
			end
		else
			self.fields.CCS_OAPButton:setVisible(false)
			self.fields.Button_buy:setVisible(true)
			if self.hasBuySuper then
				self.fields.Button_buy:setEnabled(false)
			end
		end
	else
		self.fields.CCS_OAPButton:setVisible(false)
		self.fields.Button_buy:setVisible(true)
	end
	_UPVALUE2_ = true
	;(true)[1] = "id"
	;(true)[2] = "count"
	self.giftsList = serviceFunctions.tableFormat(self.giftData.gift, true)
	self.fields.List:setNumItems(#self.giftsList)
end
function rechargeGiftItem:onClickBuy()
	SoraDPlaySound()
	if self.hasBuySuper then
		SoraDShowMsgTip(i18n("recharge_special_004"))
	elseif activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
		SoraDShowMsgBox(i18n("recharge_special_005"), i18n("common_text_054"), nil, function(event)
			if event == MSGBOX_CALLBACK_YES then
				if SoraDCheckOAPIsOpen(self.giftData.rechargeID) and self.payType == 2 then
					SoraDShowH5PurchaseView(self.giftData.rechargeID)
				else
					paymentManager.normalGiftBuyClassify(self.giftData.rechargeID)
				end
			end
		end)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return rechargeGiftItem

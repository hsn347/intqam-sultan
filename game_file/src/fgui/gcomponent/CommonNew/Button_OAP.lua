local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_OAP = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_OAP", Button_OAP)
fgui.register_extension("ui://CommonNew/Button_OAPNormal", Button_OAP)
function Button_OAP:onInit()
	self.fields.Text_NowPrice:setIconScale(0.7)
end
function Button_OAP:onShow()
end
function Button_OAP:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateItemNum))
end
function Button_OAP:initData(nowPrice, oriPrice, giftID)
	self.giftID = giftID
	self:setEnabled(true)
	self.controllers.c2:setSelectedIndex(oriPrice and 1 or 0)
	if self.controllers.c1:getSelectedIndex() == 0 then
		self.fields.Text_NowPrice:setStrOnly(nowPrice)
		if oriPrice then
			self.fields.Text_OriPrice:setString(oriPrice)
		end
	else
		self:updateItemNum()
	end
end
function Button_OAP:checkCouponID()
	local itemNeedNum = paymentManager.rid2TokenPirce(self.giftID) or 0
	local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
	local nowPrice = math.ceil(discount / 100 * itemNeedNum)
	local couponID = backpackCtrl:getRechargeGiftCoupon(nowPrice)
	if couponID then
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Text_NowPrice:setStrOnly(i18n("common_text_4849"))
	else
		self.controllers.c2:setSelectedIndex(discount < 100 and 1 or 0)
	end
	return couponID ~= nil
end
function Button_OAP:updateItemNum()
	if self.controllers.c1:getSelectedIndex() == 0 then
		return
	end
	if self:checkCouponID() then
		return
	end
	if self.controllers.c1:getSelectedIndex() == 1 then
		self.itemNeedNum = paymentManager.rid2TokenPirce(self.giftID) or 0
		self.itemOwnNum = backpackCtrl:getItemCount(TOKEN_ITEM)
		local nowPrice = self.itemNeedNum
		local oriPriceStr
		local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
		if discount < 100 then
			nowPrice = math.ceil(discount / 100 * self.itemNeedNum)
			oriPriceStr = SoraDConvertNumberWithUnit(self.itemNeedNum)
		end
		self.controllers.c2:setSelectedIndex(discount < 100 and 1 or 0)
		_ENV = discount < 100 and 1 or 0
		;(discount < 100 and 1 or 0).member = SoraDConvertNumberWithUnit(self.itemOwnNum)
		_ENV, _ENV, (discount < 100 and 1 or 0).total = nowPrice, SoraDConvertNumberWithUnit(nowPrice), SoraDConvertNumberWithUnit(nowPrice)
		_ENV, SoraDConvertNumberWithUnit(nowPrice).member, nowPrice.color = nowPrice, nowPrice, nowPrice > self.itemOwnNum and "#E02B2B" or "#F1C35B"
		SoraDConvertNumberWithUnit(nowPrice).__default, nowPrice.color = nowPrice, "#F1C35B"
		local nowPriceStr = i18n_html("common_text_155", discount < 100 and 1 or 0, (SoraDConvertNumberWithUnit(nowPrice)))
		self.fields.Text_NowPrice:setString(nowPriceStr)
		self.fields.Text_OriPrice:setString(oriPriceStr)
	end
end
function Button_OAP:hideLine(isShow)
	self.controllers.c3:setSelectedIndex(isShow and 0 or 1)
end
function Button_OAP:setEnabled(value)
	self:setTouchable(value)
	self:setGrayed(not value)
end
return Button_OAP

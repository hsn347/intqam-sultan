local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001735/Com_giftSingle", Com_giftSingle)
function Com_giftSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.Lab_discount:fixPos()
end
function Com_giftSingle:onShow()
end
function Com_giftSingle:initData(data)
	self.giftData = data
	self.fields.Text_name:setString(i18n(self.giftData.rechargeName))
	self.fields.Lab_discount:setTitle(tostring(math.floor(self.giftData.discount[2] / self.giftData.discount[1])) .. "%")
	_UPVALUE2_ = tostring(math.floor(self.giftData.discount[2] / self.giftData.discount[1])) .. "%"
	;(tostring(math.floor(self.giftData.discount[2] / self.giftData.discount[1])) .. "%")[1] = "id"
	;(tostring(math.floor(self.giftData.discount[2] / self.giftData.discount[1])) .. "%")[2] = "count"
	self.giftReward = serviceFunctions.tableFormat(self.giftData.reward, tostring(math.floor(self.giftData.discount[2] / self.giftData.discount[1])) .. "%")
	self.fields.List_reward:setNumItems(#self.giftReward)
	self.buyCount = activity_9001735_Ctrl:getDailyGiftBuyCount(self.giftData.rechargeID)
	self.leftCount = self.giftData.extraData - self.buyCount
	_ENV = "count"
	;("count").cur = self.leftCount
	;("count").total = self.giftData.extraData
	self.fields.Text_limit:setString(i18n("common_text_4417", "count"))
	local showPrice, isGetPrice = paymentManager.judgePrice(self.giftData.rechargeID, self.giftData.rechargePrice)
	local discount = self.giftData.originalPrice / self.giftData.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(self.giftData.rechargeID, showPrice, discount, self.giftData.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(self.leftCount > 0)
end
function Com_giftSingle:updateOutAppPurchase()
	_ENV = nil
	;(nil).rid = self.giftData.rechargeID
	;(nil).nowPrice = self.nowPrice
	_ENV, (nil).oriPrice = self.oriPrice, self.oriPrice
	;(nil).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD67
	;(nil).handleBuyClick = handler(self, self.btnBuyClick)
	;(nil).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(nil)
end
function Com_giftSingle:itemRenderer_List_reward(index, obj)
	local data = self.giftReward[index + 1]
	obj:initData(data.id, data.count)
end
function Com_giftSingle:btnBuyClick()
	SoraDPlaySound()
	if self.leftCount > 0 then
		paymentManager.normalGiftBuyClassify(self.giftData.rechargeID)
	else
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
	end
end
function Com_giftSingle:onClickItemBuyGift()
	SoraDPlaySound()
	if self.leftCount < 1 then
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
		return false
	end
	return true
end
return Com_giftSingle

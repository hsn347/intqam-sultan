local rechargeRead = include("rechargeRead")
local activity_9001639_Ctrl = SoraDGetCtrl("activity_9001639_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeGiftSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001639/rechargeGiftSingle", rechargeGiftSingle)
function rechargeGiftSingle:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self:fixChildrenPos()
end
function rechargeGiftSingle:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function rechargeGiftSingle:onShow()
end
function rechargeGiftSingle:initData(data)
	self.data = data
	local giftCfg = rechargeRead.getPageViewData(self.data.id)
	self.fields.Text_name:setString(i18n(giftCfg.activeName))
	self.leftTimes = math.max(0, self.data.purchaselimit - activity_9001639_Ctrl:getGiftBoughtCount(self.data.id))
	rechargeRead = activity_9001639_Ctrl
	activity_9001639_Ctrl.num = fguiHelper.getColorString(self.leftTimes > 0 and "#D7C39B" or "#FF0000", self.leftTimes)
	self.fields.Text_times:setString(i18n("giftgiving_text_28", activity_9001639_Ctrl))
	self.itemList = self.data.result
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Lab_discount:setTitle(tostring(math.floor(self.data.originalPrice / self.data.price * 100)) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(self.data.id, self.data.price)
	local discount = self.data.originalPrice / self.data.price
	local oriShowPrice = paymentManager.calculateDiscount(self.data.id, showPrice, discount, self.data.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
end
function rechargeGiftSingle:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.data.id) then
		self.fields.Com_OutAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.data.id
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD53
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		;(false).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
		self.fields.Com_OutAppPurchaseButtons:initData(false)
	else
		self.fields.Com_OutAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
	end
end
function rechargeGiftSingle:onClickItemBuyGift()
	SoraDPlaySound()
	if self.leftTimes < 1 then
		SoraDShowMsgTip(i18n("opt_package_text_11"))
		return
	end
	return true
end
function rechargeGiftSingle:btnBuyClick()
	SoraDPlaySound()
	if self.leftTimes < 1 then
		SoraDShowMsgTip(i18n("opt_package_text_11"))
		return
	end
	paymentManager.normalGiftBuyClassify(self.data.id)
	paymentManager.OnemtReadyBuy(self.data.id, gRechargeActiveFromEnum.ROAD53)
end
return rechargeGiftSingle

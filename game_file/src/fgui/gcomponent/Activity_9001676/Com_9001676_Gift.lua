local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_Gift = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local rechargeRead = include("rechargeRead")
fgui.register_extension("ui://Activity_9001676/Com_9001676_Gift", Com_9001676_Gift)
function Com_9001676_Gift:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001676_Gift:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Com_9001676_Gift:onShow()
end
function Com_9001676_Gift:initData(giftCfg)
	self.giftCfg = giftCfg
	local rechargeCfg = rechargeRead.getPageViewData(self.giftCfg.giftId)
	self.fields.Text_name:setString(i18n(rechargeCfg.activeName))
	activity_9001676_Ctrl = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName)[1] = "id"
	i18n(rechargeCfg.activeName)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(giftCfg.gift, i18n(rechargeCfg.activeName))
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).id = 1001
	i18n(rechargeCfg.activeName).count = giftCfg.gold
	table.insert(self.itemList, i18n(rechargeCfg.activeName))
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Lab_discount:setTitle(tostring(self.giftCfg.discount) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(giftCfg.giftId, giftCfg.price)
	local discount = giftCfg.originalPrice / giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(giftCfg.giftId, showPrice, discount, giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	local buyNum = activity_9001676_Ctrl:getGiftDayBuyNum(self.giftCfg.giftId)
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).cur = buyNum
	i18n(rechargeCfg.activeName).total = giftCfg.extraData
	self.fields.Text_limitNum:setString(i18n("common_text_4417", i18n(rechargeCfg.activeName)))
	self.isMax = buyNum >= giftCfg.extraData
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(not self.isMax)
end
function Com_9001676_Gift:updateOutAppPurchase()
	self.fields.Com_OutAppPurchaseButtons:setVisible(true)
	_ENV = true
	;(true).rid = self.giftCfg.giftId
	;(true).nowPrice = self.nowPrice
	_ENV, (true).oriPrice = self.oriPrice, self.oriPrice
	;(true).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD53
	;(true).handleBuyClick = handler(self, self.btnBuyClick)
	;(true).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(true)
end
function Com_9001676_Gift:onClickItemBuyGift()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("back_recharge_text13"))
		return false
	end
	return true
end
function Com_9001676_Gift:btnBuyClick()
	SoraDPlaySound()
	if not self.isMax then
		paymentManager.normalGiftBuyClassify(self.giftCfg.giftId)
		paymentManager.OnemtReadyBuy(self.giftCfg.giftId, gRechargeActiveFromEnum.ROAD53)
	else
		SoraDShowMsgTip(i18n("back_recharge_text13"))
	end
end
return Com_9001676_Gift

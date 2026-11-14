local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_Gift = fgui.extension_class(fgui.GComponent, baseComponent)
local rechargeRead = include("rechargeRead")
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
fgui.register_extension("ui://Activity_9001680/Com_9001680_Gift", Com_9001680_Gift)
function Com_9001680_Gift:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001680_Gift:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Com_9001680_Gift:onShow()
end
function Com_9001680_Gift:initData(giftCfg)
	self.giftCfg = giftCfg
	local rechargeCfg = rechargeRead.getPageViewData(self.giftCfg.giftId)
	self.fields.Text_name:setString(i18n(rechargeCfg.activeName))
	activity_9001680_Ctrl = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName)[1] = "id"
	i18n(rechargeCfg.activeName)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(giftCfg.gift, i18n(rechargeCfg.activeName))
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).id = 1001
	i18n(rechargeCfg.activeName).count = giftCfg.gold
	table.insert(self.itemList, i18n(rechargeCfg.activeName))
	self.fields.List:setNumItems(#self.itemList)
	local discount = giftCfg.originalPrice / giftCfg.price
	self.fields.Lab_discount:setTitle(tostring(self.giftCfg.discount) .. "%")
	local showPrice, isGetPrice = paymentManager.judgePrice(giftCfg.giftId, giftCfg.price)
	local discount = giftCfg.originalPrice / giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(giftCfg.giftId, showPrice, discount, giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	local buyNum = activity_9001680_Ctrl:getGiftDayBuyNum(self.giftCfg.giftId, self.giftCfg.gifttype)
	if self.giftCfg.gifttype == 1 then
		rechargeRead = i18n(rechargeCfg.activeName)
		i18n(rechargeCfg.activeName).left = buyNum
		i18n(rechargeCfg.activeName).total = giftCfg.extraData
		self.fields.Text_limitNum:setString(i18n("pray_text_14", i18n(rechargeCfg.activeName)))
	else
		rechargeRead = i18n("pray_text_14", i18n(rechargeCfg.activeName))
		i18n("pray_text_14", i18n(rechargeCfg.activeName)).cur = buyNum
		i18n("pray_text_14", i18n(rechargeCfg.activeName)).total = giftCfg.extraData
		self.fields.Text_limitNum:setString(i18n("common_text_4417", i18n("pray_text_14", i18n(rechargeCfg.activeName))))
	end
	self.isMax = buyNum >= giftCfg.extraData
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(not self.isMax)
end
function Com_9001680_Gift:updateOutAppPurchase()
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
function Com_9001680_Gift:onClickItemBuyGift()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("back_recharge_text13"))
		return false
	end
	return true
end
function Com_9001680_Gift:btnBuyClick()
	SoraDPlaySound()
	if not self.isMax then
		paymentManager.normalGiftBuyClassify(self.giftCfg.giftId)
		paymentManager.OnemtReadyBuy(self.giftCfg.giftId, gRechargeActiveFromEnum.ROAD53)
	else
		SoraDShowMsgTip(i18n("back_recharge_text13"))
	end
end
return Com_9001680_Gift
